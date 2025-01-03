//
//  SwiftPickerConfiguration.swift
//  HXPhotoPickerExample
//
//  Created by Silence on 2023/6/14.
//  Copyright © 2023 洪欣. All rights reserved.
//

import UIKit
import HXPhotoPicker

/// 根据需求自己添加要修改的属性
class SwiftPickerConfiguration: NSObject {
   
   @objc
   var isAutoBack: Bool = true
   
   @objc
   var selectOptions: SelectOptions = .any
   
   @objc
   var selectMode: SelectMode = .multiple
   
   @objc
   var allowSelectedTogether: Bool = true
   
   @objc
   var allowSyncICloudWhenSelectPhoto: Bool = true
   
   @objc
   enum SelectOptions: Int {
       case photo
       case photo_gif
       case photo_hdr
       case photo_live
       case photo_gif_hdr_live
       case video
       case any
       
       var toSwift: PickerAssetOptions {
           switch self {
           case .photo:
               return .photo
           case .photo_gif:
               return .gifPhoto
           case .photo_hdr:
               return .hdrPhoto
           case .photo_live:
               return .livePhoto
           case .photo_gif_hdr_live:
               return [.photo, .gifPhoto, .hdrPhoto, .livePhoto]
           case .video:
               return [.video]
           case .any:
               return [.photo, .gifPhoto, .hdrPhoto, .livePhoto, .video]
           }
       }
   }
   
   @objc
   enum SelectMode: Int {
       case single
       case multiple
       
       var toSwift: PickerSelectMode {
           switch self {
           case .single:
               return .single
           case .multiple:
               return .multiple
           }
       }
   }
    
    var toHX: PickerConfiguration {
        var config = PickerConfiguration()
        config.isAutoBack = isAutoBack
        config.selectOptions = selectOptions.toSwift
        config.selectMode = selectMode.toSwift
        config.allowSelectedTogether = allowSelectedTogether
        config.allowSyncICloudWhenSelectPhoto = allowSyncICloudWhenSelectPhoto
        return config
    }
}
