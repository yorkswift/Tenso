
import UIKit

class AutoModeViewController: UIViewController {
    
    @IBOutlet weak var tensoStackView: UIStackView!
    @IBOutlet weak var loadingStackView: UIStackView!
    
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var loadingImage : UIImage?
    
    override func viewDidAppear(_ animated: Bool) {
        
        progressBar.setProgress(0.4, animated: true)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadingImageView.isHidden = false
        loadingImageView.alpha = 1
        
        tensoStackView.isHidden = true
        tensoStackView.alpha = 0
        
        beginRenderingTenso()
        
    }
    
    func beginRenderingTenso() -> Void {
        
        if let modeController = self.tabBarController as? TensoModeViewController {
            
            modeController.renderTenso(for: .Auto,
           
              onBegun: { img in
                                        
               self.loadingImageView.image = img
                
              },
              onComplete: { stack in
                
                    print("complete")
                
                   self.hideLoadingView(onComplete: {
                    
                        self.mapImagesToViews(with: stack)
                    
                    })
                
            })
            
        }
        
    }
    

    func hideLoadingView(onComplete completed: @escaping () -> Void ){
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                
                self.loadingImageView.alpha = 0
                
            }, completion: {
                success in
                self.loadingImageView.isHidden = true
                completed()
            })
        })
        self.progressBar.setProgress(1.0, animated: true)
        CATransaction.commit()
        
    }
    
    func mapImagesToViews(with stack : TensoStack){
        
        tensoStackView.isHidden = false
        var v = 0
        for subView in self.tensoStackView.subviews {
            
            if let imageView = subView as? UIImageView {
                
                if(stack.stack.indices.contains(v)){
                    
                    if let image = stack.stack[v] {
                        
                        imageView.image = image
                        imageView.sizeToFit()
                        v += 1
                        
                    }
                    
                    
                }
                
            }
            
        }
        
        UIView.transition(with: self.tensoStackView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.tensoStackView.alpha = 1
        })
        
    }

}
