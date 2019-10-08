# JSON

- [将 JSON 转成 Model + 解析代码](# JSON 转 Model)
- [生成 Init 方法](#生成 Init)
- [将 Request（Query or JSON）转成 Model + Parameters 代码](#Request 转 Model)



## JSON 转 Model

Input

```
{
   "age":18,
   "sex":1,
   "user_name":"zhangsan",
}
```

Output

```swift
struct Root {
    let age: Int
    let sex: Int
    let userName: String
    init(age: Int,
         sex: Int,
         userName: String) {
        self.age = age
        self.sex = sex
        self.userName = userName
    }
}
/// Deal JSON
extension Root {
    init?(json: JSON) {
        guard
            let age = json["age"].int,
            let sex = json["sex"].int,
            let userName = json["user_name"].string
            else { return nil }
        self.init(age: age,
                  sex: sex,
                  userName: userName)
    }
}

```



## 生成 Init

Input

```swift
let age: Int
let sex: Int
let userName: String
```

Output

```swift
init(age: Int,
     sex: Int,
     userName: String) {
    self.age = age
    self.sex = sex
    self.userName = userName
}
/// Call
self.init(age: age,
          sex: sex,
          userName: userName)
```



## Request 转 Model

Input - JSON

```
{
   "age":18,
   "sex":1,
   "user_name":"zhangsan",
}
```

Input - Query

```
age=18&sex=1&user_name=zhangsan
```

Output

```swift
struct Root {
    let age: Int
    let sex: Int
    let userName: String
    init(age: Int,
         sex: Int,
         userName: String) {
        self.age = age
        self.sex = sex
        self.userName = userName
    }
}
/// Parameters
var parameters: [String:Any] {
    var parameters = [String:Any]()
    parameters["age"] = age
    parameters["sex"] = sex
    parameters["user_name"] = userName
    return parameters
}
```



## License

**JSON** is under MIT license. See the [LICENSE](LICENSE) file for more info.