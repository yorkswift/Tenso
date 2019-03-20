import UIKit

if let inputImage = UIImage(named: "IMG_4558.JPG") {
    
    var faceImages = [UIImage]()
  
    if let faces = FeatureRepository.shared.detectFaces(in: inputImage, fetching: .All) {
        
        for face in faces {
            
            let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -inputImage.size.height)
            
            let newface = face.applying(transform)
            
            let halfway = CGRect(
                x: newface.minX / 2 ,
                y: newface.minY / 2 ,
                width: (inputImage.size.width + newface.width) / 2 ,
                height: (inputImage.size.height + newface.height) / 2)
            
            if let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:halfway) {
                
                faceImages.append(UIImage(cgImage: cutImageRef))
            
             }
            
        }
        
        let finalPhotoSize = CGRect(x: 0, y: 0, width: 748, height: 585 * 4)
        let renderer = UIGraphicsImageRenderer(size: finalPhotoSize.size)
        
        let result = renderer.image { context in
            
            for (index,image) in faceImages.enumerated() {
                
                let photoPosition = CGRect(x: 0 , y: index * 585, width: 748, height: 585)
                image.draw(in: photoPosition, blendMode: .normal, alpha: 1)
            
            }
  
        }
        
        result

        
    }

    
}
