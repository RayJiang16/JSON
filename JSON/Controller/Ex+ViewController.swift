//
//  Ex+ViewController.swift
//  JSON
//
//  Created by RayJiang on 2019/8/30.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import Cocoa

/// 改颜色
extension ViewController {
    
    internal func setupColor() {
        guard let contentTv = contentTV.contentView.documentView as? NSTextView else { return }
        contentTv.setTextColor(NSColor.labelColor, range: NSRange(location: 0, length: contentTv.string.count))
        
        let keywordColor = NSColor.keyword
        changeColor(string: "struct", color: keywordColor)
        changeColor(string: "init", color: keywordColor)
        changeColor(string: "guard", color: keywordColor)
        changeColor(string: "else", color: keywordColor)
        changeColor(string: "return", color: keywordColor)
        changeColor(string: "nil", color: keywordColor)
        changeColor(string: "extension", color: keywordColor)
        changeColor(pattern: "(let ).*?", color: keywordColor, offset: 0, length: 3)
        changeColor(pattern: "(var ).*?", color: keywordColor, offset: 0, length: 3)
        changeColor(pattern: "(self.).*?", color: keywordColor, offset: 0, length: 4)
        
        // 正则匹配
        let classArray = ["Bool", "Int", "Double", "String", "Any"]
        for name in classArray {
            let color = name == "Any" ? keywordColor : NSColor.classColor
            changeColor(pattern: "(: \(name)).*?", color: color, offset: 2, length: name.count)
            changeColor(pattern: "(: \\[\(name)\\]).*?", color: color, offset: 3, length: name.count)
            changeColor(pattern: "\\[\(name):", color: color, offset: 1, length: name.count)
            changeColor(pattern: ":\(name)\\]", color: color, offset: 1, length: name.count)
        }
        for name in modelNameList {
            changeColor(pattern: "(: \(name)).*?", color: NSColor.classColor, offset: 2, length: name.count)
            changeColor(pattern: "(: \\[\(name)\\]).*?", color: NSColor.classColor, offset: 3, length: name.count)
        }
        
        // 匹配字符串
        changeColor(pattern: "([\"]).*?([\"])", color: NSColor.string)
        // 匹配备注
        changeColor(pattern: "(//).*?(\n)", color: NSColor.remark)
    }
    
    /// 改文本颜色
    private func changeColor(string: String, color: NSColor) {
        guard let contentTv = contentTV.contentView.documentView as? NSTextView else { return }
        let str = contentTv.string as NSString
        var begin = 0
        while begin != NSNotFound {
            let range = str.range(of: string, options: .literal, range: NSRange(location: begin, length: str.length-begin-1), locale: nil)
            begin = range.location+range.length
            contentTv.setTextColor(color, range: range)
        }
    }
    
    /// 正则改颜色
    private func changeColor(pattern: String, color: NSColor, offset: Int = 0, length: Int = 0) {
        guard let contentTv = contentTV.contentView.documentView as? NSTextView else { return }
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        if let results = regex?.matches(in: contentTv.string, options: [], range: NSRange(location: 0, length: contentTv.string.count)), results.count != 0 {
            for result in results{
                var range = result.range
                if offset != 0 || length != 0 {
                    range.location += offset
                    range.length = length
                }
                contentTv.setTextColor(color, range: range)
            }
        }
    }
}
