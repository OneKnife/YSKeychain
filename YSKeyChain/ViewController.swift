//
//  ViewController.swift
//  YSKeyChain
//
//  Created by 赵一超 on 2018/12/12.
//  Copyright © 2018年 melody. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfield.frame = CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 45)
        saveButton.frame = CGRect.init(x: 0, y: textfield.frame.maxY + 6, width: UIScreen.main.bounds.width, height: 45)
        readButton.frame = CGRect.init(x: 0, y: saveButton.frame.maxY + 6, width: UIScreen.main.bounds.width, height: 45)
        deleteButton.frame = CGRect.init(x: 0, y: readButton.frame.maxY + 6, width: UIScreen.main.bounds.width, height: 45)
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        readButton.addTarget(self, action: #selector(readButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(textfield)
        self.view.addSubview(saveButton)
        self.view.addSubview(readButton)
        self.view.addSubview(deleteButton)
    }
    
    @objc func saveButtonTapped() {
        if let text = textfield.text {
            let result = YSKeychainHelper.saveInfo(with: "YourSavedKey", password: text)
            debugPrint(result ? "保存成功" : "保存失败")
        }else {
            debugPrint("密码为空")
        }
    }
    
    @objc func readButtonTapped() {
        let password = YSKeychainHelper.getApplicationInfo(with: "YourSavedKey")
        debugPrint(password ?? "nil")
    }
    
    @objc func deleteButtonTapped() {
        let result = YSKeychainHelper.deleteApplicationInfo(with: "YourSavedKey")
        debugPrint(result ? "删除成功" : "删除失败")
    }

    lazy var textfield: UITextField = {
        let textfiele = UITextField()
        textfiele.borderStyle = .roundedRect
        return textfiele
    }()

    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitle("保存", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        return button
    }()
    
    lazy var readButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitle("读取", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitle("删除", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        return button
    }()


    
}

