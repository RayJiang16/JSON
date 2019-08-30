//
//  Model.swift
//  JSON
//
//  Created by RayJiang on 2019/3/14.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ValueType {
    case bool
    case int
    case double
    case string
    case array
    case dictionary
    
    var name: String {
        switch self {
        case .bool:
            return "bool"
        case .int:
            return "int"
        case .double:
            return "double"
        case .string:
            return "string"
        case .array, .dictionary:
            return ""
        }
    }
}

struct JsonModel {
    
    var key: String
    var value: JSON
    
    var valueType: ValueType
    var valueName: String = ""
    
    var keyName: String {
        if Manager.shared.useCamelCase {
            return key.uppercasUnderline.lowercasOne
        }
        return key
    }
    var className: String {
        // TODO: 防止类名重复
        return key.uppercasUnderline.uppercasOne
    }
    var isClassType: Bool {
        return valueType == .array || valueType == .dictionary
    }
}

extension JsonModel {
    
    /// JSON 初始化方法，value 为 null 则初始化失败
    init?(key: String, value: JSON) {
        if value.type == .null || value.type == .unknown { return nil }
        self.key = key
        self.value = value

        if value.type == .bool {
            self.valueType = .bool
            self.valueName = "Bool"
        } else if value.rawValue is Int {
            self.valueType = .int
            self.valueName = "Int"
        } else if value.rawValue is Double {
            self.valueType = .double
            self.valueName = "Double"
        } else if value.type == .string {
            self.valueType = .string
            self.valueName = "String"
        } else if value.type == .array { // 把数组中创建成一个对象
            self.valueType = .array
            self.valueName = "[\(className)]"
        } else if value.type == .dictionary { // 把字典创建成一个对象
            self.valueType = .dictionary
            self.valueName = "\(className)"
        } else {
            return nil
        }
    }
    
}

extension JsonModel {
    
    /// ValueStr 初始化方法
    init(key: String, value: String) {
        self.key = key
        self.value = JSON(parseJSON: "")
        
        if let _ = Int(value) {
            self.valueType = .int
            self.valueName = "Int"
        } else if let _ = Double(value) {
            self.valueType = .double
            self.valueName = "Double"
        } else {
            self.valueType = .string
            self.valueName = "String"
        }
    }
    
    /// ValueName 初始化方法
    init(key: String, valueName: String) {
        self.key = key
        self.valueName = valueName
        self.valueType = .bool
        self.value = JSON(parseJSON: "")
    }
}
