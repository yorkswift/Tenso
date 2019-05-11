import UIKit
import PlaygroundSupport

import Accelerate
import simd

let sourceRectangle = CGRect(origin: .zero, size: CGSize(width: 600/3, height: 342/3))

func randomCrop(within rect: CGRect) -> (CGRect,CGRect) {
    
    let smallestCropWidth = rect.width / 4
    let smallestCropHeight = rect.height / 3
    
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
        
            
            let view = UIView()
            view.backgroundColor = .white
            
            let source = RectView(frame: sourceRectangle)
            source.backgroundColor = .purple

            view.addSubview(source)
            self.view = view
            
        
    }
}

class RectView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let randomRectangle = randomCrop(within: rect)
        
        let zooms = interpolate(start: rect, finish: randomRectangle.0)
        
        for (index,zoom) in zooms.enumerated(){
            
            if(![1,4,9].contains(index)){ return }
            let rect = UIBezierPath(rect: zoom)
            UIColor.random.set()
            rect.fill()
    

        }
        
//        let rect2 = UIBezierPath(rect: randomRectangle.0)
//        UIColor.blue.set()
//        rect2.fill()
        
        
    }
}

func interpolate(start: CGRect, finish : CGRect) ->  [CGRect]{
    
    return stride(from: 0.0, to: 1.0, by: 1 / 10).map { x in
        
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

PlaygroundPage.current.liveView = RectViewController()
