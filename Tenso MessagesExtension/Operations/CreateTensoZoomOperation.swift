
import Foundation
import Photos
import PeakOperation

class CreateTensoZoomOperation: ConcurrentOperation {
    
    let targetLevel : Int
    let stackIndex : Int
    let targetSize = CGSize(width: 300, height: 145)
    
    init(at level: Int, for index : Int) {
        targetLevel = level
        stackIndex = index
    }
    
    override func execute() {
        
        print("CreateTensoZoomOperation \(stackIndex)")
        
        if let currentStack = TensoRepository.shared.stack(for: stackIndex) {
            
        if let zoomRect = Array(currentStack.zooms.suffix(targetLevel)).first {
            
            let cropRect = zoomRect
                //.applying(CGAffineTransform(translationX: 0, y: -(midwayZoom.height / 3)))
                .applying(CGAffineTransform(scaleX: 1.0/CGFloat(currentStack.size.width), y: 1.0/CGFloat(currentStack.size.height)))
            
            PhotoRepository.shared.fetchCroppedPhoto(for: currentStack.asset, at: targetSize, cropped: cropRect, completion: { image in
                
                    if let zoomImage = image {
                        
                        TensoRepository.shared.add(zoom: zoomImage, for: self.stackIndex)
                        
                        self.finish()
                        
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
