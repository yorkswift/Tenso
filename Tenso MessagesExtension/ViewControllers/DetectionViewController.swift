
import Foundation
import UIKit

class DetectionViewController: UIViewController {
    
    @IBOutlet weak var CurrentImage: UIImageView!
    @IBOutlet weak var Progress: UIProgressView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Progress.setProgress(0.5, animated: true)
    }
    
}
