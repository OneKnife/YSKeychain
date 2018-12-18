//
//  YSKeychainHelper.swift
//  YSKeyChain
//
//  Created by 赵一超 on 2018/12/17.
//  Copyright © 2018年 melody. All rights reserved.
//

import Foundation
let kKeychainServiceApplication = "kKeychainServiceApplication"

class YSKeychainHelper {
    
    /// 保存一条应用信息
    @discardableResult static func saveApplicationInfo(with key: String, password: String) -> Bool{
        let keyChainItem = YSKeychainPasswordItem.init(service: kKeychainServiceApplication, account: key)
        do {
            try keyChainItem.savePassword(password)
            return true
        } catch {
            return false
        }
    }
    
    /// 读取一条应用信息
    /// 读取失败则返回nil
    @discardableResult static func getApplicationInfo(with key: String) -> String? {
        let keyChainItem = YSKeychainPasswordItem.init(service: kKeychainServiceApplication, account: key)
        do {
            let password = try keyChainItem.readPassword()
            return password
        } catch {
            return nil
        }
    }
    
    /// 删除一条记录
    @discardableResult static func deleteApplicationInfo(with key: String) -> Bool {
        let keyChainItem = YSKeychainPasswordItem.init(service: kKeychainServiceApplication, account: key)
        do {
            try keyChainItem.deleteItem()
            return true
        } catch {
            return false
        }
    }

}


