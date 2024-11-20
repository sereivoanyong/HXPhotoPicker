//
//  Core+UIFont.swift
//  HXPhotoPicker
//
//  Created by Silence on 2020/11/13.
//  Copyright © 2020 Silence. All rights reserved.
//

import UIKit

extension UIFont: HXPickerCompatibleValue {
    
    static var textManager: HX.TextManager {
        HX.TextManager.shared
    }
    
    #if HXPICKER_ENABLE_PICKER || HXPICKER_ENABLE_CAMERA
    static var textNotAuthorized: HX.TextManager.Picker.NotAuthorized {
        textManager.picker.notAuthorized
    }
    #endif
    
    #if HXPICKER_ENABLE_PICKER
    static var textPhotoList: HX.TextManager.Picker.PhotoList {
        textManager.picker.photoList
    }
    
    static var textPreview: HX.TextManager.Picker.Preview {
        textManager.picker.preview
    }
    #endif
}
