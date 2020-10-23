//
//  DrawView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

class DrawView: UIImageView {
    
    //MARK: - Properties
    var penColor = UIColor.black
    var penSize: CGFloat = 6.0
    var currentIndex : Int = 0
    private var lines = [Line]()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in: self)
        if lines.count == 0 {
            lines.append(Line.init(points: [] ,image: UIImage(), path: UIBezierPath()))
        } else {
            lines.append(Line.init(points:lines[lines.count-1].points,image: UIImage(), path: lines[lines.count-1].path))
        }
        guard var line = lines.popLast() else {return}
        line.points.append(currentPoint)
        line.path.lineWidth = penSize
        line.path.lineCapStyle = CGLineCap.round
        line.path.lineJoinStyle = CGLineJoin.round
        line.path.move(to: currentPoint)
        lines.append(line)
        setNeedsDisplay()

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in: self)
        guard var line = lines.popLast() else {return}
        line.path.addLine(to: currentPoint)
        line.points.append(currentPoint)
        lines.append(line)
        drawLine()
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in: self)
        guard var line = lines.popLast() else {return}
        line.path.addLine(to: currentPoint)
        line.points.append(currentPoint)
        lines.append(line)
        drawLine()
        for i in 0..<lines.count {
            print(lines[i].points.count)
        }
    }
    
    //MARK: - Helpers
    func undo() {
        
        guard var lastLine = lines.popLast() else {return}
        lines.append(lastLine)
        let count = lines.count
        var countPoints = 0
        //draw previous lines
        lastLine.path = UIBezierPath()
        lastLine.image = UIImage()
        lastLine.path.lineWidth = penSize
        for i in 0..<count {
            for j in countPoints..<lines[i].points.count-1 {
                lastLine.path.move(to: lines[i].points[j])
                lastLine.path.addLine(to: lines[i].points[j+1])
            }
            countPoints = lines[i].points.count
        }
         UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
         lastLine.image.draw(at: CGPoint.zero)
        penColor.setStroke()
         lastLine.path.stroke()
        self.image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        _ = lines.popLast()
        lines.append(lastLine)
       
    }

    func drawLine() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        print("drawLine \(lines.count)")
        guard let lastLine = lines.popLast() else {return}
        lastLine.image.draw(at: CGPoint.zero)
        penColor.setStroke()
        lastLine.path.stroke()
        lines.append(lastLine)
        self.image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        setNeedsDisplay()
    }
    
    func setting(_ liness : [Line]) {
        lines = liness
    }
    
    func getLines() -> [Line] {
        return lines
    }
    
    func getPoints() -> [CGPoint] {
        let count = lines.count-1
        if count >= 0 {
            return  lines[count].points
        }
        return [CGPoint()]
    }

    func popLines() {
        _ = lines.popLast()
    }
    
    func connect2Points() {
        let lastDrawImage = UIImage()
        let path = UIBezierPath()
        let count = lines.count-1
        path.lineWidth = penSize
        print("lines.count = \(lines.count)" )
        for i in 0..<lines[count].points.count-1 {
            path.move(to: lines[count].points[i])
            path.addLine(to: lines[count].points[i+1])
        }
        let countt = lines[count].points.count-1
        path.move(to: lines[count].points[countt])
        path.addLine(to: lines[count].points[0])
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        lastDrawImage.draw(at: CGPoint.zero)
        penColor.setStroke()
        path.stroke()
        self.image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
    ///fixed
    func reset() {
        lines = [Line]()
    }
    ///fixed
//    func resetLine() {
//        let lastDrawImage = UIImage()
//        let path = UIBezierPath()
//        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
//        lastDrawImage.draw(at: CGPoint.zero)
//        penColor.setStroke()
//        path.stroke()
//        self.image = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//    }
}


