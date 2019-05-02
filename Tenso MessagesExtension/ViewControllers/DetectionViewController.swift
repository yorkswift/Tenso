
import Foundation
import UIKit

class DetectionViewController: UIViewController {
    
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var Progress: UIProgressView!

    var loadingImage : UIImage?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let image = loadingImage {
            loadingImageView.image = image
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        Progress.setProgress(0.5, animated: true)
    }
    
}
