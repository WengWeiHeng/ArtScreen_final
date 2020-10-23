//
//  MoveDrawView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

protocol MoveDrawViewDelegate : class {
    func drawMovePath(_ path : UIBezierPath)
}

class MoveDrawView: UIImageView {
    
    //MARK: - Properties
    weak var delegate : MoveDrawViewDelegate?
    
    var penColor = UIColor.black
    var penSize: CGFloat = 6
    var path: UIBezierPath!
    var originalImageX: CGFloat = 0
    var originalImageY: CGFloat = 0
    var originalImagePath: UIBezierPath!
    private var lastDrawImage: UIImage?

    private var temporaryPath: UIBezierPath!
    private var points = [CGPoint]()

    private var pointCount = 0
    private var snapshotImage: UIImage?

    private var isCallTouchMoved = false

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        originalImageX = frame.origin.x
        originalImageY = frame.origin.y
        print("originalImageY = \(originalImageY)")
        isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in: self)
        path = UIBezierPath()
        path?.lineWidth = penSize
        path?.lineCapStyle = CGLineCap.round
        path?.lineJoinStyle = CGLineJoin.round
        path?.move(to: currentPoint)
        originalImagePath = UIBezierPath()
        originalImagePath.move(to: CGPoint(x: currentPoint.x + originalImageX, y: currentPoint.y + originalImageY))
        points = [currentPoint]
        pointCount = 0
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        isCallTouchMoved = true
        pointCount += 1
        let currentPoint = touches.first!.location(in: self)
        points.append(currentPoint)
        if points.count == 2 {
            temporaryPath = UIBezierPath()
            temporaryPath?.lineWidth = penSize
            temporaryPath?.lineCapStyle = .round
            temporaryPath?.lineJoinStyle = .round
            temporaryPath?.move(to: points[0])
            temporaryPath?.addLine(to: points[1])
            image = drawLine()
        }else if points.count == 3 {
            temporaryPath = UIBezierPath()
            temporaryPath?.lineWidth = penSize
            temporaryPath?.lineCapStyle = .round
            temporaryPath?.lineJoinStyle = .round
            temporaryPath?.move(to: points[0])
            temporaryPath?.addQuadCurve(to: points[2], controlPoint: points[1])
            image = drawLine()
        }else if points.count == 4 {
            temporaryPath = UIBezierPath()
            temporaryPath?.lineWidth = penSize
            temporaryPath?.lineCapStyle = .round
            temporaryPath?.lineJoinStyle = .round
            temporaryPath?.move(to: points[0])
            temporaryPath?.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
            image = drawLine()
        }else if points.count == 5 {
            points[3] = CGPoint(x: (points[2].x + points[4].x) * 0.5, y: (points[2].y + points[4].y) * 0.5)
            if points[4] != points[3] {
                let length = hypot(points[4].x - points[3].x, points[4].y - points[3].y) / 2.0
                let angle = atan2(points[3].y - points[2].y, points[4].x - points[3].x)
                let controlPoint = CGPoint(x: points[3].x + cos(angle) * length, y: points[3].y + sin(angle) * length)
                temporaryPath = UIBezierPath()
                temporaryPath?.move(to: points[3])
                temporaryPath?.lineWidth = penSize
                temporaryPath?.lineCapStyle = .round
                temporaryPath?.lineJoinStyle = .round
                temporaryPath?.addQuadCurve(to: points[4], controlPoint: controlPoint)
            } else {
                temporaryPath = nil
            }
            path?.move(to: points[0])
            path?.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
            originalImagePath.move(to: CGPoint(x: points[0].x + originalImageX, y: points[0].y + originalImageY))
            originalImagePath.addCurve(to: CGPoint(x: points[3].x + originalImageX, y: points[3].y + originalImageY), controlPoint1: CGPoint(x: points[1].x + originalImageX, y: points[1].y + originalImageY), controlPoint2: CGPoint(x: points[2].x + originalImageX, y: points[2].y + originalImageY))
            points = [points[3], points[4]]
            image = drawLine()
        }
        if pointCount > 50 {
            temporaryPath = nil
            snapshotImage = drawLine()
            path.removeAllPoints()
            pointCount = 0
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in: self)
        if !isCallTouchMoved {
            path?.addLine(to: currentPoint)
            originalImagePath.addLine(to: CGPoint(x: currentPoint.x + originalImageX, y: currentPoint.y + originalImageY))
        }
        image = drawLine()
        lastDrawImage = image
        temporaryPath = nil
        snapshotImage = nil
        isCallTouchMoved = false
        delegate?.drawMovePath(originalImagePath)
        print("end")
    }

    //MARK: - Helpers
    func drawLine() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        if snapshotImage != nil {
            snapshotImage?.draw(at: CGPoint.zero)
        }else {
            lastDrawImage?.draw(at: CGPoint.zero)
        }
        penColor.setStroke()
        path?.stroke()
        temporaryPath?.stroke()
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return capturedImage
    }
}

