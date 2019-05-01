
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
        
        if let currentStack = TensoRepository.shared.stack(for: stackIndex) {
            
        if let zoomRect = Array(currentStack.zooms.suffix(targetLevel)).first {
            
            let cropRect = zoomRect
                //.applying(CGAffineTransform(translationX: 0, y: -(midwayZoom.height / 3)))
                .applying(CGAffineTransform(scaleX: 1.0/CGFloat(currentStack.size.width), y: 1.0/CGFloat(currentStack.size.height)))
            
            PhotoRepository.shared.fetchCroppedPhoto(for: currentStack.asset, at: targetSize, cropped: cropRect, completion: { image in
                
                    if let zoomImage = image {
                        
                        TensoRepository.shared.add(zoom: zoomImage, for: self.stackIndex)
                        self.finish()
                        //self.append(x2, cropped: nil, to: &newStack, focusRect: firstFace)
                        
                    }
                
            })
                
        }
            
        } else {
            print("could not get current stack")
        }
        
       // finish()
    }
}
