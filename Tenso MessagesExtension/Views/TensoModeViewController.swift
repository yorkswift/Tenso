
import Foundation
import UIKit

class TensoModeViewController : UITabBarController {
    
    var selectedPhotoIndex: Int?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("hello \(selectedPhotoIndex)")
    }
    
}
