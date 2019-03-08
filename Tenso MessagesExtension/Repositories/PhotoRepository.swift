
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
        fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
       // fetchResult =
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
        
//        var resultArray = [UIImage]()
//        for index in 0..<fetchResult.count {
//            imageManager.requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: UIScreen.main.bounds.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image, _) in
//
//                if let image = image {
//                    resultArray.append(image)
//                }
//            }
//        }
//        return resultArray
       
    }
    
    func fetchPhoto(for asset: PHAsset, at size: CGSize, completion block: @escaping (UIImage?)->()) {
            
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: requestOptions) { (image, _) in
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
    
    
}
