//
//  Print.swift
//  JSON
//
//  Created by RayJiang on 2019/8/30.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import Cocoa

let space1x = "    "
let space2x = "        "
let space3x = "            "

/// 根据变量列表输出类
func printClass(name: String, list: [JsonModel]) -> String {
    let sortList = sortModelList(list)
    var content = ("struct " + name + " {\n\n")
    content += printProperty(space: space1x, list: sortList)
    content += "\n"
    content += printInit(space: space1x, list: sortList)
    content += "}\n\n"
    return content
}

/// 输出变量列表
func printProperty(space: String, list: [JsonModel]) -> String {
    var content = ""
    for model in list {
        content += (space + "let " + model.keyName + ": " + model.valueName + "\n")
    }
    return content
}

/// 输出 Init 方法
func printInit(space: String, list: [JsonModel]) -> String {
    var content = (space + "init(")
    for (idx, model) in list.enumerated() {
        if idx == 0 {
            content += (model.keyName + ": " + model.valueName)
        } else {
            content += (space + space1x + " " + model.keyName + ": " + model.valueName)
        }
        if idx < list.count-1 {
            content += ",\n"
        }
    }
    content += ") {\n"
    
    for model in list {
        content += (space + space1x + "self." + model.keyName + " = " + model.keyName + "\n")
    }
    content += (space + "}\n")
    return content
}

/// Call Init
func printCallInit(space: String, list: [JsonModel]) -> String {
    var content = ""
    content += (space + "self.init(")
    for (idx, model) in list.enumerated() {
        if idx == 0 {
            content += (model.keyName + ": " + model.keyName)
        } else {
            content += (space + space2x + "  " + model.keyName + ": " + model.keyName)
        }
        if idx < list.count-1 {
            content += ",\n"
        }
    }
    content += ")\n"
    return content
}

/// mark: - JSON
/// 根据变量列表输出 JSON 初始化方法
func printJsonExtension(name: String, list: [JsonModel]) -> String {
    let sortList = sortModelList(list)
    var content = ("extension " + name + " {\n\n")
    content += (space1x + "init?(json: JSON) {\n")
    content += printJsonBaseProperty(list: sortList)
    content += printJsonOtherProperty(list: sortList)
    content += printCallInit(space: space2x, list: sortList)
    content += (space1x + "}\n")
    content += "}\n\n"
    return content
}

/// 输出基本数据类型
func printJsonBaseProperty(list: [JsonModel]) -> String {
    let normalList = list.filter{ !$0.isClassType }
    if normalList.isEmpty { return "" }
    
    var content = ""
    if Manager.shared.useGuard {
        content = (space2x + "guard\n")
    }
    for (idx, model) in normalList.enumerated() {
        if Manager.shared.useGuard {
            content += (space3x + "let " + model.keyName + " = json[\"" + model.key + "\"]." + model.valueType.name)
        } else {
            content += (space2x + "let " + model.keyName + " = json[\"" + model.key + "\"]." + model.valueType.name + "Value")
        }
        if idx < normalList.count-1 && Manager.shared.useGuard {
            content += ","
        }
        content += "\n"
    }
    if Manager.shared.useGuard {
        content += (space3x + "else { return nil }\n")
    }
    return content
}

/// 输出其他数据类型
func printJsonOtherProperty(list: [JsonModel]) -> String {
    var content = ""
    for model in list {
        if model.valueType == .array {
            content += (space2x + "let " + model.keyName + " = json[\"" + model.key + "\"].arrayValue.compactMap{ " + model.className + "(json: $0) }\n")
        } else if model.valueType == .dictionary {
            content += (space2x + "let " + model.keyName + " = " + model.className + "(json: json[\"" + model.key + "\"])\n")
        }
    }
    return content
}

/// mark: - Other
func printParameters(list: [JsonModel]) -> String {
    var content = "var parameters: [String:Any] {\n"
    content += (space1x + "var parameters = [String:Any]()\n")
    for model in list {
        content += (space1x + "parameters[\"" + model.key + "\"] = " + model.keyName + "\n")
    }
    content += (space1x + "return parameters\n")
    content += "}\n"
    return content
}


////////////////////////////////////////////////////////

func sortModelList(_ list: [JsonModel]) -> [JsonModel] {
    if !Manager.shared.autoSort { return list }
    let arr1 = list.filter{ !$0.isClassType }.sorted(by: { m1, m2 in
        return m1.keyName.count < m2.keyName.count
    })
    let arr2 = list.filter{ $0.valueType == .array }.sorted(by: { m1, m2 in
        return m1.keyName.count < m2.keyName.count
    })
    let arr3 = list.filter{ $0.valueType == .dictionary }.sorted(by: { m1, m2 in
        return m1.keyName.count < m2.keyName.count
    })
    return arr1 + arr2 + arr3
}
