import Foundation
import UIKit
import Photos

class RecentPhotosViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var photos: PHFetchResult<PHAsset>!
    fileprivate var thumbnailSize: CGSize!
    
    weak var messagesDelegate: MessagesAppConversationDeletgate?
    
    enum Segues : String {
        case ShowTensoModeController
        case HideTensoModeController
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let scale = UIScreen.main.scale
        let cellSize = (collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func reload(){
        
        photos = PhotoRepository.shared.fetchAll()
        
        self.collectionView?.reloadData()
        
    }
    
    // MARK: UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoRepository.shared.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let asset = PhotoRepository.shared.asset(at: indexPath.item) else {
            fatalError("no item at path \(indexPath.item)")
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RecentPhotoCell.self), for: indexPath) as? RecentPhotoCell
            else { fatalError("unexpected cell in collection view") }

        cell.representedAssetIdentifier = asset.localIdentifier
        
        PhotoRepository.shared.fetchPhoto(for: asset, at: thumbnailSize, completion: { image in

            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnail = image
            }
        })
        
        return cell
        
    }
    
    // MARK :  Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? TensoModeViewController
            else { fatalError("unexpected view controller for segue") }
        
        let indexPath = collectionView!.indexPath(for: sender as! UICollectionViewCell)!
        destination.selectedPhotoIndex = indexPath.item
        destination.messagesDelegate = messagesDelegate
    
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecentPhotoCell else { return }
        
        messagesDelegate?.recentPhotosDidSelectPhoto(onCompletion: { [weak self] in
        
            self?.performSegue(withIdentifier: String(describing:Segues.ShowTensoModeController), sender: cell)
        
        })
        
    }
    
//    func hideTensoModeController(){
//        
//        self.performSegue(withIdentifier: String(describing:Segues.HideTensoModeController), sender: nil)
//        
//    }    
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = collectionView.bounds.width/3.0
        let cellHeight = cellWidth
        
        return CGSize(width: cellWidth, height: cellHeight)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}
