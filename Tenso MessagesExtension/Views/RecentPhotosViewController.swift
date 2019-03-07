import Foundation
import UIKit
import Photos

class RecentPhotosViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var repository : PhotoRepository?
    var photos: PHFetchResult<PHAsset>!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        repository = PhotoRepository.shared
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
        
        repository?.fetchPhoto(for: asset, completion: { image in

            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnail = image
            }
        })
        
        return cell
        
    }
    
    
}
