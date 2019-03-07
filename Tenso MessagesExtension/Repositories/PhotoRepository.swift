
import Foundation
import Photos

class PhotoRepository {
    
    static let shared = PhotoRepository()
    
    fileprivate var imageManager: PHImageManager
    fileprivate var requestOptions: PHImageRequestOptions
    fileprivate var fetchOptions: PHFetchOptions
    fileprivate var fetchResult: PHFetchResult<PHAsset>
    
    init () {
        imageManager = PHImageManager.default()
        requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
    }
    
    var count: Int {
        return fetchResult.count
    }
    
    func fetchAll() -> [UIImage] {
        
        var resultArray = [UIImage]()
        for index in 0..<fetchResult.count {
            imageManager.requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: UIScreen.main.bounds.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image, _) in
                
                if let image = image {
                    resultArray.append(image)
                }
            }
        }
        return resultArray
    }
    
    func setPhoto(at index: Int, completion block: @escaping (UIImage?)->()) {
        
        if index < fetchResult.count  {
            
            imageManager.requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: UIScreen.main.bounds.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image, _) in
                block(image)
            }
        } else {
            block(nil)
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
    
    
}
