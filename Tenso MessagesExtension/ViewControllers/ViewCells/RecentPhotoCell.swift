import Foundation
import UIKit

class RecentPhotoCell : UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    var representedAssetIdentifier: String!
    
    var thumbnail: UIImage! {
        didSet {
            photo.image = thumbnail
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
    
    }
    
}
