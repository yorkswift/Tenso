
import UIKit

class AutoModeViewController: UIViewController {
    
    private var state: State?
    
    enum State {
        case loading
       // case failed(Error)
        case render(UIViewController)
    }
    
    private var activeViewController: UIViewController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if state == nil {
            transition(to: .loading)
        }
        
        if let modeController = self.tabBarController as? TensoModeViewController {

            modeController.renderTenso(for: .Auto) { stack in
                
                let vc = StoryboardRepository.shared.new(withIdentifier:.DefaultTensoViewController) as! TensoViewController
                
                vc.stack = stack
                self.transition(to: .render(vc))
                
            }
    
        }
    
    }
    
    func transition(to newState: State) {
        
        activeViewController?.remove()
       
        let vc = viewController(for: newState)
        add(vc)
        
        activeViewController = vc
        state = newState
        
    }
    
    func viewController(for state: State) -> UIViewController {
        
        switch state {
        case .loading:
            
            return StoryboardRepository.shared.new(withIdentifier:.DetectionViewController) as! DetectionViewController
            
      //  case .failed(let error):
    //    return ErrorViewController(error: error)
            
        case .render(let viewController):
            return viewController
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }

}

