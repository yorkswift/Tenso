import UIKit

let context = CIContext()

if let inputImage = UIImage(named: "IMG_0548.JPG") {
    
    let ciImage = CIImage(cgImage: inputImage.cgImage!, options: [.applyOrientationProperty:true])
    
    let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
    let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!
    
    let faces = faceDetector.features(in: ciImage)
    
    if let face = faces.first as? CIFaceFeature {
        
        print("Found face at \(face.bounds)")

        
        if let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:face.bounds) {
        
                let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
            
             print(croppedImage)
        
         }
        
        if face.hasLeftEyePosition && face.hasRightEyePosition {
            print("Found left eye at \(face.leftEyePosition)")
            
            face.mouthPosition
            
            
            let eyeWidth : CGFloat = face.bounds.width
            
            let eyeHeight : CGFloat = face.bounds.height
            
                let eyeRect = CGRect(x: face.mouthPosition.x,
                                     y: face.mouthPosition.y,
                                     width: eyeWidth,
                                     height: eyeHeight)
            
            
            
            if let eyeImageRef: CGImage = inputImage.cgImage?.cropping(to:eyeRect) {
                
                let eyesImage: UIImage = UIImage(cgImage: eyeImageRef)
                 print(eyesImage)
                
            }
        }

    }
}


