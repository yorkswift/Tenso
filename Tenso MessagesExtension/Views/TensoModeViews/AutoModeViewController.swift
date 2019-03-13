
import UIKit

class AutoModeViewController: UIViewController {
    
    @IBOutlet weak var TensoStackView: UIStackView!
    
    var tensoRepository : TensoRepository?
    
    override func viewDidLoad() {
        
        if let modeController = self.tabBarController as? TensoModeViewController {
            
            print("renderTenso")
            
            modeController.renderTenso(for: .Auto) { stack in
                
                var v = 0
                
                for subView in self.TensoStackView.subviews {
                
                    if let imageView = subView as? UIImageView {
                        
                       // if(imageView.image != nil){ continue }
                        
                        if(stack.stack.indices.contains(v)){
                        
                            if let image = stack.stack[v] {
                                
                                imageView.image = image
                                 v += 1
                                
                            }
                            
                            
                        }
                     
                    }
                
                }
            }
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
       
    }
    

}
