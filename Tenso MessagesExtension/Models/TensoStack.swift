import Foundation
import Photos

struct TensoStack {
    
    var targetCount = 3
    var asset: PHAsset
    var stack = [UIImage?]()
    var zooms = [CGRect]()
    var composite : UIImage?
    
    init(for photo: PHAsset){
        
        asset = photo
        
    }
    
}
