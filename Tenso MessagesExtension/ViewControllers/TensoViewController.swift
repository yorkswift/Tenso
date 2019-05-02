
import Foundation
import UIKit

class TensoViewController: UIViewController {

    @IBOutlet weak var TensoStack: UIStackView!
    
    var stack : TensoStack?
    
     override func viewDidLoad() {
        
        if let stack = stack {
        var v = 0
        
        for subView in TensoStack.subviews {
        
            if let imageView = subView as? UIImageView {
                
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
