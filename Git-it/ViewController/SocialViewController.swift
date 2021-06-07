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
    var friendsList: [String]?
    var friendsCommitsSummary: [SocialCommitsSummary]?
    var userCommitsSummery: CommitsSummary?
    
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
        self.userCommitsSummery = try? JSONDecoder().decode(CommitsSummary.self, from: GitItApi.commitsSummary("jeong").sampleData)
        self.friendsCommitsSummary = try? JSONDecoder().decode([SocialCommitsSummary].self, from: GitItApi.social.sampleData)
        
        if let friends = friendsCommitsSummary {
            var list: [String] = []
            for friend in friends {
                list.append(friend.username)
            }
            UserInfo.friendList = list
        }
//        OperationQueue().addOperation {
//            GitItApiProvider().fetchCommitsSummary { result in
//                switch result {
//                case .failure(let error):
//                    print(error)
//                case .success(let commitSummary):
//                    self.userCommitsSummery = commitSummary
//                }
//            }
//
//            GitItApiProvider().fetchSocialCommitsSummary { result in
//                switch result {
//                case .failure(let error):
//                    print(error)
//                case .success(let commitsSummary):
//                    self.friendsCommitsSummary = commitsSummary
//                }
//            }
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
        if let friends = UserInfo.friendList {
            friendsList = friends
            return friends.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SocialViewFriendsTableViewCell =  tableView.dequeueReusableCell(withIdentifier: SocialViewFriendsTableViewCell.identifier, for: indexPath) as? SocialViewFriendsTableViewCell else {
            preconditionFailure("fail to load cell")
        }
        
        switch indexPath.row {
        case 0:
            cell.userName = UserInfo.username
            cell.indexOfFriend = 1
            cell.userCommitRecords = userCommitsSummery?.commitsRecord
            
            cell.addUserNameLabel()
            cell.addGrassCollectionView()
            cell.collectionViewCellFlowLayout()
            cell.setAutoLayout()
            
        case 1, 2, 3, 4:
            if let friends = friendsList, let summary = friendsCommitsSummary {
                cell.userName = friends[indexPath.row - 1]
                cell.indexOfFriend = indexPath.row + 1
                cell.userCommitRecords = summary[indexPath.row - 1].commitsRecord
                
                cell.addUserNameLabel()
                cell.addGrassCollectionView()
                cell.collectionViewCellFlowLayout()
                cell.setAutoLayout()
            }
        default:
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row != 0 {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            // request delete
            // reload data
        }
    }
    
    // MARK: - IBAction

    @IBAction func touchUpAddButton(_ sender: UIButton) {
        
        if let list = friendsList {
            if list.count > 4 {
                let alert = UIAlertController(title: "알림", message: "친구는 최대 5명까지 추가 가능합니다.", preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                // move to next view
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
