//
//  UserSettingViewController.swift
//  Git-it
//
//  Created by 박윤배 on 2021/05/16.
//

import UIKit

class UserSettingViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Property
    
    var userNameField: UITextField?
    var userProfileImage: UIImageView?
    var doneButton: UIButton?
    var leftCancelButton: UIBarButtonItem?
    var rightDoneButton: UIBarButtonItem?
    var editButton: UIButton?
    
    // MARK: - ViewLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUserProfileImage()
        addUserNameField()
        addDoneButton()
        addEditButton()
        setRightDoneButton()
        setLeftCancelButton()
        
        self.userNameField?.delegate = self
        setAutoLayout()
    }
    
    // MARK: - UIFunction
    
    private func addUserProfileImage() {
        userProfileImage = { imageView in
            imageView.translatesAutoresizingMaskIntoConstraints = false
            guard let key = UserInfo.profileImageKey else {
                //set default
                imageView.image = UIImage(named: "profile.png")
                return imageView
            }
            
            ImageCache.shared.load(url: key) { profileImage in
                imageView.image = profileImage
            }
            
            return imageView
        }(UIImageView())
        
        if let imgView = userProfileImage {
            self.view.addSubview(imgView)
        }
    }
    
    private func addUserNameField() {
        userNameField = { textField in
            textField.text = UserInfo.username
            textField.textAlignment = .center
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
           
            return textField
        }(UITextField())
        
        if let nameField = userNameField {
            self.view.addSubview(nameField)
        }
    }
    
    private func addDoneButton() {
        doneButton = { button in
            button.setTitle("DONE", for: .normal)
            
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = UIColor.gray
            button.layer.cornerRadius = 8
            button.isEnabled = false
            
            button.addTarget(self, action: #selector(touchUpDoneButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }(UIButton())
        
        if let btn = doneButton {
            self.view.addSubview(btn)
        }
    }
    
    private func addEditButton() {
        editButton = { button in
            button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
            button.tintColor = UIColor.systemBlue
            
            button.addTarget(self, action: #selector(touchUpEditButton(_:)), for: .touchUpInside)
            
            return button
        }(UIButton())
        
        userNameField?.rightView = editButton
        userNameField?.rightViewMode = UITextField.ViewMode.always
    }
    
    private func setLeftCancelButton() {
        leftCancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(touchUpCancelButton(_:)))
        self.navigationItem.leftBarButtonItem = leftCancelButton
    }

    private func setRightDoneButton() {
        rightDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(touchUpDoneButton(_:)))
        rightDoneButton?.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightDoneButton
    }
    
    func setAutoLayout() {
        if let imageView = userProfileImage, let textField = userNameField, let doneBtn = doneButton {
            
            // userProfileImage
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 165).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            // userNameField
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 17).isActive = true
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 86).isActive = true
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -86).isActive = true
            
            // doneButton
            doneBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            doneBtn.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 46).isActive = true
            doneBtn.leadingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
            doneBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -86).isActive = true
        }
    }

    // MARK: - Function
    
    private func gotoMain() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        if string.hasCharacters() || isBackSpace == -92 {
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if !text.isEmpty && text != UserInfo.username {
                doneButton?.isEnabled = true
                rightDoneButton?.isEnabled = true
                
                doneButton?.backgroundColor = UIColor.systemBlue
            } else {
                doneButton?.isEnabled = false
                rightDoneButton?.isEnabled = false
            }
            return true
        }
        return false
    }
    
    // MARK: - IBAction
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        gotoMain()
    }
    
    @IBAction func touchUpDoneButton(_ sender: UIButton) {
        UserInfo.username = userNameField?.text
        gotoMain()
    }
    
    @IBAction func touchUpEditButton(_ sender: UIButton) {
        self.userNameField?.becomeFirstResponder()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
