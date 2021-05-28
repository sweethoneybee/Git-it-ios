//
//  LoginViewController.swift
//  Git-it
//
//  Created by 서시언 on 2021/05/13.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
            textField.delegate = self
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            return textField
        }(UITextField())

        self.view.addSubview(textFieldUsername)
    }
    
    func addBtnSubmit() {
        buttonSubmit = {button in
            button.frame = CGRect(x: 60, y: 430, width: 280, height: 40)
            button.setTitle("SUBMIT", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(touchUpBtnSubmit), for: UIControl.Event.touchUpInside)
            button.backgroundColor = UIColor.lightGray
            button.isUserInteractionEnabled = false
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
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        
        if string.hasCharacters() || isBackSpace == -92 {
            if !text.isEmpty {
                buttonSubmit.isUserInteractionEnabled = true
                buttonSubmit.backgroundColor = UIColor.gray
            } else {
                buttonSubmit.isUserInteractionEnabled = false
                buttonSubmit.backgroundColor = UIColor.lightGray
            }
            return true
        }
        return false
    }
}

extension String {
    func hasCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[0-9a-zA-Z_]$", options: .caseInsensitive)
            if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: self.count)) != nil {
                return true
            }
        } catch {
            return false
        }
        return false
    }
}
