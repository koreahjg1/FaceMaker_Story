//
//  FaceAreaButton.swift
//  FaceMaker_Story
//
//  Created by Jonggi Hong on 1/21/18.
//  Copyright © 2018 Jonggi Hong. All rights reserved.
//

import UIKit

class FaceAreaButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var drawRect: CGRect?
    override func draw(_ rect: CGRect) {
        /*
        self.backgroundColor = .clear
        let path = UIBezierPath(ovalIn: rect)
        UIColor.white.setFill()
        path.fill()
        */
        
        let path2 = UIBezierPath(ovalIn: CGRect(x: rect.minX + 10, y: rect.minY + 10, width: rect.width - 20, height: rect.height - 20))
        UIColor.red.setStroke()
        path2.lineWidth = 5
        path2.stroke()
        drawRect = rect
    }
    
    func fillFace(image: UIImage) {
        blink(enabled: false)
        
        guard let rect = drawRect else {
            print("no rect")
            return
        }
        
        self.backgroundColor = .clear
        let path = UIBezierPath(ovalIn: rect)
        UIColor.white.setFill()
        path.fill()
        
        let path2 = UIBezierPath(ovalIn: CGRect(x: rect.minX + 10, y: rect.minY + 10, width: rect.width - 20, height: rect.height - 20))
        UIColor.red.setStroke()
        path2.lineWidth = 5
        path2.stroke()
    }
    
    func blink(enabled: Bool = true, duration: CFTimeInterval = 1.0, stopAfter: CFTimeInterval = 0.0 ) {
        enabled ? (UIView.animate(withDuration: duration, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: { [weak self] _ in self?.alpha = 1.0 })) : self.layer.removeAllAnimations()
        if !stopAfter.isEqual(to: 0.0) && enabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + stopAfter) { [weak self] in
                self?.layer.removeAllAnimations()
            }
        }
    }
}
