//
//  Manager.swift
//  JSON
//
//  Created by RayJiang on 2019/8/26.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import Cocoa

class Manager {
    
    static let shared = Manager()
    private init() { }
    
    public var useCamelCase = true
    public var autoSort = true
    public var useGuard = true
    
}
