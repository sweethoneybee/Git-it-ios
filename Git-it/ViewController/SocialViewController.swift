//
//  SocialViewController.swift
//  Git-it
//
//  Created by 박윤배 on 2021/06/02.
//

import UIKit

class SocialViewController: UIViewController, UITableViewDataSource {

    // MARK: - Property
    
    var friendAddButton: UIButton?
    var friendsTableView: UITableView?
    var commitsSummary: [SocialCommitsSummary]?
    private var action: UIAlertAction!
    private var friendIdTypedInAlert: String?
    
    // MARK: - ViewLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateFriends()
        addTableView()
        addFriendAddButton()
        setAutoLayout()
    }
    
    // MARK: - UIFunction
    
    private func addFriendAddButton() {
        friendAddButton = { addButton in
            
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
            let largeBoldDoc = UIImage(systemName: "plus.circle.fill", withConfiguration: largeConfig)
            addButton.setImage(largeBoldDoc, for: .normal)
            addButton.tintColor = UIColor.systemBlue
            
            addButton.addTarget(self, action: #selector(touchUpAddButton(_:)), for: .touchUpInside)
            addButton.contentMode = UIView.ContentMode.scaleAspectFill
            
            addButton.translatesAutoresizingMaskIntoConstraints = false
            
            return addButton
        }(UIButton())
        
        if let addButton = friendAddButton {
            self.view.addSubview(addButton)
        }
    }
    
    private func addTableView() {
        friendsTableView = { tableView in
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.dataSource = self
            tableView.register(SocialViewFriendsTableViewCell.self, forCellReuseIdentifier: SocialViewFriendsTableViewCell.identifier)
            
            tableView.rowHeight = CGFloat(200)
            tableView.estimatedRowHeight = CGFloat(200)
            
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
            
            return tableView
        }(UITableView())
        
        if let tableView = friendsTableView {
            self.view.addSubview(tableView)
        }
    }
    
    // MARK: - Function
    
    func updateFriends() {
        
        // test code
        
//        if let data = try? JSONDecoder().decode(CommitsSummary.self, from: GitItApi.commitsSummary(UserInfo.username!).sampleData) {
//            let tempUserCommitSummery: SocialCommitsSummary = SocialCommitsSummary(validation: "VALID", username: data.username, commitsRecord: data.commitsRecord)
//            self.commitsSummary = [tempUserCommitSummery]
//        }
//        if let tempFriendsCommitsSummary = try? JSONDecoder().decode([SocialCommitsSummary].self, from: GitItApi.social.sampleData) {
//            self.commitsSummary?.append(contentsOf: tempFriendsCommitsSummary)
//            self.commitsSummary = self.commitsSummary?.sorted(by: {$0.commitsRecord.count > $1.commitsRecord.count})
//        }
//        if let datas = commitsSummary {
//            var list: [String] = []
//            for userName in datas {
//                list.append(userName.username)
//            }
//            UserInfo.friendList = list
//        }
        
        DispatchQueue.main.async {
            GitItApiProvider().fetchCommitsSummary { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let commitSummary):
                    let tempUserCommitSummary: SocialCommitsSummary = SocialCommitsSummary(validation: "VALID", username: commitSummary.username, commitsRecord: commitSummary.commitsRecord)
                    self.commitsSummary = [tempUserCommitSummary]
                }
            }

            GitItApiProvider().fetchSocialCommitsSummary { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let commitsSummary):
                    self.commitsSummary?.append(contentsOf: commitsSummary)
                    self.commitsSummary = self.commitsSummary?.sorted(by: {$0.commitsRecord.count > $1.commitsRecord.count})
                }
            }
        }
        
        self.friendsTableView?.reloadData()
    }
    
    func setAutoLayout() {
        if let tableView = friendsTableView, let addButton = friendAddButton {
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
            addButton.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -10).isActive = true
            addButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -10).isActive = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = self.commitsSummary {
            return list.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SocialViewFriendsTableViewCell =  tableView.dequeueReusableCell(withIdentifier: SocialViewFriendsTableViewCell.identifier, for: indexPath) as? SocialViewFriendsTableViewCell else {
            preconditionFailure("fail to load cell")
        }
        
        if let userData = self.commitsSummary {
            cell.userName = userData[indexPath.row].username
            cell.indexOfFriend = indexPath.row + 1
            cell.userCommitRecords = userData[indexPath.row].commitsRecord
            cell.userNameLabel?.text = "\(indexPath.row + 1). \(userData[indexPath.row].username)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete friend
        }
    }
    
    // MARK: - IBAction

    @IBAction func touchUpAddButton(_ sender: UIButton) {
        
        if let list = UserInfo.friendList {
            if list.count > 5 {
                let alert = UIAlertController(title: "알림", message: "친구는 최대 5명까지 추가 가능합니다.", preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                // move to next view
                let alert = UIAlertController(title: "친구 추가", message: "깃 허브 아이디를 입력해주세요.", preferredStyle: .alert)
                
                alert.addTextField { textField in
                    let searchButton = UIButton()
                    searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
                    
                    textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
                    searchButton.addTarget(self, action: #selector(self.isExistId), for: .touchUpInside)
                    
                    textField.rightView = searchButton
                    textField.rightViewMode = .always
                }
                
                action = UIAlertAction(title: "추가", style: .default) { _ in
                    guard let textField = alert.textFields else {
                        preconditionFailure("fail to load textfield")
                    }
                    
                    let friendId = textField[0].text
                    
                    // api를 통해 친구 아이디 추가
                    print("added : \(String(describing: friendId))")
                    
                    
                    
                    self.updateFriends()
                }
                
                let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
                    print("cancel button clicked")
                }
                
                action.isEnabled = false
                alert.addAction(action)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func textFieldDidChange(_ field: UITextField) {
        self.friendIdTypedInAlert = field.text
    }
    
    @objc func isExistId(sender: UIButton) {
        guard let friendId = self.friendIdTypedInAlert else {
            action.isEnabled = false
            return
        }
        
        DispatchQueue.main.async {
            
            guard let name = self.friendIdTypedInAlert else {
                self.action.isEnabled = false
                return
            }
            
            GitItApiProvider().checkId(username: name) { result in
                switch result {
                case .failure(let error):
                    print(error)
                    self.action.isEnabled = false
                case .success(_):
                    self.action.isEnabled = true
                }
            }
        }
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
