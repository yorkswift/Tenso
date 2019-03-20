
import Foundation
import UIKit

protocol MessagesAppConversationDeletgate: class {
    
    func recentPhotosDidSelectPhoto(onCompletion complete: @escaping EmptyVoidClosure)
    func send(photo : UIImage, onCompletion complete: @escaping EmptyVoidClosure)
    
}
