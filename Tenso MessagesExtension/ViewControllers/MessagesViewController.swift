
import UIKit
import Messages

typealias EmptyVoidClosure = () -> Void

class MessagesViewController: MSMessagesAppViewController {
    
    weak private var recentPhotos: RecentPhotosViewController?
    weak private var nav : UINavigationController?
    
    public var waitingClosure : EmptyVoidClosure?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
            
         PhotoRepository.shared.checkAuthorisation(onComplete: {
            
            status in
            
            switch(status){
                case .authorized:
                    
                    guard let nav = self.children.first as? UINavigationController else {
                        fatalError("Check storyboard for missing UINavigationController")
                    }
                    
                    self.nav = nav
                    
                    guard let recentPhotos = nav.children.first as? RecentPhotosViewController else {
                        fatalError("Check storyboard for missing recentViewController")
                    }
                    
                    self.recentPhotos = recentPhotos
                    self.recentPhotos?.messagesDelegate = self
                    
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
        
        if(presentationStyle == .expanded){
       
        }
        
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        
        switch(presentationStyle){
            case .compact:
            break
            case .expanded:
            
                if let waitingClosure = self.waitingClosure {
                    waitingClosure()
                    
                    self.waitingClosure = nil
                }
            
            break
            case .transcript:
            break
        }
    }

}
