//
//  YSKeychainPasswordItem.swift
//  YSKeyChain
//
//  Created by 赵一超 on 2018/12/12.
//  Copyright © 2018年 melody. All rights reserved.
//

import Foundation

struct YSKeychainConfiguration {
    static let serviceName = "MyAppService"
    /*
        设置一个 access group 可让多个app使用共享一个 Keychain (同一team)
        如不设置则默认一个app一个Keychain
        格式: [YOUR APP ID PREFIX].com.example.apple-samplecode.GenericKeychainShared
     */
    static let accessGroup: String? = nil
}
