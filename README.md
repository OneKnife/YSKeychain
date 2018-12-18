# YSKeychain

对keychain的一些简单封装，借鉴了官方的demo



## 使用方法

#### 一、直接使用Key来保存和读取数据

保存信息：

```swift
let result = YSKeychainHelper.saveInfo(with: "YourSavedKey", password: text)
debugPrint(result ? "保存成功" : "保存失败")
```

读取信息：

```swift
let password = YSKeychainHelper.getApplicationInfo(with: "YourSavedKey")
debugPrint(password)
```

删除信息：

```swift
let result = YSKeychainHelper.deleteApplicationInfo(with: "YourSavedKey")
debugPrint(result ? "删除成功" : "删除失败")
```



#### 二、使用服务名和用户名来保存和读取信息

```swift
let item = YSKeychainPasswordItem.init(service: "ServiceName", account: "UserName", accessGroup: nil)
item.savePassword("xxxxxx") // 保存密码
item.readPassword() // 读取密码
item.deleteItem()  // 删除密码
item.renameAccount("NewUserName") // 更改用户名
```