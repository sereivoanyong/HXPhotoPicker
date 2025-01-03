//
//  PhotoSplitViewController.swift
//  HXPhotoPicker
//
//  Created by Silence on 2023/10/1.
//  Copyright © 2023 Silence. All rights reserved.
//

import UIKit

open class PhotoSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    open override var modalPresentationStyle: UIModalPresentationStyle {
        didSet {
            for viewController in viewControllers {
                viewController.modalPresentationStyle = modalPresentationStyle
            }
        }
    }
    
    public var isSplitShowColumn: Bool = false
    
    var assetCollections: [PhotoAssetCollection] = []
    var cameraAssetCollection: PhotoAssetCollection?
    let photoController: PhotoPickerController
    
    public init(
        picker: PhotoPickerController
    ) {
        photoController = picker
        super.init(style: .doubleColumn)
        if !UIDevice.isPad, picker.config.modalPresentationStyle == .fullScreen {
            preferredSplitBehavior = .tile
            displayModeButtonVisibility = .never
            if !UIDevice.isPortrait {
                preferredDisplayMode = .oneBesideSecondary
            }
        }
        let album = PhotoPickerController(splitAlbum: picker.config)
        modalPresentationStyle = picker.config.modalPresentationStyle
        viewControllers = [album, picker]
        delegate = self
        album.albumViewController?.initItems()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if !UIDevice.isPad, !UIDevice.isPortrait, !isCollapsed, modalPresentationStyle == .fullScreen {
            switch displayMode {
            case .oneBesideSecondary:
                if  supportedInterfaceOrientations == .portrait ||
                    supportedInterfaceOrientations == .portraitUpsideDown {
                    isSplitShowColumn = false
                }else {
                    isSplitShowColumn = true
                }
            default:
                isSplitShowColumn = false
            }
        }else {
            isSplitShowColumn = false
        }
        configColor()
    }
    
    open override var shouldAutorotate: Bool {
        photoController.shouldAutorotate
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        photoController.supportedInterfaceOrientations
    }
    
    private func configColor() {
        guard let picker = viewControllers.first as? PhotoPickerController else {
            return
        }
        if let separatorLineColor = picker.config.splitSeparatorLineColor, !PhotoManager.isDark {
            view.backgroundColor = separatorLineColor
            return
        }else if let splitSeparatorLineDarkColor = picker.config.splitSeparatorLineDarkColor, PhotoManager.isDark {
            view.backgroundColor = splitSeparatorLineDarkColor
            return
        }else {
            if traitCollection.userInterfaceStyle != .dark, PhotoManager.isDark {
                view.backgroundColor = .systemGroupedBackground.resolvedColor(with: .init(userInterfaceStyle: .dark))
                return
            }
        }
        view.backgroundColor = .systemBackground
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configColor()
        }
    }
    
    open override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        if !UIDevice.isPad, !UIDevice.isPortrait,
           !isCollapsed,
           modalPresentationStyle == .fullScreen,
           displayMode == .oneBesideSecondary {
            isSplitShowColumn = true
        }else {
            isSplitShowColumn = false
        }
        coordinator.animate(alongsideTransition: nil)
    }

    public func splitViewController(_ svc: UISplitViewController, displayModeForExpandingToProposedDisplayMode proposedDisplayMode: UISplitViewController.DisplayMode) -> UISplitViewController.DisplayMode {
        if !UIDevice.isPad, modalPresentationStyle == .fullScreen {
            return .oneBesideSecondary
        }
        return .automatic
    }

    public func splitViewController(_ svc: UISplitViewController, willShow column: UISplitViewController.Column) {
        if UIDevice.isPad, displayMode == .secondaryOnly {
            if let preview = photoController.topViewController as? PhotoPreviewViewController {
                preview.startRequestPreviewTimer()
            }
        }
        if #unavailable(iOS 14.5), displayMode == .secondaryOnly {
            isSplitShowColumn = true
        }
    }

    public func splitViewController(_ svc: UISplitViewController, willHide column: UISplitViewController.Column) {
        if UIDevice.isPad, displayMode == .oneBesideSecondary {
            if let preview = photoController.topViewController as? PhotoPreviewViewController {
                preview.startRequestPreviewTimer()
            }
        }
        if #unavailable(iOS 14.5) {
            isSplitShowColumn = false
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        HXLog("PhotoSplitViewController deinited 👍")
    }
    
}
