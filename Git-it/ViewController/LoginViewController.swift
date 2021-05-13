//
//  LoginViewController.swift
//  Git-it
//
//  Created by 서시언 on 2021/05/13.
//

import UIKit

class LoginViewController: UIViewController {
    
    var textFieldUsername: UITextField!
    var btnSubmit: UIButton!
    var btnSubmitLater: UIButton!
    
    func addLabelUsername() {
        let label: UILabel = UILabel()
        
        label.frame = CGRect(x: 55, y: 300, width: 200, height: 40)
        label.font = label.font.withSize(23)
        label.textColor = UIColor.black
        label.text = "My username"
        
        self.view.addSubview(label)
    }
    
    func addTextFieldUsername() {
        let textField: UITextField = UITextField()
        
        textField.frame = CGRect(x: 60, y: 360, width: 280, height: 40)
        textField.borderStyle = .roundedRect
        
        textFieldUsername = textField
        self.view.addSubview(textField)
    }
    
    func addBtnSubmit() {
        let button: UIButton = UIButton()
        
        button.frame = CGRect(x: 60, y: 430, width: 280, height: 40)
        button.setTitle("SUBMIT", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(touchUpBtnSubmmit), for: UIControl.Event.touchUpInside)
        
        btnSubmit=button
        self.view.addSubview(button)
    }
    
    func addBtnSubmitLater() {
        let button: UIButton = UIButton()
        
        button.frame = CGRect(x: 100, y: 475, width: 200, height: 40)
        button.setTitle("I will submit later", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white
        
        btnSubmitLater = button
        self.view.addSubview(button)
    }
    
    @IBAction func touchUpBtnSubmmit() {
        UserInfo.username = textFieldUsername.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLabelUsername()
        self.addTextFieldUsername()
        self.addBtnSubmit()
        self.addBtnSubmitLater()
    }

}
