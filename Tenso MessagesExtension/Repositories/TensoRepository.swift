
import Foundation
import Photos

class TensoRepository  {
    
    static let shared = TensoRepository()
    
    let iso216 = 2.squareRoot()
    
    func applyRatioToSize(_ size : Double) ->  CGSize {
        
        return CGSize(width: size, height: size * iso216)
    }
    
    func renderTenso(for stack: TensoStack, on complete : @escaping (_ stack : TensoStack) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
        var newStack = stack
        PhotoRepository.shared.fetchPhoto(for: stack.asset, at: self.applyRatioToSize(500), completion: { image in
            
            if let x1 = image {
                
                newStack.stack.append(x1)
               
                //x2
                let x2Crop = CGRect(x: 0,
                                  y: 0,
                                  width: 200,
                                  height: 200)
                
                if let cutImageRef: CGImage = x1.cgImage?.cropping(to:x2Crop) {
                    
                    let x2: UIImage = UIImage(cgImage: cutImageRef)
                    
                    newStack.stack.append(x2)
                    
                }
                
                //x3
                let x3Crop = CGRect(x: 0,
                                  y: 0,
                                  width: 100,
                                  height: 100)
                

                if let cutImageRef: CGImage = x1.cgImage?.cropping(to:x3Crop) {
                    
                    let x3: UIImage = UIImage(cgImage: cutImageRef)
                    
                    newStack.stack.append(x3)
                 
                    
                }
                    
                DispatchQueue.main.sync {
                    complete(newStack)
                }
                
            }
    
        
        })
            
        }
    
        
    }
    
}
