//
//  Extensions.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 1. 6..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

extension String {
    func isMatch(regex: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: regex, options: [])
        return regex?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: utf16.count)) != nil
    }
}

extension UITextField {
    var isEmpty: Bool {
        return text == nil || text!.isEmpty
    }
}

extension UIAlertController {
    static func alert( target: UIViewController, msg: String, actionClosure: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController.init(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "확인", style: .cancel, handler: actionClosure))
        target.present(alert, animated: true, completion: nil)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: [" "]))
        
        if( hex.hasPrefix("#") ) {
            scanner.scanLocation = 1
        }
        
        var argbValue: UInt64 = 0
        
        scanner.scanHexInt64(&argbValue)
        
        let hexCount = scanner.string.count - scanner.scanLocation
        
        let a = (hexCount > 2 * 3) ? ((argbValue >> 8 * 3) & 0xff) : 0xff
        let r = (hexCount > 2 * 2) ? ((argbValue >> 8 * 2) & 0xff) : 0x00
        let g = (hexCount > 2 * 1) ? ((argbValue >> 8 * 1) & 0xff) : 0x00
        let b = argbValue & 0xff
        
        self.init(
            red:    CGFloat(r) / 0xff,
            green:  CGFloat(g) / 0xff,
            blue:   CGFloat(b) / 0xff,
            alpha:  CGFloat(a) / 0xff
        )
    }
}

extension Dictionary where Key == String, Value == Any {
    init(optionalItems: Dictionary<Key,Any?>) {
        self.init()
        for (key, value) in optionalItems where value != nil{
            self[key] = value!
        }
    }
}
