//
//  Ex+NSColor.swift
//  JSON
//
//  Created by RayJiang on 2019/8/30.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import Cocoa

extension NSColor {
    static func color(r: CGFloat, g: CGFloat, b: CGFloat ,a: CGFloat = 1.0) -> NSColor {
        return NSColor(calibratedRed: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}

extension NSColor {
    
    static var normal: NSColor {
        return NSColor(named: "normal")!
    }
    
    static var bg: NSColor {
        return NSColor(named: "bg")!
    }
    
    static var keyword: NSColor {
        return NSColor(named: "keyword")!
    }
    
    static var remark: NSColor {
        return NSColor(named: "remark")!
    }
    
    static var string: NSColor {
        return NSColor(named: "string")!
    }
    
    static var classColor: NSColor {
        return NSColor(named: "class")!
    }
    
}
