import UIKit
import PlaygroundSupport

import Accelerate
import simd
import AVFoundation

let stackViewRectangle = CGRect(origin: .zero, size: CGSize(width: 375, height: 667))

let sourceRectangle = CGRect(origin: .zero, size: CGSize(width: 375, height: 667/3))

func randomCrop(within rect: CGRect) -> (CGRect,CGRect) {
    
    let smallestCropWidth = rect.width / 6
    let smallestCropHeight = rect.height / 2
    
    let minX = rect.minX
    let maxX = rect.maxX - smallestCropWidth
    let minY = rect.minY
    let maxY = rect.maxY - smallestCropHeight
    
    let randomPoint = CGPoint(
        x: CGFloat.random(in: minX...maxX),
        y: CGFloat.random(in: minY...maxY)
    )
    
    return (CGRect(x: randomPoint.x,
                  y: randomPoint.y,
                  width: smallestCropWidth,
                  height: smallestCropHeight),
            
            CGRect(x: minX,
                   y: minY,
                   width: maxX - minX,
                   height: maxY - minY
            )
    )
}



class RectViewController : UIViewController {
    override func loadView() {
        
        let view = UIView(frame: stackViewRectangle)
        view.backgroundColor = .lightGray
        

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .darkGray


        view.addSubview(stackView)
        
        view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[stackView]-20-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil,views: ["stackView": stackView])
        )
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[stackView]-20-|",
                                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["stackView": stackView])
        )
        
       
        
        let randomRectangle = randomCrop(within: sourceRectangle)
        
        let aspectFace = AVMakeRect(aspectRatio: sourceRectangle.size, insideRect: randomRectangle.0)
        
        var h : CGFloat = 0
        var w : CGFloat = 0
        var x : CGFloat = 0
        var y : CGFloat = 0
        
        let aspect = aspectFace.width / aspectFace.height
        
        if(aspectFace.height == randomRectangle.0.height){
            
            h = randomRectangle.0.width
            w = aspectFace.height * aspect
            y = randomRectangle.0.minY - (h - randomRectangle.0.height) / 2
            x = randomRectangle.0.minX
            
        } else if(aspectFace.width == randomRectangle.0.width){
            
            h = randomRectangle.0.height
            w = aspectFace.width * aspect
            x = randomRectangle.0.minX - (w - randomRectangle.0.width) / 2
            y = randomRectangle.0.minY
        }
        
        let finalFace = CGRect(origin:
            CGPoint(
                x: x,
                y: y
            ),
            size:
            
            CGSize(width: w, height: h))
        
         let zooms = interpolate(start: sourceRectangle, finish: randomRectangle.0)
        
        let aspectZooms = interpolate(start: sourceRectangle, finish: finalFace)
        
       
        for (index,zoom) in aspectZooms.enumerated(){
            
            //if(![1,4,9].contains(index)){ print(index); return }
            
            let zoomRect = RectView(frame: sourceRectangle)
            
            zoomRect.zoom = zoom
            
            zoomRect.orginalZoom = zooms[index]
            
            
            zoomRect.backgroundColor = UIColor.random
            
            zoomRect.heightAnchor.constraint(equalToConstant: sourceRectangle.height).isActive = true
            zoomRect.widthAnchor.constraint(equalToConstant: sourceRectangle.width).isActive = true
            
            stackView.addArrangedSubview(zoomRect)
            
            print(index)
            
        }
        
        
        self.view = view
            
        
    }
}

class RectView: UIView {
    
    var zoom : CGRect?
    var orginalZoom : CGRect?
    
    override func draw(_ rect: CGRect) {
        
        if let zoom = zoom {
        
            let rect2 = UIBezierPath(rect:zoom)
            UIColor.random.set()
            rect2.fill(with: .multiply, alpha: 0.5)
        
        }
        
        if let zoom2 = orginalZoom {
            
            let rect3 = UIBezierPath(rect:zoom2)
            UIColor.random.set()
            rect3.fill(with: .multiply, alpha: 0.5)
            
        }
        
       super.draw(rect)
        
    }
}

func interpolate(start: CGRect, finish : CGRect) ->  [CGRect]{
    
    return stride(from: 0.0, to: 1.0, by: 1 / 3).map { x in
        
        let originX = simd_mix(Double(start.minX), Double(finish.minX), x )
        let originY = simd_mix(Double(start.minY), Double(finish.minY), x )
        
        let origin = CGPoint(x: originX, y: originY)
        
        let height = simd_mix(Double(start.height), Double(finish.height), x)
        let width = simd_mix(Double(start.width), Double(finish.width), x)
        
        let size = CGSize(width: width, height: height)
        
        return CGRect(origin: origin, size: size)
        
    }
    
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}

//func createStackView() -> UIStackView {
//
//
//
//    return stackView
//}


PlaygroundPage.current.liveView = RectViewController()
