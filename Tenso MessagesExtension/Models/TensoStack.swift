import Foundation
import Photos

struct TensoStack {
    
    var targetCount = 3
    var asset: PHAsset
    var stack = [UIImage?]()
    var zooms = [CGRect]()
    
    init(for photo: PHAsset){
        
        asset = photo
        
    }
    
}
