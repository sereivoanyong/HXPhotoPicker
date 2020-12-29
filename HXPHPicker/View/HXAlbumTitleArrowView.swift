//
//  HXAlbumTitleArrowView.swift
//  HXPHPickerExample
//
//  Created by Slience on 2020/12/29.
//  Copyright © 2020 Silence. All rights reserved.
//

import UIKit

class HXAlbumTitleArrowView: UIView {
    var config: HXAlbumTitleViewConfiguration
    lazy var backgroundLayer: CAShapeLayer = {
        let backgroundLayer = CAShapeLayer.init()
        backgroundLayer.contentsScale = UIScreen.main.scale
        return backgroundLayer
    }()
    lazy var arrowLayer: CAShapeLayer = {
        let arrowLayer = CAShapeLayer.init()
        arrowLayer.contentsScale = UIScreen.main.scale
        return arrowLayer
    }()
    init(frame: CGRect, config: HXAlbumTitleViewConfiguration) {
        self.config = config
        super.init(frame: frame)
        drawContent()
        configColor()
    }
    
    func drawContent() {
        let circlePath = UIBezierPath.init(arcCenter: CGPoint.init(x: hx_width * 0.5, y: hx_height * 0.5), radius: hx_width * 0.5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        backgroundLayer.path = circlePath.cgPath
        layer.addSublayer(backgroundLayer)
        
        let arrowPath = UIBezierPath.init()
        arrowPath.move(to: CGPoint(x: 5, y: 8))
        arrowPath.addLine(to: CGPoint(x: hx_width / 2, y: hx_height - 7))
        arrowPath.addLine(to: CGPoint(x: hx_width - 5, y: 8))
        arrowLayer.path = arrowPath.cgPath
        arrowLayer.lineWidth = 1.5
        arrowLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(arrowLayer)
    }
    
    func configColor() {
        backgroundLayer.fillColor = HXPHManager.shared.isDark ? config.arrowBackgroudDarkColor.cgColor : config.arrowBackgroundColor.cgColor
        arrowLayer.strokeColor = HXPHManager.shared.isDark ? config.arrowDarkColor.cgColor : config.arrowColor.cgColor
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                configColor()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
