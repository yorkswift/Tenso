
import Foundation
import UIKit

class DetectionViewController: UIViewController {
    
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!

    var loadingImage : UIImage?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let image = loadingImage {
            loadingImageView.image = image
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        progressBar.setProgress(0.4, animated: true)
    }
    
    func finished(onComplete completed: @escaping () -> Void ){
        
        
        print("finished called")
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.view.alpha = 0
                
            }, completion: {
                success in
                completed()
            })
        })
        self.progressBar.setProgress(1.0, animated: true)
        CATransaction.commit()
        
        
    }
    
}
