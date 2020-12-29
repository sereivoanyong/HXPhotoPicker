//
//  UIView+HXPHPicker.swift
//  HXPhotoPickerSwift
//
//  Created by Silence on 2020/11/12.
//  Copyright © 2020 Silence. All rights reserved.
//

import UIKit

public extension UIView {
    var hx_x : CGFloat {
        get {
            return frame.origin.x
        }
        set {
            var rect = frame
            rect.origin.x = newValue
            frame = rect
        }
    }
    var hx_y : CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var rect = frame
            rect.origin.y = newValue
            frame = rect
        }
    }
    var hx_width : CGFloat {
        get {
            return frame.size.width
        }
        set {
            var rect = frame
            rect.size.width = newValue
            frame = rect
        }
    }
    var hx_height : CGFloat {
        get {
            return frame.size.height
        }
        set {
            var rect = frame
            rect.size.height = newValue
            frame = rect
        }
    }
    var hx_size : CGSize {
        get {
            return frame.size
        }
        set {
            var rect = frame
            rect.size = newValue
            frame = rect
        }
    }
    var hx_centerX : CGFloat {
        get {
            return center.x
        }
        set {
            var point = center
            point.x = newValue
            center = point
        }
    }
    var hx_centerY : CGFloat {
        get {
            return center.y
        }
        set {
            var point = center
            point.y = newValue
            center = point
        }
    }
    
    func hx_viewController() -> UIViewController? {
        var next = superview
        while (next != nil) {
            let nextResponder = next?.next
            if nextResponder is UINavigationController ||
                nextResponder is UIViewController {
                return nextResponder as? UIViewController
            }
            next = next?.superview
        }
        return nil
    }
}

public enum HXPHProgressHUDMode : Int {
    case indicator
    case image
    case success
}

