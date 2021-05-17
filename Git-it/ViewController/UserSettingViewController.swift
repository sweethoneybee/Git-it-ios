//
//  UserSettingViewController.swift
//  Git-it
//
//  Created by 박윤배 on 2021/05/16.
//

import UIKit

class UserSettingViewController: UIViewController {
    
    // MARK: Property
    
    var userNameField: UITextField!
    var userProfileImage: UIImageView!
    var doneButton: UIButton!
    var cancelButton: UIButton!
    var editButton: UIButton!
    
    // MARK: ViewLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addUserProfileImage()
        addUserNameField()
        addDoneButton()
        addEditButton()
        addCancelButton()
    }
    
    // MARK: UIFunction
    
    func addUserProfileImage() {
        let imageView: UIImageView = { imageView in
            if let data = UserInfo.profileImageData {
                imageView.image = UIImage(data: data)
            } else {
                imageView.image = UIImage(named: "profile.png")
            }
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            userProfileImage = imageView
            return imageView
        }(UIImageView())
        
        self.view.addSubview(imageView)
        
        userProfileImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        userProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 165).isActive = true
        userProfileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        userProfileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func addUserNameField() {
        let textField: UITextField = { textField in
            textField.isEnabled = false
            textField.text =  UserInfo.Key.username.rawValue
            textField.textAlignment = .center
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            
            userNameField = textField
            return textField
        }(UITextField())
        
        self.view.addSubview(textField)
        
        userNameField.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: 17).isActive = true
        userNameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 86).isActive = true
        userNameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -106).isActive = true
    }
    
    func addDoneButton() {
        let button: UIButton = { button in
            button.setTitle("DONE", for: .normal)
            
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = UIColor.gray
            button.layer.cornerRadius = 8
            
            button.addTarget(self, action: #selector(touchUpDoneButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            doneButton = button
            return button
        }(UIButton())
        
        self.view.addSubview(button)
        
        doneButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 46).isActive = true
        doneButton.leadingAnchor.constraint(equalTo: userNameField.leadingAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -86).isActive = true
    }
    
    func addEditButton() {
        let button: UIButton = { button in
            button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
            button.tintColor = UIColor.blue
            
            button.addTarget(self, action: #selector(touchUpEditButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            editButton = button
            return button
        }(UIButton())
        
        self.view.addSubview(button)
        
        editButton.centerYAnchor.constraint(equalTo: userNameField.centerYAnchor).isActive = true
        editButton.leadingAnchor.constraint(equalTo: userNameField.trailingAnchor, constant: 0).isActive = true
    }
    
    func addCancelButton() {
        let button: UIButton = { button in
            button.setTitle("Cancel", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(touchUpCancelButton(_:)), for: .touchUpInside)
            
            cancelButton = button
            return button
        }(UIButton())
        
        self.view.addSubview(button)
        
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    // MARK: Function
    
    func gotoMain() {
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        userNameField.isEnabled = !userNameField.isEnabled
        if userNameField.isEnabled {
            editButton.tintColor = UIColor.gray
            userNameField.textColor = UIColor.blue
        } else {
            editButton.tintColor = UIColor.blue
            userNameField.textColor = UIColor.gray
        }
        // 에딧 버튼을 누르는 과정에서 해당 아이디가 존재하는지에 대한 여부를 판단 해야할거 같음
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
