
import UIKit

class AutoModeViewController: UIViewController {
    
    private var state: State?
    
    enum State {
        case loading
        case failed(Error)
        case render(UIViewController)
    }
    
    @IBOutlet weak var Container: UIView!
    private var activeViewController: UIViewController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if state == nil {
            transition(to: .loading)
        }
        
        if let modeController = self.tabBarController as? TensoModeViewController {
            
            print(modeController)
            
        }
        
    }
    
    func transition(to newState: State) {
        
        activeViewController?.remove()
        let vc = viewController(for: newState)
        add(vc)
        activeViewController = vc
        state = newState
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }

}
