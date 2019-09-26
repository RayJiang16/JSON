//
//  JSONUITests.swift
//  JSONUITests
//
//  Created by 蒋惠 on 2019/9/26.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import XCTest

class JSONUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// 测试前请将输入法关闭
    /// 测试 output1 模块 - JSON(Response) to Model
    /// 测试内容：将 JSON 转成 model 代码 + 解析代码
    func testOutput1() {
        let app = XCUIApplication()
        app.launch()
        
        let textView = XCUIApplication().windows["Window"].children(matching: .scrollView).element(boundBy: 0).children(matching: .textView).element
        textView.click()
        textView.typeKey("1", modifierFlags:.command)
        textView.typeText(output1TestString)
        textView.typeKey("r", modifierFlags:.command)
        
        Thread.sleep(forTimeInterval: 99999)
    }
    
    /// 测试前请将输入法关闭
    /// 测试 output2 模块 - 生成 Init
    /// 测试内容：根据 model 的声明代码，生成 init 代码
    func testOutput2() {
        let app = XCUIApplication()
        app.launch()
        
        let textView = XCUIApplication().windows["Window"].children(matching: .scrollView).element(boundBy: 0).children(matching: .textView).element
        textView.click()
        textView.typeKey("2", modifierFlags:.command)
        textView.typeText(output2TestString)
        textView.typeKey("r", modifierFlags:.command)
        
        Thread.sleep(forTimeInterval: 99999)
    }
    
    /// 测试前请将输入法关闭
    /// 测试 output3 模块 - Request to Model
    /// 测试内容：将 query 转成 model + Parameters
    func testOutput3_1() {
        let app = XCUIApplication()
        app.launch()
        
        let textView = XCUIApplication().windows["Window"].children(matching: .scrollView).element(boundBy: 0).children(matching: .textView).element
        textView.click()
        textView.typeKey("3", modifierFlags:.command)
        textView.typeText(output3_1TestString)
        textView.typeKey("r", modifierFlags:.command)
        
        Thread.sleep(forTimeInterval: 99999)
    }
    
    /// 测试前请将输入法关闭
    /// 测试 output3 模块 - Request to Model
    /// 测试内容：将 JSON 转成 model + Parameters
    func testOutput3_2() {
        let app = XCUIApplication()
        app.launch()
        
        let textView = XCUIApplication().windows["Window"].children(matching: .scrollView).element(boundBy: 0).children(matching: .textView).element
        textView.click()
        textView.typeKey("3", modifierFlags:.command)
        textView.typeText(output3_2TestString)
        textView.typeKey("r", modifierFlags:.command)
        
        Thread.sleep(forTimeInterval: 99999)
    }
    
    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

let output1TestString = """
{
    "code":200,
    "msg":"success",
    "data":{
        "user_id":123,
        "user_name":"Tom",
        "is_vip":false,
        "money":"23.33"
    }
}
"""

let output2TestString = """
let isVip: Bool
let money: String
let userId: Int
let userName: String
"""

let output3_1TestString = """
user_id=233&user_city=hangzhou
"""

let output3_2TestString = """
{
    "user_id":233,
    "user_city":"hangzhou"
}
"""
