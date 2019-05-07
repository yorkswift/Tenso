
import Foundation
import UIKit
import Photos

class PhotoRepository {
    
    static let shared = PhotoRepository()
    
    fileprivate var imageManager: PHImageManager
    fileprivate var requestOptions: PHImageRequestOptions
    fileprivate var fetchOptions: PHFetchOptions
    fileprivate var fetchResult: PHFetchResult<PHAsset>?
    
    init () {
        imageManager = PHImageManager.default()
        requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.isNetworkAccessAllowed = true
        fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
    }
    
    var count: Int {
        return fetchResult?.count ?? 0
    }
    
    func asset(at index : Int) -> PHAsset? {
        return fetchResult?.object(at: index)
    }
    
    func fetchAll() -> PHFetchResult<PHAsset> {
        
        fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        return fetchResult!
       
    }
    
    func fetchPhoto(for asset: PHAsset, at size: CGSize, completion block: @escaping (UIImage?)->()) {
        
        let retinaScale = UIScreen.main.scale * 0.5
        let targetSize = CGSize(width: size.width * retinaScale, height: size.height * retinaScale)
        
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: requestOptions) { (image, _) in
            block(image)
        }
       
    }
    
    func fetchCroppedPhoto(for asset: PHAsset, at size: CGSize, cropped : CGRect, completion block: @escaping (UIImage?)->()) {
        
        let retinaScale = UIScreen.main.scale * 4
        let targetSize = CGSize(width: size.width * retinaScale, height: size.height * retinaScale)
        
        //print(retinaScale, size, targetSize, cropped)
        
        let cropOptions = PHImageRequestOptions()
        cropOptions.isSynchronous = true
        cropOptions.resizeMode = .exact
        cropOptions.normalizedCropRect = cropped
        cropOptions.isNetworkAccessAllowed = true
            
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: cropOptions) { (image, _) in
                
                block(image)
        }
        
    }
    
    public func checkAuthorisation(onComplete handleCompletion: @escaping (PHAuthorizationStatus)->()) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
        
            handleCompletion(status)
            
        case .restricted, .denied:
            
            handleCompletion(status)
            
        case .notDetermined:
        
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                       handleCompletion(status)
                    }
                case .restricted, .denied:
                    print("Photo Auth restricted or denied")
                case .notDetermined:
                    print("notDetermined")
                break
                }
            }
        }
    }
    
    func saveToLibrary(photo : UIImage){
    

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: photo)
                }) { (success:Bool, error:Error?) in
                    if success {
                    print("Image Saved Successfully")
                } else {
                    print("Error in saving:"+error.debugDescription)
                }
        }
        
    }
    
    
}
