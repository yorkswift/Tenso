
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
                    
                 //   let secondZoomConstant : CGFloat = 2
                    
                   // let secondZoom = CGRect(
//                        x: firstFace.minX / secondZoomConstant,
//                        y: firstFace.minY / secondZoomConstant ,
//                        width: (x1.size.width + firstFace.width) / secondZoomConstant ,
//                        height: (x1.size.height + firstFace.height) / secondZoomConstant)
                    
                    
                    let zooms: [CGRect] = stride(from: 0.0, to: 1.0, by: 1 / 10).map { x in
                    
                        let originX = simd_mix(0.0, Double(firstFace.minX), x )
                        let originY = simd_mix(0.0, Double(firstFace.minY), x )
                        
                        let origin = CGPoint(x: originX, y: originY)
                        
                        let height = simd_mix(Double(x1.size.height), Double(firstFace.height), x)
                        let width = simd_mix(Double(x1.size.width), Double(firstFace.width), x)
                        
                        let size = CGSize(width: width, height: height)
                        
                        return CGRect(origin: origin, size: size)
                    
                    }
                    
                    print(zooms)
                    
                    
                    if let midwayZoom = Array(zooms.suffix(6)).first {
                        
                        if let cutImageRef: CGImage = x1.cgImage?.cropping(to:midwayZoom) {
                            
                            let x2: UIImage = UIImage(cgImage: cutImageRef)
                            
                            newStack.stack.append(x2)
                            
                        }
                        
                    }
                    
                    
                    if let penultimateZoom = Array(zooms.suffix(3)).first {
                    
                        if let cutImageRef: CGImage = x1.cgImage?.cropping(to:penultimateZoom) {
                            
                            let x3: UIImage = UIImage(cgImage: cutImageRef)
                            
                            newStack.stack.append(x3)
                            
                        }
                        
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
