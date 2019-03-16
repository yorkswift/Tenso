
import Foundation
import UIKit

class FeatureRepository {
    
    static let shared = FeatureRepository()

    let context = CIContext()
    let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
    
    init() {
        
        
    }
    
    func detectFaces(in photo : UIImage) -> [CGRect]? {
        
        let photoHeight = photo.size.height
        
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -photoHeight)
        
        if let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options){
        
            if let coreImagePhoto = convertToCoreImage(from : photo){
            
                let faces = faceDetector.features(in: coreImagePhoto)
            
                if let randomFace = faces.randomElement() as? CIFaceFeature {
                    
                    return [randomFace.bounds.applying(transform)]

                }
                
            }
        
        }
        return nil
    }
    
    private func zoomOutFace(with bounds:CGRect) -> (CGRect){
        
       return bounds.insetBy(dx: -66, dy: -66)
        
    }
    
    private func convertToCoreImage(from image: UIImage) -> (CIImage?) {
        
        if let coreGraphicsImage = image.cgImage {
            
            return CIImage(cgImage: coreGraphicsImage, options: [CIImageOption.applyOrientationProperty:true])
            
        }
    
        return nil
        
    }
    
}
