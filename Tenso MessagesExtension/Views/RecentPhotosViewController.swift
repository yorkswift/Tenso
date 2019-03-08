import Foundation
import UIKit
import Photos

class RecentPhotosViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var repository : PhotoRepository?
    var photos: PHFetchResult<PHAsset>!
    fileprivate var thumbnailSize: CGSize!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        repository = PhotoRepository.shared
        
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
        
        photos = repository?.fetchAll()
        
        self.collectionView?.reloadData()
        
    }
    
    // MARK: UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return repository?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let asset = repository?.asset(at: indexPath.item) else {
            fatalError("no item at path \(indexPath.item)")
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RecentPhotoCell.self), for: indexPath) as? RecentPhotoCell
            else { fatalError("unexpected cell in collection view") }

        cell.representedAssetIdentifier = asset.localIdentifier
        
        repository?.fetchPhoto(for: asset, at: thumbnailSize, completion: { image in

            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnail = image
            }
        })
        
        return cell
        
    }
    
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
