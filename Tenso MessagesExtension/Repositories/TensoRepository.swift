
import Foundation
import Photos

import Accelerate
import simd

import AVFoundation

import PeakOperation

class TensoRepository  {
    
    static let shared = TensoRepository()
    let targetSize = CGSize(width: 300, height: 145)
    
    var tensos = [TensoStack]()
    
    func stack(for index: Int) -> TensoStack? {
        
        if tensos.indices.contains(index){
            return tensos[index]
        }
        return nil
        
    }
    
    func add(zoom : UIImage, for index: Int){
        
        if tensos.indices.contains(index){
            tensos[index].stack.append(zoom)
        }
        
    }
    
    func renderTenso(for stack: TensoStack,
                     onBegun began: @escaping (_ img : UIImage) -> Void,
                     onDetection detected: @escaping (_ count : Int) -> Void,
                     onProgress progress: @escaping(_ increment : Int) -> Void,
                     onComplete completed : @escaping (_ stack : TensoStack) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            var newStack = stack
            
            PhotoRepository.shared.fetchPhoto(for: newStack.asset, at: newStack.size, completion: { possibleSourceImage in
            
            if let sourceImage = possibleSourceImage {
                
                DispatchQueue.main.sync {
                    began(sourceImage)
                }
                
                let sourceImageRect = CGRect(origin: CGPoint.zero, size: sourceImage.size)
                let startingApectRect = AVMakeRect(aspectRatio: self.targetSize, insideRect: sourceImageRect)
            
                var finalAspectRect : CGRect?
                
                if let faces = FeatureRepository.shared.detectFaces(in: sourceImage) {
                
                    DispatchQueue.main.sync {
                        detected(faces.count)
                        progress(1)
                    }
                    
                    if let randomFace = faces.randomElement() {
        
                        finalAspectRect = AVMakeRect(aspectRatio: self.targetSize, insideRect: randomFace)
                        
                        newStack.size = sourceImage.size
                        
                    } else {
                        finalAspectRect = self.randomCrop(within: startingApectRect)
                    }
                    
                } else {
                
                    finalAspectRect =  self.randomCrop(within: startingApectRect)
                }
                
                guard let finalRect = finalAspectRect else {
                    
                    //TODO handle error
                     print("no finished rect")
                    
                    return
                    
                }
                
                newStack.zooms = self.interpolate(start: startingApectRect, finish: finalRect)

                    
                    self.tensos.append(newStack)
                    let index = self.tensos.endIndex - 1
                    
                    let firstZoom = CreateTensoZoomOperation(at: 9, for: index)
                    let secondZoom = CreateTensoZoomOperation(at: 4, for: index)
                    let thirdZoom = CreateTensoZoomOperation(at: 1, for: index)
                    
                    let render = PerformCompletionHandlerOperation(on: {
                        
                       
                        DispatchQueue.main.sync {
                            
                            if var tenso = self.stack(for: index){
                                
                                tenso.stackComplete = true
                                
                                self.tensos.remove(at: index)
                                completed(tenso)
                            } else {
                                print("no tenso")
                            }
                        }
                        
                    })
                    
                    let queue = OperationQueue()
                    
                    firstZoom
                        .then(do: secondZoom)
                        .then(do: thirdZoom)
                        .then(do: render)
                        .enqueue(on: queue)
     
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
    
    func drawRectangleOnImage(image: UIImage, rectangle: CGRect) -> UIImage {
        
        let imageSize = image.size
        let scale: CGFloat = 0
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        
        image.draw(at: CGPoint.zero)
        
        guard let context = UIGraphicsGetCurrentContext() else { return image }
        
        context.setLineWidth(1.0)
        context.addRect(rectangle)
        context.setStrokeColor(UIColor.cyan.cgColor)
        context.strokePath()
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
             UIGraphicsEndImageContext()
            return image
            
        }
        UIGraphicsEndImageContext()
        return newImage
        
    }
    
    func randomCrop(within rect: CGRect) -> CGRect{
        
        let smallestCropWidth = rect.width / 5
        let smallestCropHeight = rect.height / 5
        
        let minX = rect.minX
        let maxX = rect.maxX - smallestCropWidth
        let minY = rect.minY
        let maxY = rect.maxY - smallestCropHeight
        
        let randomPoint = CGPoint(
            x: CGFloat.random(in: minX...maxX),
            y: CGFloat.random(in: minY...maxY)
        )
        
        return CGRect(x: randomPoint.x,
                      y: randomPoint.y,
                      width: smallestCropWidth,
                      height: smallestCropHeight)
    }
        
}
