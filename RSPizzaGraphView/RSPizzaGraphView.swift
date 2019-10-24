//
//  RSPizzaGraphView.swift
//  RSPizzaGraphView
//
//  Created by Roberto Sampaio on 09/03/17.
//  Copyright © 2017 Roberto Sampaio. All rights reserved.
//

import UIKit

public enum RSPizzaGraphAnimation {
    case circular
    case sliceFading
}

public struct RSPizzaGraph {
    fileprivate let value: Int
    fileprivate let color: UIColor
    
    public init(value: Int, color: UIColor) {
        self.value = value
        self.color = color
    }
}

public class RSPizzaGraphView: UIView {
    
    private var startAngle: CGFloat = CGFloat(2 * Double.pi * -0.25)
    private var endAngle: CGFloat = 0.0
    
    private var graphs: [RSPizzaGraph]?
    private var borderWidth: Double?
    private var circularGraphAnimation: RSPizzaGraphAnimation?
    
    private var shouldShowText = false
    private var font = UIFont.systemFont(ofSize: 12)
    private var textColor = UIColor.black
    
    private var unityText = ""
    
    public func configureGraph(borderWidth: Double ,
                        graphs: [RSPizzaGraph],
                        animation: RSPizzaGraphAnimation,
                        shouldShowText: Bool = false,
                        font: UIFont = UIFont.systemFont(ofSize: 12),
                        textColor: UIColor = UIColor.black,
                        unityText: String = "") {
        self.borderWidth = borderWidth
        self.graphs = graphs
        self.circularGraphAnimation = animation
        self.shouldShowText = shouldShowText
        self.font = font
        self.textColor = textColor
        self.unityText = unityText
        setNeedsDisplay()
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let graphs = graphs, let borderWidth = borderWidth, let circularGraphAnimation = circularGraphAnimation else {
            return
        }
        
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let maskBorderLayer = createMaskBorderLayer(with: rect)
        layer.mask = maskBorderLayer
        let borderLayer = createBorderLayer(with: rect, borderWidth: borderWidth)
        borderLayer.path = maskBorderLayer.path
        
        layer.addSublayer(borderLayer)
        
        if circularGraphAnimation == .circular {
            buildSlices(with: rect, borderWidth: borderWidth, graphs: graphs, on: borderLayer)
            let animatedBorderLayer = createBorderLayer(with: rect, borderWidth: borderWidth)
            animatedBorderLayer.path = maskBorderLayer.path
            borderLayer.addSublayer(animatedBorderLayer)
            addCircularAnimation(on: animatedBorderLayer)
        } else {
            buildSlicesWithFadingAnimation(with: rect, graphs: graphs, borderWidth: borderWidth, on: borderLayer)
        }
        
        let maskOpacityLayer = createMaskOpacityLayer(with: rect)
        let opacityLayer = createOpacityLayer(with: rect)
        opacityLayer.path = maskOpacityLayer.path
        
        borderLayer.addSublayer(opacityLayer)
        
    }
    
    private func buildSlices(with rect: CGRect, borderWidth: Double, graphs: [RSPizzaGraph], on borderLayer: CAShapeLayer) {
        let sum = graphs.map {$0.value}.reduce(0, +)
        graphs.forEach { graph in
            let maskSliceLayer = createMaskLayer(with: rect, sum: sum, value: graph.value)
            let sliceLayer = createSliceLayer(with:maskSliceLayer, borderWidth: borderWidth, strokeColor: graph.color)
            borderLayer.addSublayer(sliceLayer)
        }
    }
    
