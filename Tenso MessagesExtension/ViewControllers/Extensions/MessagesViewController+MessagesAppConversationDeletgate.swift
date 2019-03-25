
import UIKit
import Messages

extension MessagesViewController : MessagesAppConversationDeletgate {
    
    func recentPhotosDidSelectPhoto(onCompletion complete: @escaping EmptyVoidClosure) {
        
        if(self.presentationStyle == .compact){
            
            requestPresentationStyle(.expanded)
            self.waitingClosure = complete
            
        } else {
            
            complete()
            
        }
        
        
    }
    
    func send(photo : UIImage, onCompletion complete: @escaping EmptyVoidClosure){
        
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        
        guard let imageData = photo.jpegData(compressionQuality: 0.3),
            let docUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
            else {
                dismiss()
                return
        }
        var attachmentPath : URL? = nil
        attachmentPath = URL(fileURLWithPath: "tenso.jpg", relativeTo: docUrl)
        if (try? imageData.write(to: attachmentPath!)) != nil {
            
            conversation.insertAttachment(attachmentPath!, withAlternateFilename: "tenso.jpg") { [weak self] (error) in
                if let error = error {
                    
                    print(error.localizedDescription)
                }
                
                guard let strongSelf = self else {return}
                strongSelf.dismiss()
                complete()
            }
        }
        
        
    }
    
    
}
