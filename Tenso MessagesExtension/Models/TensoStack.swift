import Foundation
import Photos

struct TensoStack {
    
    let targetCount = 3
    let targetWidth : Double = 600
    let targetHeight : Double = 342 // 1026 / 3
    
    var size : CGSize
    
    var asset: PHAsset
    
    var stack = [UIImage?]()
    var stackComplete = false
    var zooms = [CGRect]()
    
    var composite : UIImage?
    
    init(for photo: PHAsset, targetSize : CGSize){
        
        asset = photo
        size = targetSize
        
    }
    
}
