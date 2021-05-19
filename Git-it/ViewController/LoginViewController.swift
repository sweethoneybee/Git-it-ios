//
//  LoginViewController.swift
//  Git-it
//
//  Created by 서시언 on 2021/05/13.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: property
    var labelUserName: UILabel = UILabel()
    var textFieldUsername: UITextField = UITextField()
    var buttonSubmit: UIButton = UIButton()
    var buttonSubmitLater: UIButton = UIButton()
    
    // MARK: override method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addLabelUsername()
        self.addTextFieldUsername()
        self.addBtnSubmit()
        self.addBtnSubmitLater()
    }
    
    // MARK: UI setting mothod
    func addLabelUsername() {
        labelUserName = {label in
            label.frame = CGRect(x: 55, y: 300, width: 200, height: 40)
            label.font = label.font.withSize(23)
            label.textColor = UIColor.black
            label.text = "My username"
            return label
        }(UILabel())
        
        self.view.addSubview(labelUserName)
    }
    
    func addTextFieldUsername() {
        textFieldUsername = {textField in
            textField.frame = CGRect(x: 60, y: 360, width: 280, height: 40)
            textField.borderStyle = .roundedRect
            return textField
        }(UITextField())
        
        self.view.addSubview(textFieldUsername)
    }
    
    func addBtnSubmit() {
        buttonSubmit = {button in
            button.frame = CGRect(x: 60, y: 430, width: 280, height: 40)
            button.setTitle("SUBMIT", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = UIColor.gray
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(touchUpBtnSubmit), for: UIControl.Event.touchUpInside)
            return button
        }(UIButton())
        
        self.view.addSubview(buttonSubmit)
    }
    
    func addBtnSubmitLater() {
        buttonSubmitLater = {button in
            button.frame = CGRect(x: 100, y: 475, width: 200, height: 40)
            button.setTitle("I will submit later", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = UIColor.white
            button.addTarget(self, action: #selector(touchUpBtnSubmitLater), for: UIControl.Event.touchUpInside)
            return button
        }(UIButton())
        
        self.view.addSubview(buttonSubmitLater)
    }
    
    // MARK: objc method
    @objc func touchUpBtnSubmit() {
        UserInfo.username = textFieldUsername.text
        gotoMainTabBar()
    }
    
    @objc func touchUpBtnSubmitLater() {
        gotoMainTabBar()
    }
    
    // MARK: method
    func gotoMainTabBar() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "MainTabBar") else {return}
        self.present(nextVC, animated: true)
    }
}
