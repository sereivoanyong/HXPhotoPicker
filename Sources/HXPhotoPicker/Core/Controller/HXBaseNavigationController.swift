//
//  HXBaseNavigationController.swift
//  HXPhotoPicker
//
//  Created by Sereivoan Yong on 11/20/24.
//

import UIKit

open class HXBaseNavigationController: UINavigationController {

    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        commonInit()
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        commonInit()
    }

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
}
