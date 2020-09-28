
import Foundation
import Photos
import UIKit

protocol TensoZoomCompletionDelegate: class {
    
     func append(zoom : UIImage, onCompletion complete: @escaping EmptyVoidClosure)
    
}