    private func buildSlicesWithFadingAnimation(with rect: CGRect, graphs: [RSPizzaGraph], borderWidth: Double, on borderLayer: CAShapeLayer) {
        let sum = graphs.map {$0.value}.reduce(0, +)
        for (index, graph) in graphs.enumerated() {
            let animationDuration = 0.3
            let beginTime = animationDuration * Double(index)
            
            let maskSliceLayer = createMaskLayer(with: rect, sum: sum, value: graph.value)
            let sliceLayer = createSliceLayer(with:maskSliceLayer, borderWidth: borderWidth, strokeColor: graph.color)
            sliceLayer.opacity = 0.0
            
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.duration = animationDuration
            animation.fromValue = 0
            animation.toValue = 1
            animation.isRemovedOnCompletion = false
            animation.fillMode = CAMediaTimingFillMode.forwards
            
            animation.beginTime = CACurrentMediaTime() + beginTime
            sliceLayer.add(animation, forKey: "circularAnimation")
            
            borderLayer.addSublayer(sliceLayer)
        }
    }
    
    private func addCircularAnimation(on borderLayer: CALayer) {
        
        let animation = CABasicAnimation(keyPath: "strokeStart");
        animation.fromValue = 0
        animation.toValue = 1
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.duration = 1.0
        
        borderLayer.add(animation, forKey: "strokeStart")
        
    }
    
    private func createSliceLayer(with maskSliceLayer: CAShapeLayer, borderWidth: Double, strokeColor: UIColor) -> CAShapeLayer {
        let sliceLayer = CAShapeLayer()
        sliceLayer.fillColor = UIColor.clear.cgColor
        sliceLayer.strokeColor = strokeColor.cgColor
        sliceLayer.lineWidth = CGFloat(borderWidth)
        sliceLayer.path = maskSliceLayer.path
        return sliceLayer
    }
    
    private func createMaskBorderLayer(with rect: CGRect) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.size.width/2)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        return layer
    }
    
    private func createBorderLayer(with rect: CGRect, borderWidth: Double) -> CAShapeLayer {
        let borderLayer = CAShapeLayer()
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.lineWidth = CGFloat(borderWidth)
        return borderLayer
    }
    
    private func createMaskOpacityLayer(with rect: CGRect) -> CAShapeLayer {
        let smallWidth = 4*rect.width/7
        let smallHeight = 4*rect.height/7
        let smallRect = CGRect(x: ((rect.minX + rect.maxX) / 2) - smallWidth/2,
                               y: (rect.minY + rect.maxY) / 2 - smallHeight/2,
                               width: smallWidth,
                               height: smallHeight)
        let path = UIBezierPath(roundedRect: smallRect, cornerRadius: smallRect.size.width/2)
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        
        return layer
    }
    
    private func createOpacityLayer(with rect: CGRect) -> CAShapeLayer {
        let opacityLayer = CAShapeLayer()
        opacityLayer.fillColor = UIColor.white.cgColor
        opacityLayer.opacity = 0.16
        return opacityLayer
    }
    
    private func createMaskLayer(with rect: CGRect, sum: Int, value: Int) -> CAShapeLayer {
        let percent = Double(value)/Double(sum)
        
        let center = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        let cornerRadius = rect.size.width/2
        
        endAngle = CGFloat(startAngle + CGFloat(2 * Double.pi * percent))
        
        let path = UIBezierPath(arcCenter: center, radius: cornerRadius, startAngle: CGFloat(startAngle), endAngle: endAngle, clockwise: true)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        
        if shouldShowText {
            let label = UILabel()
            label.font = font
            
            label.text = "\(String(value))\(unityText)"
            label.textColor = textColor
            label.sizeToFit()
            let radius = (CGFloat(rect.size.width) + (4*rect.width/7)) / 2
            let diffAngle = startAngle + ((endAngle - startAngle) / 2)
            
            let x = center.x + (cos(diffAngle) * CGFloat(radius) / 2)
            let y = center.y + (sin(diffAngle) * CGFloat(radius) / 2)
            
            label.frame = CGRect(x: x - label.frame.width/2,
                                 y: y - label.frame.height/2,
                                 width: label.frame.width,
                                 height: label.frame.height)
            
            self.addSubview(label)
        }
        
        startAngle = endAngle
        return layer
    }
    
}

