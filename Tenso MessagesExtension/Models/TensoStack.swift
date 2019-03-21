import Foundation
import Photos

struct TensoStack {
    
    var targetCount = 3
    var targetWidth : Double = 600
    var targetHeight : Double = 342 //1026 / 3
    var asset: PHAsset
    
    var stack = [UIImage?]()
    var stackComplete = false
    var zooms = [CGRect]()
    
    var composite : UIImage?
    
    
    init(for photo: PHAsset){
        
        asset = photo
        
    }
    
}
