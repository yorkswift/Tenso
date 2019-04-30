
import Foundation
import Photos
import PeakOperation

class CreateTensoZoomOperation: ConcurrentOperation {
    
    let targetLevel : Int
    var currentStack : TensoStack?
    let targetSize = CGSize(width: 300, height: 145)
    
    init(at level: Int) {
        targetLevel = level
    }
    
    override func execute() {
        
        print("Zoom Level \(targetLevel)")
        
        if var currentStack = currentStack {
        
        if let zoomRect = Array(currentStack.zooms.suffix(targetLevel)).first {
            
            let cropRect = zoomRect
                //.applying(CGAffineTransform(translationX: 0, y: -(midwayZoom.height / 3)))
                .applying(CGAffineTransform(scaleX: 1.0/CGFloat(currentStack.size.width), y: 1.0/CGFloat(currentStack.size.height)))
            
            PhotoRepository.shared.fetchCroppedPhoto(for: currentStack.asset, at: targetSize, cropped: cropRect, completion: { image in
                
                    if let zoomImage = image {
                        
                        currentStack.stack.append(zoomImage)
                        
                        print(currentStack.stack)
                        
                        
                        self.finish()
                        //self.append(x2, cropped: nil, to: &newStack, focusRect: firstFace)
                        
                    }
                
            })
                
        }
            
        }
        
       // finish()
    }
}
