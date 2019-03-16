import Foundation
import UIKit


public enum FacesFetchMode : String {
    case All
    case Random
}
public class FeatureRepository {
    
    public static let shared = FeatureRepository()
    
    let context = CIContext()
    let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
    
    init() {
        
        
    }
    
    public func detectFaces(in photo : UIImage, fetching faceMode: FacesFetchMode  ) -> [CGRect]? {
        
        if let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options){
            
            if let coreImagePhoto = convertToCoreImage(from : photo){
                
                let detectedFaces = faceDetector.features(in: coreImagePhoto)
                
                var faces = [CGRect]()
                
                switch(faceMode){
                case .All:
                        
                    faces = detectedFaces.compactMap({ (face) -> CGRect? in
                    
                          zoomOutFace(with : face.bounds)
                        
                    })
                    
                break
                case .Random:
                        
                        if let randomFace = detectedFaces.randomElement() as? CIFaceFeature {
                            
                            faces = [zoomOutFace(with : randomFace.bounds)]
                        }
                        
                    break
                }
                
                return faces
            }
            
            
            
        }
        return nil
    }
    
    private func zoomOutFace(with bounds:CGRect) -> (CGRect){
        
        return bounds
        //return bounds.insetBy(dx: -66, dy: -66)
        
    }
    
    private func convertToCoreImage(from image: UIImage) -> (CIImage?) {
        
        if let coreGraphicsImage = image.cgImage {
            
            return CIImage(cgImage: coreGraphicsImage, options: [CIImageOption.applyOrientationProperty:true])
            
        }
        
        return nil
        
    }
    
    func parseEyes(){
        //        if face.hasLeftEyePosition && face.hasRightEyePosition {
        //            print("Found left eye at \(face.leftEyePosition)")
        //
        //            face.mouthPosition
        //
        //
        //            let eyeWidth : CGFloat = face.bounds.width
        //
        //            let eyeHeight : CGFloat = face.bounds.height
        //
        //            let eyeRect = CGRect(x: face.mouthPosition.x,
        //                                 y: face.mouthPosition.y,
        //                                 width: eyeWidth,
        //                                 height: eyeHeight)
        //
        //
        //
        //            if let eyeImageRef: CGImage = inputImage.cgImage?.cropping(to:eyeRect) {
        //
        //                let eyesImage: UIImage = UIImage(cgImage: eyeImageRef)
        //                print(eyesImage)
        //
        //            }
        //        }
    }
    
}

extension CITextFeature {
    fileprivate func rectInBounds(_ inBounds: CGRect, scale: CGFloat) -> CGRect {
        return CGRect(
            x: topLeft.x * scale,
            y: inBounds.height - topLeft.y * scale,
            width: bounds.size.width * scale,
            height: bounds.size.height * scale)
    }
    
    fileprivate func drawRectOnView(_ view: UIView, color: UIColor, borderWidth: CGFloat, scale: CGFloat) {
        let featureRect = rectInBounds(view.bounds, scale: scale)
        let featureView = UIView(frame: featureRect)
        featureView.backgroundColor = UIColor.clear
        featureView.layer.borderColor = color.cgColor
        featureView.layer.borderWidth = borderWidth
        view.addSubview(featureView)
    }
}
