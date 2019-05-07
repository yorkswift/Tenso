
//https://www.swiftbysundell.com/posts/using-child-view-controllers-as-plugins-in-swift

import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        
        addChild(child)
        
        //UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(child.view)

        
            child.didMove(toParent: self)
        //}, completion: nil)
        
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        self.willMove(toParent: nil)
       // UIView.transition(with: view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
           
            self.view.removeFromSuperview()
            self.removeFromParent()
            
       // }, completion: nil)
        
    }
    
    
    
}
