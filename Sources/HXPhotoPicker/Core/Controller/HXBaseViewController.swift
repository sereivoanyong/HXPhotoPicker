//
//  HXBaseViewController.swift
//  HXPhotoPicker
//
//  Created by Slience on 2021/1/9.
//

import UIKit

open class HXBaseViewController: UIViewController {

    public override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        overrideUserInterfaceStyle = .dark
    }
    
    @objc
    open func deviceOrientationDidChanged(notify: Notification) {
        
    }
    
    @objc
    open func deviceOrientationWillChanged(notify: Notification) {
        
    }
    
    open override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        deviceOrientationWillChanged(notify: .init(name: UIApplication.willChangeStatusBarOrientationNotification))
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            self?.deviceOrientationDidChanged(
                notify: .init(
                    name: UIApplication.didChangeStatusBarOrientationNotification
                )
            )
        }
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        PhotoTools.removeCache()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
