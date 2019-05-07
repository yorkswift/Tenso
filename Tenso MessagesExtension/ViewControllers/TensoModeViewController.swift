
import Foundation
import UIKit

enum TensoMode : String {
    case Auto
    case Faces
}

class TensoModeViewController : UITabBarController {
    
    var selectedPhotoIndex: Int?
    var tensoRepository : TensoRepository?
    
    var facesTabBarItem : UITabBarItem?
    
    var arrayOfImageNameForSelectedState = ["AutoSelected","FacesSelected"]
    var arrayOfImageNameForUnselectedState = ["AutoNormal","FacesNormal"]
    
    var completedStack: TensoStack?
    weak var messagesDelegate: MessagesAppConversationDeletgate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initTabBarItems()
        
    }
    
    func renderTenso(for mode: TensoMode, onBegun began: @escaping (_ img: UIImage) -> Void, onComplete completed : @escaping (_ stack : TensoStack) -> Void) {
        
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
            
            let tenso = TensoStack(for: asset, targetSize: CGSize(width: 300, height: 145))
            
            TensoRepository.shared.renderTenso(for: tenso,
                onBegun: { img in
                    began(img)
                },
                onDetection: { faceCount in
                    
                    if let facesTabBarItem = self.facesTabBarItem {
                        
                        facesTabBarItem.badgeValue = String(faceCount)
                        
                    }
                   
                    
                },
                onProgress: { increment in
                    
                    //TODO update progress bar
                    
                },
                onComplete:
                { newStack in
                
                completed(newStack)
                
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
                
                if (facesTabBarItem == nil && imageNameForUnselectedState == "FacesNormal"){
                    facesTabBarItem = self.tabBar.items?[i]
                }
            }
        }
        
    }
    
    @objc func sendTensoAction(){
        
        if completedStack != nil {
           
            if let modeView = self.selectedViewController as? AutoModeViewController {
                
                if let tensoStackView = modeView.tensoStackView {

                    if let image = renderImage(from:tensoStackView) {

                        self.messagesDelegate?.send(photo: image, onCompletion: {
                            print("sent")
                        })

                    }

                }
            
            }
            
        }

    }
    
    func renderImage(from view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
    
}

