
import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    private var recentPhotos: RecentPhotosViewController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
            
         PhotoRepository.shared.checkAuthorisation(onComplete: {
            
            status in
            
            switch(status){
                case .authorized:
                    
                    guard let recentPhotos = self.children.first as? RecentPhotosViewController else {
                        fatalError("Check storyboard for missing recentViewController")
                    }
                    
                    self.recentPhotos = recentPhotos
                    self.recentPhotos?.delegate = self
                    
                    self.recentPhotos?.reload()
                    
                    
                break
                case .denied,.notDetermined,.restricted:
                    
                    //TODO show grant access button
                    print("no photo access")
            }
            
            
        })
        
        
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        
        if(presentationStyle == .compact){
              print("compact")
        }
        
//        switch(presentationStyle){
//        case .compact:
//
//            print("compact")
//            // revert to recent photos?
//           // recentPhotos?.hideTensoModeController()
//
//        break
//
//        case .expanded:
//
//            //
//
//        break
//            case .transcript:
//            break
//        }
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
//
//        switch(presentationStyle){
//        case .compact:
//                break
//        case .expanded:
//                 break
//        case .transcript:
//            break
//        }
    }

}

extension MessagesViewController : RecentPhotoViewControllerDelegate {
    
    func recentPhotosDidSelectPhoto(_ controller: RecentPhotosViewController) {
        requestPresentationStyle(.expanded)
    }
    
}
