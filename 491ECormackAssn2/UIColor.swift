//
//  UIColor.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/26/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

extension UIColor {
    static func fromHex(string: String) -> UIColor? {
        var tmp = string.replacingOccurrences(of: "#", with: "")
        tmp = tmp.replacingOccurrences(of: "0x", with: "")
        tmp = tmp.replacingOccurrences(of: "x", with: "")
        
        do {
            let reg = try NSRegularExpression(pattern: "^[0-9a-fA-F]{6}$", options: [])
            let matches = reg.matches(in: tmp, options: [], range: NSRange(location: 0, length: tmp.characters.count))
            guard matches.count == 1 else { return nil }
        } catch let error {
            print(error)
            return nil
        }
        
        var rgb: UInt64 = 0
        Scanner(string: tmp).scanHexInt64(&rgb)
        
        let r = rgb >> 16
        let g = (rgb >> 8) & 0xff
        let b = rgb & 0xff
        
        let red = CGFloat(r) / CGFloat(0xff)
        let green = CGFloat(g) / CGFloat(0xff)
        let blue = CGFloat(b) / CGFloat(0xff)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
