//
//  YSYSKeychainPasswordItem.swift
//  YSKeyChain
//
//  Created by 赵一超 on 2018/12/12.
//  Copyright © 2018年 melody. All rights reserved.
//

import Foundation

struct YSKeychainPasswordItem {
    
    enum YSKeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }
    
    // 服务名
    let service: String
    
    private(set) var account: String
    
    let accessGroup: String?
    
    // MARK: Intialization
    
    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
    
    // MARK: Keychain 操作
    
    func readPassword() throws -> String  {
        // 创建一个keychainQuery
        var query = YSKeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // 尝试查询已有的keychain状态
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // 查询失败则报错
        guard status != errSecItemNotFound else { throw YSKeychainError.noPassword }
        guard status == noErr else { throw YSKeychainError.unhandledError(status: status) }
        
        // 从结果解析password
        guard let existingItem = queryResult as? [String : AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
            else {
                throw YSKeychainError.unexpectedPasswordData
        }
        
        return password
    }
    
    func savePassword(_ password: String) throws {
        // 需要先将密码encode成data类型
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do {
            // 检查钥匙串中的现有项目
            try _ = readPassword()
            
            // 如果已经存在则更新
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = YSKeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // 如果报错则抛出
            guard status == noErr else { throw YSKeychainError.unhandledError(status: status) }
        }
        catch YSKeychainError.noPassword {
            // 没有已存在的keyChain item 则创建一个新的 item
            var newItem = YSKeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            // 在keychain中添加
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // 如果报错则抛出
            guard status == noErr else { throw YSKeychainError.unhandledError(status: status) }
        }
    }
    
    /// 对已存在的Account改名
    mutating func renameAccount(_ newAccountName: String) throws {
        var attributesToUpdate = [String : AnyObject]()
        attributesToUpdate[kSecAttrAccount as String] = newAccountName as AnyObject?
        
        let query = YSKeychainPasswordItem.keychainQuery(withService: service, account: self.account, accessGroup: accessGroup)
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        
        // 抛出意外
        guard status == noErr || status == errSecItemNotFound else { throw YSKeychainError.unhandledError(status: status) }
        
        self.account = newAccountName
    }
    
    /// 删除已存在的item
    func deleteItem() throws {
        let query = YSKeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        // 抛出意外
        guard status == noErr || status == errSecItemNotFound else { throw YSKeychainError.unhandledError(status: status) }
    }
    
    // 查询匹配 service 和 access group 的所有密码
    static func passwordItems(forService service: String, accessGroup: String? = nil) throws -> [YSKeychainPasswordItem] {

        var query = YSKeychainPasswordItem.keychainQuery(withService: service, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanFalse
        
        // 获取所有项目
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // 如果没有找到, 返回空
        guard status != errSecItemNotFound else { return [] }
        
        // 抛出意外
        guard status == noErr else { throw YSKeychainError.unhandledError(status: status) }
        
        // 效验数据合法性 (对象的数组)
        guard let resultData = queryResult as? [[String : AnyObject]] else { throw YSKeychainError.unexpectedItemData }
        
        // 查询找到的每一项
        var passwordItems = [YSKeychainPasswordItem]()
        for result in resultData {
            guard let account  = result[kSecAttrAccount as String] as? String else { throw YSKeychainError.unexpectedItemData }
            
            let passwordItem = YSKeychainPasswordItem(service: service, account: account, accessGroup: accessGroup)
            passwordItems.append(passwordItem)
        }
        
        return passwordItems
    }
    
    // MARK: Convenience
    
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
}
