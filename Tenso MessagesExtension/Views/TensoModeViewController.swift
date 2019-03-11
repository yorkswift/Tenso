
import Foundation
import UIKit

class TensoModeViewController : UITabBarController {
    
    enum TensoMode : String {
      case Auto
      case Faces
    }
    
    var selectedPhotoIndex: Int?
    var tensoRepository : TensoRepository?
    
    var arrayOfImageNameForSelectedState = ["AutoSelected","FacesSelected"]
    var arrayOfImageNameForUnselectedState = ["AutoNormal","FacesNormal"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initTabBarItems()
        
        print("hello \(selectedPhotoIndex!)")
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        guard let title = item.title else { return }
        
        if let mode = TensoMode(rawValue: title) {
            switch(mode){
            case .Auto:
                
             
                
                break
            case .Faces:
                break
            }
        }
        
    }

    
    func initTabBarItems(){
        
        if let count = self.tabBar.items?.count {
            
            for i in 0...(count-1) {
                
                let imageNameForSelectedState  = arrayOfImageNameForSelectedState[i]
                let imageNameForUnselectedState = arrayOfImageNameForUnselectedState[i]
                
                print(imageNameForSelectedState)
                
                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.alwaysOriginal)
            }
        }
        
    }
    
}
