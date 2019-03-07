import Foundation
import UIKit

class RecentPhotosViewController : UICollectionViewController {
    
    var repository : PhotoRepository?
    
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
        
        repository?.fetchAll()
        
    }
    
    // MARK: UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return repository?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let asset = fetchResult.object(at: indexPath.item)
//
//        // Dequeue a GridViewCell.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RecentPhotoCell.self), for: indexPath) as? RecentPhotoCell
            else { fatalError("unexpected cell in collection view") }
//
//        // Add a badge to the cell if the PHAsset represents a Live Photo.
//        if asset.mediaSubtypes.contains(.photoLive) {
//            cell.livePhotoBadgeImage = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
//        }
//
//        // Request an image for the asset from the PHCachingImageManager.
//        cell.representedAssetIdentifier = asset.localIdentifier
//        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
//            // The cell may have been recycled by the time this handler gets called;
//            // set the cell's thumbnail image only if it's still showing the same asset.
//            if cell.representedAssetIdentifier == asset.localIdentifier {
//                cell.thumbnailImage = image
//            }
//        })
        
        return cell
        
    }
    
    
}
