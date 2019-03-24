
import Foundation
import Photos

import Accelerate
import simd


class TensoRepository  {
    
    static let shared = TensoRepository()
    
    let iso216 = 2.squareRoot()
    
    func applyRatioToSize(_ size : Double) ->  CGSize {
        
        return CGSize(width: size, height: size * iso216)
    }
    
    func renderTenso(for stack: TensoStack, on complete : @escaping (_ stack : TensoStack) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            var newStack = stack
            
            PhotoRepository.shared.fetchPhoto(for: newStack.asset, at: newStack.size, completion: { image in
            
            if let x1 = image {
                
                newStack.stack.append(x1)
                
                DispatchQueue.main.sync {
                    complete(newStack)
                }
                
                //x2
                var x2Crop : CGRect
                
                if let firstFace = FeatureRepository.shared.detectFaces(in: x1)?.first {
                    
                    x2Crop = firstFace
                    
                    let secondZoomConstant : CGFloat = 2
                    
                   // let secondZoom = CGRect(
//                        x: firstFace.minX / secondZoomConstant,
//                        y: firstFace.minY / secondZoomConstant ,
//                        width: (x1.size.width + firstFace.width) / secondZoomConstant ,
//                        height: (x1.size.height + firstFace.height) / secondZoomConstant)
                    
                    
                    let zooms: [CGRect] = stride(from: 0.0, to: 1.0, by: 1 / 10).map { x in
                        
                       return CGRect(
                        x: CGFloat(simd_mix(Float(0), Float(firstFace.minX), Float(x) )),
                        y:  CGFloat(simd_mix(Float(0), Float(firstFace.minY), Float(x) )),
                        width: CGFloat(simd_mix(Float(x1.size.width), Float(firstFace.width), Float(x) )),
                        height: CGFloat(simd_mix(Float(x1.size.height), Float(firstFace.height), Float(x) ))
                        )
                    
                    }
                    
                    print(zooms)
                    
                    let secondZoom = self.tween(between: x1, and: firstFace, by: 2)
                    
                    
                    if let cutImageRef: CGImage = x1.cgImage?.cropping(to:secondZoom) {
                        
                        let x2: UIImage = UIImage(cgImage: cutImageRef)
                        
                        newStack.stack.append(x2)
                        
                    }
                    
                    let thirdZoom = self.tween(between: x1, and: firstFace, by: 0.9)
                    
                    if let cutImageRef: CGImage = x1.cgImage?.cropping(to:thirdZoom) {
                        
                        let x3: UIImage = UIImage(cgImage: cutImageRef)
                        
                        newStack.stack.append(x3)
                        
                    }
                    
                } else {
               
                    x2Crop = CGRect(x: 0,
                                  y: 0,
                                  width: 200,
                                  height: 200)
                    
                    
                    if let cutImageRef: CGImage = x1.cgImage?.cropping(to:x2Crop) {
                        
                        let x2: UIImage = UIImage(cgImage: cutImageRef)
                        
                        newStack.stack.append(x2)
                        
                    }
                    
                    
                    
                }
                
                
               
                
            }
            
            
            newStack.stackComplete = true
            
            DispatchQueue.main.sync {
                complete(newStack)
            }
    
        
        })
            
        }
    
        
    }
    
    func tween(between: UIImage, and finish :CGRect, by factor : CGFloat) -> CGRect {
        

        let inverseFactor = (1 / (1 - factor))
        
        return CGRect(
            x: finish.minX / inverseFactor,
            y: finish.minY / inverseFactor ,
            width: (between.size.width + finish.width) / inverseFactor ,
            height: (between.size.height + finish.height) / inverseFactor)
        
    }
    
    func interpolate(value: CGFloat, factor : CGFloat){
        
    }
    
    
    func flatten(stack : TensoStack, onComplete completed : @escaping (_ final : UIImage) -> Void) -> Void {
        
        let targetWidth = stack.size.width
        let targetHeight = stack.size.height
        
        DispatchQueue.global(qos: .userInitiated).async {
            
        let finalPhotoSize = CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight * CGFloat(integerLiteral: stack.targetCount))
            
        let renderer = UIGraphicsImageRenderer(size: finalPhotoSize.size)

        let compositeImage = renderer.image { context in

            for (index,possibleImage) in stack.stack.enumerated() {

                if let image = possibleImage {
                    
                    var scaledImageRect = CGRect.zero
                    
                    let aspectWidth:CGFloat = targetWidth / image.size.width
                    let aspectHeight:CGFloat = targetHeight / image.size.height
                    let aspectRatio:CGFloat = min(aspectWidth, aspectHeight)
                    
                    scaledImageRect.size.width = image.size.width * aspectRatio
                    scaledImageRect.size.height = image.size.height * aspectRatio
                    scaledImageRect.origin.x = 0
                    scaledImageRect.origin.y = CGFloat(index) * targetHeight
                    
                    //let photoPosition = CGRect(x: 0 , y: CGFloat(index) * targetHeight, width: targetWidth, height: targetHeight)

                    image.draw(in: scaledImageRect)
                    
                }

            }

        }

        completed(compositeImage)

        }
        
    }
    
}
