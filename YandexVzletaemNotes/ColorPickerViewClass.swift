//
//  ColorPickerViewClass.swift
//  Note
//
//  Created by Victor Doshchenko on 14/07/2019.
//  Copyright © 2019 Victor Doshchenko. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPickerViewClass: UIView {
    
    private var colorChoosenView = UIView()
    private var colorChoosenLabel = UILabel()
    private var brightnessLabel = UILabel()
    public var mySlider = UISlider()
    public var colorPickerView = HSBColorPicker()
    private var doneButton = UIButton()
    var noteView: UIView!
    var textView: UITextView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override var intrinsicContentSize: CGSize {
        let colorChoosenViewSize = colorChoosenView.intrinsicContentSize
        //let colorChoosenLabelSize = colorChoosenLabel.intrinsicContentSize
        //let brightnessLabelSize = brightnessLabel.intrinsicContentSize
        let mySliderSize = mySlider.intrinsicContentSize
        let colorPickerViewSize = colorPickerView.intrinsicContentSize
        let doneButtonSize = doneButton.intrinsicContentSize

        let width = colorChoosenViewSize.width + myMargin + mySliderSize.width
        let height = colorChoosenViewSize.height + myMargin + colorPickerViewSize.height + myMargin + doneButtonSize.height
        return CGSize(width: width, height: height)
    }
    
    private let myMargin: CGFloat = 8
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let colorChoosenViewSize = CGSize(width: 85, height: 85)
        colorChoosenView.frame = CGRect(origin: CGPoint(x: bounds.minX, y: bounds.minY), size: colorChoosenViewSize)
        
        let colorChoosenLabelSize = CGSize(width: colorChoosenViewSize.width, height: 18)
        colorChoosenLabel.frame = CGRect(origin: CGPoint(x: bounds.minX, y: colorChoosenViewSize.height - colorChoosenLabelSize.height), size: colorChoosenLabelSize)
        
        let mySliderSize = CGSize(width: bounds.maxX - colorChoosenViewSize.width - myMargin, height: 18)
        mySlider.frame = CGRect(
            origin: CGPoint(x: bounds.minX + colorChoosenViewSize.width + myMargin, y: bounds.minY + colorChoosenViewSize.height - mySliderSize.height),
            size: mySliderSize)

        let brightnessLabelSize = CGSize(width: 200, height: 18)
        brightnessLabel.frame = CGRect(
            origin: CGPoint(x: bounds.minX + colorChoosenViewSize.width + myMargin, y: bounds.minY + colorChoosenViewSize.height - mySliderSize.height - brightnessLabelSize.height - myMargin * 3),
            size: brightnessLabelSize)

        let doneButtonSize = CGSize(width: 100, height: 30)
        doneButton.frame = CGRect(origin: CGPoint(x: (bounds.maxX - bounds.minX - doneButtonSize.width) / 2, y: bounds.maxY - doneButtonSize.height),size: doneButtonSize)

        let colorPickerViewSize = CGSize(width: bounds.maxX, height: bounds.maxY - colorChoosenViewSize.height - doneButtonSize.height - myMargin * 2)
        colorPickerView.frame = CGRect(
            origin: CGPoint(x: bounds.minX, y: bounds.minY + colorChoosenViewSize.height + myMargin),
            size: colorPickerViewSize)

        /*
        let colorPickerCursorViewSize = CGSize(width: 40, height: 40)
        colorPickerView.colorPickerCursorView.frame = CGRect(origin: colorPickerView.getPointForColor(color: textView.textColor ?? UIColor.white), size: colorPickerCursorViewSize)
        */
    }

    @objc private func sliderChanged() {
        colorPickerView.Brightness = CGFloat(mySlider.value)
    }

     @objc private func doneButtonTapped() {
        self.isHidden = true
        noteView.isHidden = false
        textView.textColor = colorPickerView.ColorChoosen
    }

    private func setupViews() {
        addSubview(colorChoosenView)
        colorChoosenView.backgroundColor = UIColor.green
        colorChoosenView.clipsToBounds = true
        colorChoosenView.layer.borderWidth = 1
        colorChoosenView.layer.borderColor = UIColor.black.cgColor
        colorChoosenView.layer.cornerRadius = 8
        colorChoosenView.addSubview(colorChoosenLabel)
        colorChoosenLabel.text = "text"
        colorChoosenLabel.backgroundColor = UIColor.white
        colorChoosenLabel.layer.borderWidth = 1
        colorChoosenLabel.layer.borderColor = UIColor.black.cgColor
        addSubview(brightnessLabel)
        brightnessLabel.text = "Brightness:"
        addSubview(mySlider)
        mySlider.isContinuous = false
        addSubview(colorPickerView)
        colorPickerView.ColorChoosenView = colorChoosenView
        colorPickerView.ColorChoosenLabel = colorChoosenLabel

        mySlider.value = Float(colorPickerView.Brightness)
        addSubview(doneButton)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)

        colorChoosenView.translatesAutoresizingMaskIntoConstraints = true
        colorChoosenLabel.translatesAutoresizingMaskIntoConstraints = true
        brightnessLabel.translatesAutoresizingMaskIntoConstraints = true
        mySlider.translatesAutoresizingMaskIntoConstraints = true
        colorPickerView.translatesAutoresizingMaskIntoConstraints = true
        doneButton.translatesAutoresizingMaskIntoConstraints = true

        mySlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
}
