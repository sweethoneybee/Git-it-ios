//
//  UserSettingViewController.swift
//  Git-it
//
//  Created by 박윤배 on 2021/05/16.
//

import UIKit

class UserSettingViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Property
    
    var userNameField: UITextField!
    var userProfileImage: UIImageView!
    var doneButton: UIButton!
    var leftCancelButton: UIBarButtonItem!
    var rightDoneButton: UIBarButtonItem!
    var editButton: UIButton!
    
    // MARK: ViewLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUserProfileImage()
        addUserNameField()
        addDoneButton()
        addEditButton()
        setRightDoneButton()
        setLeftCancelButton()
        
        self.userNameField.delegate = self
    }
    
    // MARK: UIFunction
    
    private func addUserProfileImage() {
        userProfileImage = { imageView in
            if let data = UserInfo.profileImageData {
                imageView.image = UIImage(data: data)
            } else {
                imageView.image = UIImage(named: "profile.png")
            }
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }(UIImageView())
        
        self.view.addSubview(userProfileImage)
        
        userProfileImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        userProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 165).isActive = true
        userProfileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        userProfileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
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
        
        self.view.addSubview(userNameField)
        
        userNameField.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: 17).isActive = true
        userNameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 86).isActive = true
        userNameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -86).isActive = true
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
        
        self.view.addSubview(doneButton)
        
        doneButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 46).isActive = true
        doneButton.leadingAnchor.constraint(equalTo: userNameField.leadingAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -86).isActive = true
    }
    
    private func addEditButton() {
        editButton = { button in
            button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
            button.tintColor = UIColor.systemBlue
            
            button.addTarget(self, action: #selector(touchUpEditButton(_:)), for: .touchUpInside)
            
            return button
        }(UIButton())
        
        userNameField.rightView = editButton
        userNameField.rightViewMode = UITextField.ViewMode.always
    }
    
    private func setLeftCancelButton() {
        leftCancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(touchUpCancelButton(_:)))
        self.navigationItem.leftBarButtonItem = leftCancelButton
    }

    private func setRightDoneButton() {
        rightDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(touchUpDoneButton(_:)))
        rightDoneButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightDoneButton
    }

    // MARK: Function
    
    private func gotoMain() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: UITextFieldDelegate Methods
    
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
                
                doneButton.isEnabled = true
                rightDoneButton.isEnabled = true
                
                doneButton.backgroundColor = UIColor.systemBlue
                
            } else {
                doneButton.isEnabled = false
                rightDoneButton.isEnabled = false
            }

            return true
        }
        return false
    }
    
    // MARK: IBAction
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        gotoMain()
    }
    
    @IBAction func touchUpDoneButton(_ sender: UIButton) {
        UserInfo.username = userNameField.text
        gotoMain()
    }
    
    @IBAction func touchUpEditButton(_ sender: UIButton) {
        self.userNameField.becomeFirstResponder()
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

extension String {
    func hasCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[0-9a-zA-Z_]$", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
        } catch {
            return false
        }
        return false
    }
}
