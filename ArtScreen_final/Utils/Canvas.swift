//
//  Canvas.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

class CircleView: UIView {
    var outGoingLine: CAShapeLayer?
    var inComingLine: CAShapeLayer?
    var inComingCircle: CircleView?
    var outGoingCircle: CircleView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func lineTo(circle: CircleView) -> CAShapeLayer {
        let path = UIBezierPath()
        path.move(to: self.center)
        path.addLine(to: circle.center)
        
        let line = CAShapeLayer()
        line.path = path.cgPath
        line.lineWidth = 1.6
        line.strokeColor = UIColor.mainPurple.cgColor
        circle.inComingLine = line
        outGoingLine = line
        outGoingCircle = circle
        circle.inComingCircle = self
        return line
    }
}


class Canvas: UIView {
   
    //let aDegree = CGFloat.pi / 180
    //var firstCircle: CircleView!
    
//    var lineColor = UIColor.white
//    var lineWidth: CGFloat = 5
//    var path: UIBezierPath!
//    var touchPoint: CGPoint!
//    var startingPoint: CGPoint!
    
//    /// count how many dots have
//    var pointCount: Int = 0
//    var initPoint: CGPoint!
    
//    /// add a red dot wher you tap
//    var dotView: UIView!
    
//    /// to contain all of the points
//    var pointsArray = [CGPoint]()
    
//    /// to contain all of the dots
//    var pointsViewArray = [UIView]()
    
    
    
    /// Path for drawing
    var path: UIBezierPath!
    
    /// the drawing is end or not
    var endDrawingStatus: Bool = false
    
    /// To contain all of the circle view
    var pointsCircleViewArray = [CircleView]()
    
    /// Mask layer that return to ViewController
    var maskLayer: CAShapeLayer!
    
    /// Path to make the mask Layer
    var finalPath: UIBezierPath!
    
    /// Tap gesture for single tap
    var singleFinger: UITapGestureRecognizer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("---Canvas added---")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - After tap action ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if endDrawingStatus == false {
            /// tap gesture of singleFinger
            singleFinger = UITapGestureRecognizer(target: self, action: #selector(singleTap))
            self.addGestureRecognizer(singleFinger)
        }else {
            print("can't add new point")
        }
    }
    
    @objc func singleTap(recognizer: UITapGestureRecognizer) {
        //print("singleTap")
        let position = recognizer.location(in: self)
        let circle1 = CircleView(frame: CGRect(x: position.x, y: position.y, width: 12, height: 12))
        circle1.backgroundColor = .white
        circle1.layer.borderWidth = 1.6
        circle1.layer.borderColor = UIColor.mainPurple.cgColor
        self.addSubview(circle1)
        
        /// Each circle can be dragged
        circle1.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanGesture)))
        
        /// Add the circle into the array
        pointsCircleViewArray.append(circle1)
        
        let count = pointsCircleViewArray.count
        if count == 1 {
            print("index = \(count)")
            print(pointsCircleViewArray)
        }else if count > 1 {
            print("index = \(count)")
            print(pointsCircleViewArray)
            self.layer.addSublayer(pointsCircleViewArray[count - 2].lineTo(circle: pointsCircleViewArray[count - 1]))
        }
        

    }
    
    // MARK: - Drag action of circle
    @objc func didPanGesture(gesture: UIPanGestureRecognizer) {
        guard let circle = gesture.view as? CircleView else {
            return
        }
        if (gesture.state == .began) {
            circle.center = gesture.location(in: self)
        }
        let newCenter: CGPoint = gesture.location(in: self)
        let dX = newCenter.x - circle.center.x
        let dY = newCenter.y - circle.center.y
        circle.center = CGPoint(x: circle.center.x + dX, y: circle.center.y + dY)
        
        if let outGoingCircle = circle.outGoingCircle, let line = circle.outGoingLine, let path = circle.outGoingLine?.path {
            let newPath = UIBezierPath(cgPath: path)
            newPath.removeAllPoints()
            newPath.move(to: circle.center)
            newPath.addLine(to: outGoingCircle.center)
            line.path = newPath.cgPath
        }
        
        if let inComingCircle = circle.inComingCircle, let line = circle.inComingLine, let path = circle.inComingLine?.path {
            let newPath = UIBezierPath(cgPath: path)
            newPath.removeAllPoints()
            newPath.move(to: inComingCircle.center)
            newPath.addLine(to: circle.center)
            line.path = newPath.cgPath
        }
    }



//
//    func draw() {
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = path.cgPath
//        shapeLayer.strokeColor = lineColor.cgColor
//        shapeLayer.lineWidth = lineWidth
//        if endDrawingStatus == true {
//            shapeLayer.fillColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
//        }else {
//            shapeLayer.fillColor = UIColor.clear.cgColor
//        }
//        self.layer.addSublayer(shapeLayer)
////        self.setNeedsDisplay()
//    }

//
//    func addDot(pointX: Int, pointY: Int) {
//        dotView = UIView()
//        dotView.frame = CGRect.init(x: pointX - 10 , y: pointY - 10, width: 20, height: 20)
//        dotView.backgroundColor = UIColor.red
//        dotView.layer.cornerRadius = dotView.frame.height/2
//
//        /// let the dot can be dragged
//        dotView.isUserInteractionEnabled = true
//        self.addSubview(dotView)
//
//        /// add the point view to array
//        pointsViewArray.append(dotView)
//
//    }
    
    func endDrawing() {
        let count = pointsCircleViewArray.count
        
        /// Draw a line between the endPoint and the firstPoint
        self.layer.addSublayer(pointsCircleViewArray[count - 1].lineTo(circle: pointsCircleViewArray[0]))
        print("endDrawingStatus: \(endDrawingStatus)")
        
        /// cant't add point after endDrawing button be tapped
        singleFinger.isEnabled = false
    }
    
    func clearCanvas() {
        /// Delete all of the dot positions in the array
        pointsCircleViewArray.removeAll()
        
        print(pointsCircleViewArray)
        
        /// Delete all of the red dots
        for dot in self.subviews {
            dot.removeFromSuperview()
        }
        /// Delete all of the yellow paths
        self.layer.sublayers = nil
        
        /// can add point after the view was cleaned
        singleFinger.isEnabled = true
        
        
    }
    
    func setMaskLayer() -> CAShapeLayer {
        maskLayer = CAShapeLayer()
        
        finalPath = UIBezierPath()
        //var point = CGPoint()
        
        /// To draw a whole path within the circles that were in the array
        for index in 0 ..< pointsCircleViewArray.count {
            let circleRadius = pointsCircleViewArray[index].frame.width / 2
            let point = CGPoint(x: pointsCircleViewArray[index].frame.origin.x + circleRadius, y: pointsCircleViewArray[index].frame.origin.y + circleRadius)
            if index == 0 {
                finalPath.move(to: point)
            }else if index == pointsCircleViewArray.count - 1 {
                finalPath.addLine(to: point)
                finalPath.close()
            }else {
                finalPath.addLine(to: point)
            }
            
        }
        
        /// Set final path to the mask's path
        maskLayer.path = finalPath.cgPath
        
        /// Return the mask to VC
        return maskLayer
        //return finalPath
    }
    
    func getPath() -> UIBezierPath {
        /// Return final path to VC
        return finalPath
    }

    
}


