//
//  AnimateUtilities.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

class AnimateUtilities {
    
    func setAnchorPoint(anchorPoint: CGPoint, view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position: CGPoint = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.anchorPoint = position
        view.layer.anchorPoint = anchorPoint
    }
    
    func move(view: UIView, path : UIBezierPath, duration: CFTimeInterval) {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = MAXFLOAT
        animation.path = path.cgPath
        view.layer.add(animation, forKey: nil)
    }
    
    func rotateAction(view: UIView, fromValue: CGFloat, toValue: CGFloat, duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        animation.autoreverses = false
        animation.repeatCount = .infinity
        
        view.layer.add(animation, forKey: nil)
        
    }
    
    func scaleAction(view: UIView, from: CGFloat, to: CGFloat, duration: CFTimeInterval, autoreverses: Bool) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = from
        animation.toValue = to
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.duration = duration
        
        // repeat
        animation.autoreverses = autoreverses
        animation.repeatCount = .infinity
        
        view.layer.add(animation, forKey: nil)
        
    }
    
    func opacityAction(view: UIView, from: CGFloat, to: CGFloat, duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        animation.autoreverses = true
        animation.repeatCount = .infinity
        
        view.layer.add(animation, forKey: nil)
    }
    
    func allAction(view: UIView,
                   path: UIBezierPath = UIBezierPath(),
                   moveDuration: CFTimeInterval = 0,
                   rotateFrom: CGFloat = 0,
                   rotateTo: CGFloat = 0,
                   rotateDuration: CFTimeInterval = 0,
                   scaleFrom: CGFloat = 0,
                   scaleTo: CGFloat = 0,
                   scaleDuration: CFTimeInterval = 0,
                   autoreverses: Bool = true,
                   opacityFrom: CGFloat = 0,
                   opacityto: CGFloat = 0,
                   opacityDuration: CFTimeInterval = 0) {
        
        // move
        let moveAnimation = CAKeyframeAnimation(keyPath: "position")
        moveAnimation.duration = moveDuration
        moveAnimation.repeatCount = MAXFLOAT
        moveAnimation.path = path.cgPath
        
        // rotate
        let rotateAnimate = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimate.fromValue = rotateFrom
        rotateAnimate.toValue = rotateTo
        rotateAnimate.duration = rotateDuration
        rotateAnimate.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        rotateAnimate.autoreverses = false
        rotateAnimate.repeatCount = .infinity

        // scale
        let scaleAnimate = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimate.fromValue = scaleFrom
        scaleAnimate.toValue = scaleTo
        scaleAnimate.timingFunction = CAMediaTimingFunction(name: .easeIn)
        scaleAnimate.duration = scaleDuration
        
        // scale repeat
        scaleAnimate.autoreverses = autoreverses
        scaleAnimate.repeatCount = .infinity
        
        // opacity
        let opacityAnimate = CABasicAnimation(keyPath: "opacity")
        opacityAnimate.fromValue = opacityFrom
        opacityAnimate.toValue = opacityto
        opacityAnimate.duration = opacityDuration
        opacityAnimate.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        opacityAnimate.autoreverses = true
        opacityAnimate.repeatCount = .infinity
        
//        if rotateFrom != 0 && rotateTo != 0 && rotateDuration != 0 {
//            view.layer.add(rotateAnimate, forKey: nil)
//        }
        if path.isEmpty == false && moveDuration != 0 {
            view.layer.add(moveAnimation, forKey: nil)
        }
        
        if scaleFrom != 0 && scaleTo != 0 && scaleDuration != 0 {
            view.layer.add(scaleAnimate, forKey: nil)
        }
        
        if opacityFrom != 0 && opacityto != 0 && opacityDuration != 0 {
            view.layer.add(opacityAnimate, forKey: nil)
        }
//
        view.layer.add(rotateAnimate, forKey: nil)
//        view.layer.add(scaleAnimate, forKey: nil)
//        view.layer.add(opacityAnimate, forKey: nil)
        
    }
    
    func removeAnimate(view: UIView) {
        view.layer.removeAllAnimations()
    }
}

