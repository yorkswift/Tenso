
import Foundation
import Photos

protocol TensoZoomCompletionDelegate: class {
    
     func append(zoom : UIImage, onCompletion complete: @escaping EmptyVoidClosure)
    
}
