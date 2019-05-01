import Foundation
import UIKit

class StoryboardRepository {
    
    static let shared = StoryboardRepository()
    
    fileprivate var main: UIStoryboard
    
    enum StoryboardIdentifiers : String {
        case MainInterface
        case DetectionViewController
        case DefaultTensoViewController
    }
    
    init(){
        
        main = UIStoryboard(name: StoryboardIdentifiers.MainInterface.rawValue, bundle: nil)
        
    }
    
    func new(withIdentifier identifier: StoryboardIdentifiers) -> UIViewController {
        
         return main.instantiateViewController(withIdentifier: identifier.rawValue)
    
    }
   
    
}
