
import Foundation
import UIKit

enum TensoMode : String {
    case Auto
    case Faces
}

class TensoModeViewController : UITabBarController {
    
    var selectedPhotoIndex: Int?
    var tensoRepository : TensoRepository?
    
    var arrayOfImageNameForSelectedState = ["AutoSelected","FacesSelected"]
    var arrayOfImageNameForUnselectedState = ["AutoNormal","FacesNormal"]
    
    var completedStack: TensoStack?
    weak var messagesDelegate: MessagesAppConversationDeletgate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initTabBarItems()
        
    }
    
    func renderTenso(for mode: TensoMode, on complete : @escaping (_ stack : TensoStack) -> Void) {
        
        guard let photoIndex = selectedPhotoIndex else {
            
             print("no index")
            return
        }
        
        guard let asset = PhotoRepository.shared.asset(at: photoIndex) else {
               print("no asset")
            return
        }
        
        switch(mode){
        case .Auto:
            
            let tenso = TensoStack(for: asset)
            
            TensoRepository.shared.renderTenso(for: tenso, on: { newStack in
                
                complete(newStack)
                
                if(newStack.stackComplete){
                
                    let sendButton : UIBarButtonItem = UIBarButtonItem(title: "Send", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.sendTensoAction))
                    
                    self.navigationItem.rightBarButtonItem = sendButton
                    
                    self.completedStack = newStack
                    
                }
                
            })
            
            
            break
        case .Faces:
            break
        }
        
    }

    
    func initTabBarItems(){
        
        if let count = self.tabBar.items?.count {
            
            for i in 0...(count-1) {
                
                let imageNameForSelectedState  = arrayOfImageNameForSelectedState[i]
                let imageNameForUnselectedState = arrayOfImageNameForUnselectedState[i]
                
                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.alwaysOriginal)
            }
        }
        
    }
    
    @objc func sendTensoAction(){
        
       
        if let stack = completedStack {
           
            TensoRepository.shared.flatten(stack: stack, onComplete: { image in
                
                  print("completed image render")
                
                self.messagesDelegate?.send(photo: image, onCompletion: {
                    print("sent")
                })

            })
            
        }

    }
    
}

