
import UIKit

class AutoModeViewController: UIViewController {
    
    private var state: State?
    
    enum State {
        case loading(DetectionViewController)
       // case failed(Error)
        case render(UIViewController)
    }
    
    private var activeViewController: UIViewController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let loadingViewController = StoryboardRepository.shared.new(withIdentifier:.DetectionViewController) as! DetectionViewController

        if let modeController = self.tabBarController as? TensoModeViewController {
            
            modeController.renderTenso(for: .Auto,
            onBegun: { img in
                
                loadingViewController.loadingImage = img
 
                self.transition(to: .loading(loadingViewController))
            },
            onComplete: { stack in
                
                loadingViewController.finished(onComplete: {
                    
                    let vc = StoryboardRepository.shared.new(withIdentifier:.DefaultTensoViewController) as! TensoViewController
                    vc.stack = stack
                    self.transition(to: .render(vc))

                })
                
                
            })
    
        }
    
    }
    
    func transition(to newState: State) {
        
        let vc = viewController(for: newState)
        if let active = activeViewController {
                  
            active.remove()
            self.add(vc)
            
        } else {
            
             self.add(vc)
            
        }
        
        activeViewController = vc
        state = newState
        
    }
    
    func viewController(for state: State) -> UIViewController {
        
        switch state {
        case .loading(let viewController):
            return viewController
            
      //  case .failed(let error):
    //    return ErrorViewController(error: error)
            
        case .render(let viewController):
            return viewController
        }
        
    }
    
    func tensoStackView() -> UIStackView? {
        
        if let vc = activeViewController as? TensoViewController {
            return vc.TensoStack
        }
        
        return nil
    }


}

