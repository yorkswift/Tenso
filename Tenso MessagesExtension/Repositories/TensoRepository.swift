
import Foundation
import Photos

import Accelerate
import simd

class TensoRepository  {
    
    static let shared = TensoRepository()
    
    func renderTenso(for stack: TensoStack, on complete : @escaping (_ stack : TensoStack) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            var newStack = stack
            
            PhotoRepository.shared.fetchPhoto(for: newStack.asset, at: newStack.size, completion: { image in
            
            if let x1 = image {
                
                newStack.stack.append(x1)
                
                DispatchQueue.main.sync {
                    complete(newStack)
                }
                
                let x1Rect = CGRect(origin: CGPoint.zero, size: x1.size)
                

                if let firstFace = FeatureRepository.shared.detectFaces(in: x1)?.first {
                    
                    
                    let zooms = self.interpolate(start: x1Rect, finish: firstFace)
                    
                    
                    if let midwayZoom = Array(zooms.suffix(4)).first {
                        
                        self.append(x1, cropped: midwayZoom, to: &newStack)
                        
                    }
                    
                    if let penultimateZoom = Array(zooms.suffix(2)).first {
                        
                        self.append(x1, cropped: penultimateZoom, to: &newStack)
                        
                    }
                    
                    
                    if let penultimateZoom = Array(zooms.suffix(1)).first {
                    
                        self.append(x1, cropped: penultimateZoom, to: &newStack)
                
                    }

                } else {
                    
                    // no faces found
                    
                    let focusPoint : CGFloat = 20
                
                    
                    let randomPoint = CGPoint(x: CGFloat.random(in: x1Rect.minX...x1Rect.maxX), y: CGFloat.random(in: x1Rect.minY...x1Rect.maxY))
                    
                    
                    let randomCrop = CGRect(x: randomPoint.x - (focusPoint / 2),
                                    y: randomPoint.y - (focusPoint / 2),
                                    width: focusPoint,
                                    height: focusPoint)
                    
                    let zooms = self.interpolate(start: x1Rect, finish: randomCrop)
                    
                    
                    if let midwayZoom = Array(zooms.suffix(6)).first {
                        
                        self.append(x1, cropped: midwayZoom, to: &newStack)
                        
                    }
                    
                    if let penultimateZoom = Array(zooms.suffix(4)).first {
                        
                        self.append(x1, cropped: penultimateZoom, to: &newStack)
                        
                    }
                    
                    
                    if let penultimateZoom = Array(zooms.suffix(2)).first {
                        
                        self.append(x1, cropped: penultimateZoom, to: &newStack)
                        
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
    
    func interpolate(start: CGRect, finish : CGRect) ->  [CGRect]{
        
        return stride(from: 0.0, to: 1.0, by: 1 / 10).map { x in
            
            let originX = simd_mix(Double(start.minX), Double(finish.minX), x )
            let originY = simd_mix(Double(start.minY), Double(finish.minY), x )
            
            let origin = CGPoint(x: originX, y: originY)
            
            let height = simd_mix(Double(start.height), Double(finish.height), x)
            let width = simd_mix(Double(start.width), Double(finish.width), x)
            
            let size = CGSize(width: width, height: height)
            
            return CGRect(origin: origin, size: size)
            
        }
    
    }
    
    func append(_ source: UIImage, cropped crop: CGRect, to currentStack : inout TensoStack ){

        if let cutImageRef: CGImage = source.cgImage?.cropping(to:crop) {
            
            let x2: UIImage = UIImage(cgImage: cutImageRef)
            
            currentStack.stack.append(x2)
            
        }
        
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
