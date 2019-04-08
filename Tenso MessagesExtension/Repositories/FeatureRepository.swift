
import Foundation
import UIKit

class FeatureRepository {
    
    static let shared = FeatureRepository()

    let context = CIContext()
    let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
    
    func detectFaces(in photo : UIImage) -> [CGRect]? {
        
        let photoHeight = photo.size.height
        
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -photoHeight)
        
        guard let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options) else { return nil }
        
        guard let coreImagePhoto = convertToCoreImage(from : photo) else { return nil }
            
        let faces = faceDetector.features(in: coreImagePhoto)
            
        guard let randomFace = faces.randomElement() as? CIFaceFeature else { return nil }
                
        return [randomFace.bounds.applying(transform)]

    }
    
    private func convertToCoreImage(from image: UIImage) -> (CIImage?) {
        
        guard let coreGraphicsImage = image.cgImage else { return nil }
            
        return CIImage(cgImage: coreGraphicsImage, options: [CIImageOption.applyOrientationProperty:true])
        
    }
    
}
