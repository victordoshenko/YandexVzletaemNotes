//
//  HSBColorPicker.swift
//  Note
//
//  Created by Victor Doshchenko on 08/07/2019.
//  Copyright © 2019 Victor Doshchenko. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPickerCursorView : UIView {
    var shapePosition: CGPoint = .zero
    var shapeSize: CGSize = CGSize(width: 40, height: 40)
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("draw Cursor!...")
        
        let pathWhite = UIBezierPath()
        pathWhite.lineWidth = 1
        UIColor.white.setStroke()
        pathWhite.addArc(withCenter: CGPoint(x: 25, y: 25), radius: 15, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        pathWhite.move(to: CGPoint(x: 26, y: 10))
        pathWhite.addLine(to: CGPoint(x: 26, y: 0))
        pathWhite.move(to: CGPoint(x: 10, y: 25))
        pathWhite.addLine(to: CGPoint(x: 0, y: 25))
        pathWhite.move(to: CGPoint(x: 26, y: 40))
        pathWhite.addLine(to: CGPoint(x: 26, y: 50))
        pathWhite.move(to: CGPoint(x: 40, y: 25))
        pathWhite.addLine(to: CGPoint(x: 50, y: 25))
        pathWhite.close()
        pathWhite.stroke()
        
        let pathBlack = UIBezierPath()
        pathBlack.lineWidth = 1
        UIColor.black.setStroke()
        pathBlack.addArc(withCenter: CGPoint(x: 25, y: 25), radius: 14, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        pathBlack.move(to: CGPoint(x: 25, y: 10))
        pathBlack.addLine(to: CGPoint(x: 25, y: 0))
        pathBlack.move(to: CGPoint(x: 10, y: 24))
        pathBlack.addLine(to: CGPoint(x: 0, y: 24))
        pathBlack.move(to: CGPoint(x: 25, y: 40))
        pathBlack.addLine(to: CGPoint(x: 25, y: 50))
        pathBlack.move(to: CGPoint(x: 40, y: 24))
        pathBlack.addLine(to: CGPoint(x: 50, y: 24))
        pathBlack.close()
        pathBlack.stroke()
    }
}

@IBDesignable
class HSBColorPicker : UIView {

    let saturationExponentTop:Float = 1.1
    let saturationExponentBottom:Float = 1.3
    var ColorChoosen: UIColor = UIColor.white
    var ColorChoosenView: UIView!
    var ColorChoosenLabel: UILabel!
    var colorPickerCursorView = ColorPickerCursorView()
    var Brightness: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var elementSize: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func initialize() {
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
        self.addSubview(colorPickerCursorView)
        //colorPickerCursorView.frame = CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 50, height: 50))
        //colorPickerCursorView.frame = CGRect(origin: getPointForColor(color: ColorChoosen), size: CGSize(width: 50, height: 50))
        colorPickerCursorView.backgroundColor = UIColor.clear
        print("initialize HSB")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    public func updateUI() {
        ColorChoosenView.backgroundColor = ColorChoosen
        ColorChoosenLabel.text = "  #" + (ColorChoosen.toHex() ?? "")
        colorPickerCursorView.frame = CGRect(origin: getPointForColor(color: ColorChoosen), size: CGSize(width: 50, height: 50))
    }
        
    override func draw(_ rect: CGRect) {
        print("draw!...")
        let context = UIGraphicsGetCurrentContext()
        for y : CGFloat in stride(from: 0.0 ,to: rect.height, by: elementSize) {
            for x : CGFloat in stride(from: 0.0 ,to: rect.width, by: elementSize) {
                let color = getColorAtPoint(point: CGPoint(x: x, y: y))
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
        ColorChoosen = getColorAtPoint(point: CGPoint(x: colorPickerCursorView.center.x, y: colorPickerCursorView.center.y))
        //colorPickerCursorView.draw(rect)
        updateUI()
    }
    
    func getColorAtPoint(point:CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int((self.bounds.height - point.y) / elementSize)))
        var saturation = roundedPoint.y < self.bounds.height / 1.0 ? CGFloat(1 * roundedPoint.y) / self.bounds.height
            : 1.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 1.0 ? saturationExponentTop : saturationExponentBottom))
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: Brightness, alpha: 1.0)
    }

    func getPointForColor(color:UIColor) -> CGPoint {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        
        var yPos:CGFloat = 0
        let halfHeight = CGFloat(self.bounds.height / 1)
        
        let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
        yPos = CGFloat(percentageY) * halfHeight
        
        let xPos = hue * self.bounds.width
        print("GetPoint ", color)
        return CGPoint(x: xPos, y: self.bounds.height - yPos)
    }

    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed) {
            let point = gestureRecognizer.location(in: self)
            ColorChoosen = getColorAtPoint(point: point)
            print("Color: ", ColorChoosen)
            updateUI()
            colorPickerCursorView.center.x = point.x
            colorPickerCursorView.center.y = point.y
        }
    }
}

extension UIColor {
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lx%02lx%02lx%02lx", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lx%02lx%02lx", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
