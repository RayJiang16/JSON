//
//  ViewController.swift
//  JSON
//
//  Created by RayJiang on 2019/3/14.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import Cocoa

/// 类名:[变量列表]
var modelList: [String:[JsonModel]] = [:]
/// 类 列表
var modelNameList: [String] = []

final class ViewController: NSViewController {
    
    @IBOutlet weak var jsonTV: NSScrollView!
    @IBOutlet weak var contentTV: NSScrollView!
    
    @IBOutlet weak var modeButton: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.setContentSize(NSSize(width: 1200, height: 800))
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    private func setupView() {
        guard let jsonTv = jsonTV.contentView.documentView as? NSTextView else { return }
        guard let contentTv = contentTV.contentView.documentView as? NSTextView else { return }
        for tv in [jsonTv, contentTv] {
            tv.isRichText = false
            tv.textColor = NSColor.labelColor
            tv.backgroundColor = NSColor.bg
        }
        jsonTv.font = NSFont(name: "Menlo-Regular", size: 13)
        contentTv.font = NSFont(name: "Menlo-Regular", size: 18)
    }
    
    @IBAction func modeButtonValueChange(_ sender: NSPopUpButton) {
        guard let contentTv = contentTV.contentView.documentView as? NSTextView else { return }
        contentTv.string = ""
    }
    
    @IBAction func didClickRunButton(_ sender: NSButton) {
        guard let jsonTv = jsonTV.contentView.documentView as? NSTextView else { return }
        guard let contentTv = contentTV.contentView.documentView as? NSTextView else { return }
        jsonTv.string = jsonTv.string.replacingOccurrences(of: "“", with: "\"")
        jsonTv.string = jsonTv.string.replacingOccurrences(of: "”", with: "\"")
        jsonTv.string = jsonTv.string.replacingOccurrences(of: " ", with: "")
        
        modelList = [:]
        modelNameList = []
        switch modeButton.selectedItem?.tag ?? 0 {
        case 0:
            output1()
        case 1:
            output2()
        case 2:
            output3()
        default:
            break
        }
        
        if !contentTv.string.isEmpty {
            setupColor()
        }
    }
    
    @IBAction func didClickCamelCaseButton(_ sender: NSButton) {
        sender.title = sender.state == .on ? "开启" : "关闭"
        Manager.shared.useCamelCase = sender.state == .on
    }
    
    @IBAction func didClickAutoSortButton(_ sender: NSButton) {
        sender.title = sender.state == .on ? "开启" : "关闭"
        Manager.shared.autoSort = sender.state == .on
    }
    
    @IBAction func didClickGuard(_ sender: NSButton) {
        sender.title = sender.state == .on ? "开启" : "关闭"
        Manager.shared.useGuard = sender.state == .on
    }
    
}

/// 输出
extension ViewController {
    
    /// JSON 转 Model
    private func output1() {
        guard let jsonTv = jsonTV.contentView.documentView as? NSTextView else { return }
        guard let contentTv = contentTV.contentView.documentView as? NSTextView else { return }
        guard let jsonData = jsonTv.string.data(using: .utf8) else { return }
        guard let dict = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)) as? [String:Any] else { return }
        dealDictionary(dict, className: "Root")
        
        if modelList.isEmpty {
            contentTv.string = "The data couldn’t be read because it isn’t in the correct format."
            return
        }
        
        var content = "import SwiftyJSON\n\n"
        for className in modelNameList { // 类
            let list = modelList[className] ?? []
            content += printClass(name: className, list: list)
        }
        content += "/// Deal JSON\n"
        for className in modelNameList { // Extension
            let list = modelList[className] ?? []
            content += printJsonExtension(name: className, list: list)
        }
        contentTv.string = content
    }
    
    /// 生成 Init
    private func output2() {
        guard let jsonTv = jsonTV.contentView.documentView as? NSTextView else { return }
        guard let contentTv = contentTV.contentView.documentView as? NSTextView else { return }
        let json = "\(jsonTv.string)\n"
        let regex = try? NSRegularExpression(pattern: "(let|var).*?(\n)", options: [])
        guard let results = regex?.matches(in: json, options: [], range: NSRange(location: 0, length: json.count)), results.count != 0 else {
            contentTv.string = "The data couldn’t be read because it isn’t in the correct format."
            return
        }
        let lines = results.map{ (jsonTv.string as NSString).substring(with: NSRange(location: $0.range.location, length: $0.range.length-1)) }
        dealInitLines(lines)
        
        var content = "\n"
        let list = modelList["Root"] ?? []
        let sortList = sortModelList(list)
        content += printInit(space: "", list: sortList)
        content += "\n\n"
        content += "/// Call\n"
        content += printCallInit(space: "", list: sortList)
        
        contentTv.string = content
    }
    
    /// request to model
    private func output3() {
        guard let jsonTv = jsonTV.contentView.documentView as? NSTextView else { return }
        guard let contentTv = contentTV.contentView.documentView as? NSTextView else { return }
        guard let jsonData = jsonTv.string.data(using: .utf8) else { return }
        
        let list: [JsonModel]
        if let dict = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)) as? [String:Any] {
            dealDictionary(dict, className: "Root")
            list = modelList["Root"] ?? []
        } else {
            let urlStr = jsonTv.string.hasPrefix("http") ? jsonTv.string : "http://www.placehold.com?\(jsonTv.string)"
            if let url = URL(string: urlStr), let query = url.query {
                dealQuery(query)
                list = modelList["Root"] ?? []
            } else {
                contentTv.string = "The data couldn’t be read because it isn’t in the correct format."
                return
            }
        }
        
        var content = ""
        let sortList = sortModelList(list)
        content += printClass(name: "Root", list: list)
        content += "\n"
        content += "/// Parameters\n"
        content += printParameters(list: sortList)
        
        contentTv.string = content
    }
        
}

/// Private
extension ViewController {
    
    private func dealDictionary(_ dict: [String:Any], className: String) {
        modelNameList.append(className)
        for (key, value) in dict {
            if let model = JsonModel(key: key, value: value) {
                if modelList[className] == nil {
                    modelList[className] = [model]
                } else {
                    modelList[className]?.append(model)
                }
                
                if model.valueType == .array {
                    if let firstObj = (model.value as? [[String:Any]])?.first {
                        dealDictionary(firstObj, className: model.className)
                    }
                } else if model.valueType == .dictionary {
                    if let subDict = model.value as? [String:Any] {
                        dealDictionary(subDict, className: model.className)
                    }
                }
            }
        }
    }
    
    private func dealInitLines(_ lines: [String]) {
        let className = "Root"
        modelNameList.append(className)
        for line in lines {
            var newLine = line.replacingOccurrences(of: " :", with: ":")
            newLine = newLine.replacingOccurrences(of: "//", with: " //")
            var list = newLine.split(separator: " ").map{ String($0) }
            guard list.count >= 3 else { return }
            list[1] = list[1].replacingOccurrences(of: ":", with: "")
            let model = JsonModel(key: list[1], valueName: list[2])
            if modelList[className] == nil {
                modelList[className] = [model]
            } else {
                modelList[className]?.append(model)
            }
        }
    }
    
    private func dealQuery(_ query: String) {
        let className = "Root"
        modelNameList.append(className)
        let list = query.components(separatedBy: "&")
        for param in list {
            let keyValue = param.components(separatedBy: "=")
            if keyValue.count == 2 {
                let model = JsonModel(key: keyValue[0], value: keyValue[1])
                if modelList[className] == nil {
                    modelList[className] = [model]
                } else {
                    modelList[className]?.append(model)
                }
            }
        }
    }
}
