import Foundation
import Photos

struct TensoStack {
    
    var targetCount = 3
    var targetWidth : Double = 500
    var asset: PHAsset
    
    var stack = [UIImage?]()
    var stackComplete = false
    var zooms = [CGRect]()
    
    var composite : UIImage?
    
    
    init(for photo: PHAsset){
        
        asset = photo
        
    }
    
}
