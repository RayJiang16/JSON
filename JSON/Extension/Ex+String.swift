//
//  Ex+String.swift
//  JSON
//
//  Created by RayJiang on 2019/3/14.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import Foundation

extension String {
    
    var uppercasOne: String {
        let str = (self as NSString)
        return str.substring(to: 1).uppercased() + str.substring(from: 1)
    }
    
    var lowercasOne: String {
        let str = (self as NSString)
        return str.substring(to: 1).lowercased() + str.substring(from: 1)
    }
    
    var uppercasUnderline: String {
        let list = self.components(separatedBy: "_")
        if list.count <= 1 { return self }
        var str = ""
        for (idx, s) in list.enumerated() {
            if idx == 0 {
                str = s.lowercased()
            } else {
                str = str + s.uppercasOne
            }
        }
        return str
    }
    
    
}