public class HXPHProgressHUD: UIView {
    var mode : HXPHProgressHUDMode!
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView.init()
        backgroundView.layer.cornerRadius = 5
        backgroundView.layer.masksToBounds = true
        backgroundView.alpha = 0
        backgroundView.addSubview(blurEffectView)
        return backgroundView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView.init()
        return contentView
    }()
    
    lazy var blurEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect.init(style: .dark)
        let blurEffectView = UIVisualEffectView.init(effect: effect)
        return blurEffectView
    }()
    
    lazy var indicatorView : UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    lazy var textLb: UILabel = {
        let textLb = UILabel.init()
        textLb.textColor = .white
        textLb.textAlignment = .center
        textLb.font = UIFont.systemFont(ofSize: 16)
        textLb.numberOfLines = 0;
        return textLb
    }()
    
    lazy var imageView: HXPHProgressImageView = {
        let imageView = HXPHProgressImageView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        return imageView
    }()
    
    lazy var tickView: HXPHProgressImageView = {
        let tickView = HXPHProgressImageView.init(tickFrame: CGRect(x: 0, y: 0, width: 80, height: 80))
        return tickView
    }()
    
    var text : String?
    var finished : Bool = false
    var showDelayTimer : Timer?
    var hideDelayTimer : Timer?
    
    init(addedTo view: UIView, mode: HXPHProgressHUDMode) {
        super.init(frame: view.bounds)
        self.mode = mode
        initView()
    }
    func initView() {
        addSubview(backgroundView)
        contentView.addSubview(textLb)
        if mode == HXPHProgressHUDMode.indicator {
            contentView.addSubview(indicatorView)
        }else if mode == HXPHProgressHUDMode.image {
            contentView.addSubview(imageView)
        }else if mode == HXPHProgressHUDMode.success {
            contentView.addSubview(tickView)
        }
        backgroundView.addSubview(contentView)
        
    }
    
    private func showHUD(text: String?, animated: Bool, afterDelay: TimeInterval) {
        self.text = text
        textLb.text = text
        updateFrame()
        if afterDelay > 0 {
            let timer = Timer.init(timeInterval: afterDelay, target: self, selector: #selector(handleShowTimer(timer:)), userInfo: animated, repeats: false)
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
            self.showDelayTimer = timer
        }else {
            showViews(animated: animated)
        }
    }
    @objc func handleShowTimer(timer: Timer) {
        showViews(animated: (timer.userInfo != nil))
    }
    private func showViews(animated: Bool) {
        if finished {
            return
        }
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.backgroundView.alpha = 1
            }
        }else {
            self.backgroundView.alpha = 1
        }
    }
    public func hideHUD(withAnimated animated: Bool, afterDelay: TimeInterval) {
        finished = true
        self.showDelayTimer?.invalidate()
        if afterDelay > 0 {
            let timer = Timer.init(timeInterval: afterDelay, target: self, selector: #selector(handleHideTimer(timer:)), userInfo: animated, repeats: false)
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
            self.hideDelayTimer = timer
        }else {
            hideViews(animated: animated)
        }
    }
    @objc func handleHideTimer(timer: Timer) {
        hideViews(animated: (timer.userInfo != nil))
    }
    public func hideViews(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.backgroundView.alpha = 0
            } completion: { (finished) in
                self.removeFromSuperview()
            }
        }else {
            self.backgroundView.alpha = 0
            removeFromSuperview()
        }
    }
    public func updateText(text: String) {
        self.text = text
        textLb.text = text
        updateFrame()
    }
    private func updateFrame() {
        if text != nil {
            var width = text!.hx_stringWidth(ofFont: textLb.font, maxHeight: 15)
            if width < 60 {
                width = 60
            }
            if width > hx_width - 100 {
                width = hx_width - 100
            }
            let height = text!.hx_stringHeight(ofFont: textLb.font, maxWidth: width)
            textLb.hx_size = CGSize(width: width, height: height)
        }
        var width = textLb.hx_width + 60
        if width < 100 {
            width = 100
        }
        
        let centenrX = width / 2
        textLb.hx_centerX = centenrX
        if mode == HXPHProgressHUDMode.indicator {
            indicatorView.startAnimating()
            indicatorView.hx_centerX = centenrX
            if text != nil {
                textLb.hx_y = indicatorView.frame.maxY + 10
            }else {
                textLb.hx_y = indicatorView.frame.maxY
            }
        }else if mode == HXPHProgressHUDMode.image {
            imageView.hx_centerX = centenrX
            if text != nil {
                textLb.hx_y = imageView.frame.maxY + 15
            }else {
                textLb.hx_y = imageView.frame.maxY
            }
        }else if mode == HXPHProgressHUDMode.success {
            tickView.hx_centerX = centenrX
            textLb.hx_y = tickView.frame.maxY
        }
        
        contentView.hx_height = textLb.frame.maxY
        contentView.hx_width = width
        if contentView.hx_height + 40 < 100 {
            backgroundView.hx_height = 100
        }else {
            backgroundView.hx_height = contentView.hx_height + 40
        }
        if width < backgroundView.hx_height {
            backgroundView.hx_width = backgroundView.hx_height
        }else {
            backgroundView.hx_width = width
        }
        contentView.center = CGPoint(x: backgroundView.hx_width * 0.5, y: backgroundView.hx_height * 0.5)
        backgroundView.center = CGPoint(x: hx_width * 0.5, y: hx_height * 0.5)
        blurEffectView.frame = backgroundView.bounds
    }
    
    public class func showLoadingHUD(addedTo view: UIView?, animated: Bool) -> HXPHProgressHUD? {
        return showLoadingHUD(addedTo: view, text: nil, animated: animated)
    }
    public class func showLoadingHUD(addedTo view: UIView?, afterDelay: TimeInterval, animated: Bool) -> HXPHProgressHUD? {
        return showLoadingHUD(addedTo: view, text: nil, afterDelay: afterDelay, animated: animated)
    }
    
    public class func showLoadingHUD(addedTo view: UIView?, text: String?, animated: Bool) -> HXPHProgressHUD? {
        return showLoadingHUD(addedTo: view, text: text, afterDelay: 0, animated: animated)
    }
    
    public class func showLoadingHUD(addedTo view: UIView?, text: String?, afterDelay: TimeInterval , animated: Bool) -> HXPHProgressHUD? {
        if view == nil {
            return nil
        }
        let progressView = HXPHProgressHUD.init(addedTo: view!, mode: HXPHProgressHUDMode.indicator)
        progressView.showHUD(text: text, animated: animated, afterDelay: afterDelay)
        view!.addSubview(progressView)
        return progressView
    }
    public class func showWarningHUD(addedTo view: UIView?, text: String?, animated: Bool, delay: TimeInterval) {
        self.showWarningHUD(addedTo: view, text: text, afterDelay: 0, animated: animated)
        self.hideHUD(forView: view, animated: animated, afterDelay: delay)
    }
    public class func showWarningHUD(addedTo view: UIView?, text: String?, afterDelay: TimeInterval , animated: Bool) {
        if view == nil {
            return
        }
        let progressView = HXPHProgressHUD.init(addedTo: view!, mode: HXPHProgressHUDMode.image)
        progressView.showHUD(text: text, animated: animated, afterDelay: afterDelay)
        view!.addSubview(progressView)
    }
    public class func showSuccessHUD(addedTo view: UIView?, text: String?, animated: Bool, delay: TimeInterval) {
        self.showSuccessHUD(addedTo: view, text: text, afterDelay: 0, animated: animated)
        self.hideHUD(forView: view, animated: animated, afterDelay: delay)
    }
    public class func showSuccessHUD(addedTo view: UIView?, text: String?, afterDelay: TimeInterval , animated: Bool) {
        if view == nil {
            return
        }
        let progressView = HXPHProgressHUD.init(addedTo: view!, mode: HXPHProgressHUDMode.success)
        progressView.showHUD(text: text, animated: animated, afterDelay: afterDelay)
        view!.addSubview(progressView)
    }
    
    public class func hideHUD(forView view:UIView? ,animated: Bool) {
        hideHUD(forView: view, animated: animated, afterDelay: 0)
    }
    
    public class func hideHUD(forView view:UIView? ,animated: Bool ,afterDelay: TimeInterval) {
        if view == nil {
            return
        }
        for subView in view!.subviews {
            if subView is HXPHProgressHUD {
                (subView as! HXPHProgressHUD).hideHUD(withAnimated: animated, afterDelay: afterDelay)
            }
        }
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !frame.equalTo(superview?.bounds ?? frame) {
            frame = superview?.bounds ?? frame
            updateFrame()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class HXPHProgressImageView: UIView {
    
    lazy var circleLayer: CAShapeLayer = {
        let circleLayer = CAShapeLayer.init()
        circleLayer.contentsScale = UIScreen.main.scale
        return circleLayer
    }()
    
    lazy var lineLayer: CAShapeLayer = {
        let lineLayer = CAShapeLayer.init()
        lineLayer.contentsScale = UIScreen.main.scale
        return lineLayer
    }()
    
    lazy var pointLayer: CAShapeLayer = {
        let pointLayer = CAShapeLayer.init()
        pointLayer.contentsScale = UIScreen.main.scale
        return pointLayer
    }()
    
    lazy var tickLayer: CAShapeLayer = {
        let tickLayer = CAShapeLayer.init()
        tickLayer.contentsScale = UIScreen.main.scale
        return tickLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(circleLayer)
        layer.addSublayer(lineLayer)
        layer.addSublayer(pointLayer)
        drawCircle()
        drawExclamationPoint()
    }
    init(tickFrame: CGRect) {
        super.init(frame: tickFrame)
        layer.addSublayer(tickLayer)
        drawTickLayer()
    }
    func startAnimation() {
    }
    func drawCircle() {
        let circlePath = UIBezierPath.init()
        circlePath.addArc(withCenter: CGPoint(x: hx_width * 0.5, y: hx_height * 0.5), radius: hx_width * 0.5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        circleLayer.path = circlePath.cgPath
        circleLayer.lineWidth = 1.5
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        
//        let circleAimation = CABasicAnimation.init(keyPath: "strokeEnd")
//        circleAimation.fromValue = 0
//        circleAimation.toValue = 1
//        circleAimation.duration = 0.5
//        circleLayer.add(circleAimation, forKey: "")
    }
    
    func drawExclamationPoint() {
        let linePath = UIBezierPath.init()
        linePath.move(to: CGPoint(x: hx_width * 0.5, y: 15))
        linePath.addLine(to: CGPoint(x: hx_width * 0.5, y: hx_height - 22))
        lineLayer.path = linePath.cgPath
        lineLayer.lineWidth = 2
        lineLayer.strokeColor = UIColor.white.cgColor
        lineLayer.fillColor = UIColor.white.cgColor
        
//        let lineAimation = CABasicAnimation.init(keyPath: "strokeEnd")
//        lineAimation.fromValue = 0
//        lineAimation.toValue = 1
//        lineAimation.duration = 0.3
//        lineLayer.add(lineAimation, forKey: "")
        
        let pointPath = UIBezierPath.init()
        pointPath.addArc(withCenter: CGPoint(x: hx_width * 0.5, y: hx_height - 15), radius: 1, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        pointLayer.path = pointPath.cgPath
        pointLayer.lineWidth = 1
        pointLayer.strokeColor = UIColor.white.cgColor
        pointLayer.fillColor = UIColor.white.cgColor
        
//        let pointAimation = CAKeyframeAnimation.init(keyPath: "transform.scale")
//        pointAimation.values = [0, 1.2, 0.8, 1.1, 0.9 , 1]
//        pointAimation.duration = 0.5
//        pointLayer.add(pointAimation, forKey: "")
    }
    func drawTickLayer() {
        let tickPath = UIBezierPath.init()
        tickPath.move(to: CGPoint(x: scale(8), y: hx_height * 0.5 + scale(1)))
        tickPath.addLine(to: CGPoint(x: hx_width * 0.5 - scale(2), y: hx_height - scale(8)))
        tickPath.addLine(to: CGPoint(x: hx_width - scale(7), y: scale(9)))
        tickLayer.path = tickPath.cgPath
        tickLayer.lineWidth = 2
        tickLayer.lineJoin = .round
        tickLayer.strokeColor = UIColor.white.cgColor
        tickLayer.fillColor = UIColor.clear.cgColor
    }
    
    private func scale(_ numerator: CGFloat) -> CGFloat {
        return numerator / 30 * hx_height
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
