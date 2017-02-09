//
//  ProgressCircleBar.swift
//  PokemonTest
//
//  Created by Thai Duong on 2/8/17.
//  Copyright © 2017 Thai Duong. All rights reserved.
//

import UIKit
@IBDesignable

class ProgressCircleBar: UIView {
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    @IBInspectable var fillColor: UIColor = .white
    @IBInspectable var seconds: Double = 12
    @IBInspectable var timeInterval: Double = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let angle = CGFloat(2*M_PI) / CGFloat(seconds)
        
        let backgroundPath = UIBezierPath()
        backgroundPath.move(to: CGPoint(x: self.bounds.width/2, y: self.bounds.height/2.0))
        backgroundPath.addLine(to: CGPoint(x: self.bounds.width/2, y: 0))
        backgroundPath.addArc(withCenter: CGPoint(x:self.bounds.width/2, y:self.bounds.height/2.0), radius: self.bounds.width/2.0, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        fillColor.withAlphaComponent(0.6).setFill()
        backgroundPath.fill()
        
        let circlePath = UIBezierPath()
        circlePath.move(to: CGPoint(x: self.bounds.width/2, y: self.bounds.height/2.0))
        circlePath.addLine(to: CGPoint(x: self.bounds.width/2, y: 0))
        circlePath.addArc(withCenter: CGPoint(x:self.bounds.width/2, y:self.bounds.height/2.0), radius: self.bounds.width/2.0, startAngle: 3*CGFloat(M_PI)/2, endAngle: 3*CGFloat(M_PI)/2 + angle*CGFloat(timeInterval), clockwise: true)
        fillColor.setFill()
        circlePath.fill()
    }
    
    
}
