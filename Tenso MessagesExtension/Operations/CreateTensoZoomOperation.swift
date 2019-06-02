
import Foundation
import Photos
import PeakOperation

class CreateTensoZoomOperation: ConcurrentOperation {
    
    let targetLevel : Int
    let stackIndex : Int
    let targetSize = CGSize(width: 300, height: 145)
    
    weak var tensos : TensoRepository?
    weak var photos : PhotoRepository?
    
    init(at level: Int, for index : Int) {
        
        targetLevel = level
        stackIndex = index
        tensos = TensoRepository.shared
        photos = PhotoRepository.shared
    
    }
    
    override func execute() {
        
        if let currentStack = tensos?.stack(for: stackIndex) {
            
        if let zoomRect = Array(currentStack.zooms.suffix(targetLevel)).first {
            
            let cropRectNormalised = zoomRect
             .applying(
                CGAffineTransform(
                    scaleX: 1.0 / CGFloat(currentStack.size.width),
                    y: 1.0 / CGFloat(currentStack.size.height)
                )
            )
            
            photos?.fetchCroppedPhoto(for: currentStack.asset, at: targetSize, cropped: cropRectNormalised, completion: { [weak self] image in
                
                    if let zoomImage = image {
                        
                        if let currentOperation = self {
                        
                            currentOperation.tensos?.add(zoom: zoomImage, for: currentOperation.stackIndex)
                        
                            currentOperation.finish()
                            
                        }
                        
                    } else {
                        
                        //this can happen when the requested crop doesn't exist at that resolution
                        print("failed to crop")
                }
                
                
            })
                
        } else {
            print("failed to get \(targetLevel) from \(currentStack.zooms.count)")
        }
            
        } else {
            print("could not get current stack")
        }
        
       // finish()
    }
}
