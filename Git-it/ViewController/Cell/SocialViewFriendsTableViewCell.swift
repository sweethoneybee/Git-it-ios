//
//  SocialViewFriendsTableViewCell.swift
//  Git-it
//
//  Created by 박윤배 on 2021/05/31.
//

import UIKit

class SocialViewFriendsTableViewCell: UITableViewCell {
    
    // MARK: - Property
    
    static let identifier = "SocialViewFriendsTableViewCell"
    var userNameLabel: UILabel?
    var commitSummary: SocialCommitsSummary?
    var userCommitsSummery: CommitsSummary?
    var grassCollectionView: GrassCollectionView?
    var currentDateIndex: Int?
    
    var indexOfFriend: Int?
    var userName: String?
    
    // MARK: - UIFunction
    
    private func addUserNameLabel() {
        userNameLabel = { label in
            if let index = indexOfFriend, let name = userName {
                label.text = "\(index). \(name)"
            }
            
            // test code
            label.text = "string"
            label.font = UIFont.boldSystemFont(ofSize: CGFloat(30))
            
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }(UILabel())
        
        if let label = userNameLabel {
            print("label added")
            contentView.addSubview(label)
        }
    }
    
    private func addGrassCollectionView() {
        grassCollectionView = GrassCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        grassCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        grassCollectionView?.register(GrassCollectionViewCell.self, forCellWithReuseIdentifier: GrassCollectionViewCell.identifier)
        grassCollectionView?.delegate = self
        grassCollectionView?.dataSource = self
        
        // test code
        grassCollectionView?.backgroundColor = UIColor.white
                
        if let grass = grassCollectionView {
            contentView.addSubview(grass)
        }
    }
    
    private func setcurrentDateIndex() {
        if let collectionView = grassCollectionView {
            let numPerLine = Int((collectionView.bounds.width - 20) / ((collectionView.bounds.height - 14) / 7 + 2))
            let cal = Calendar(identifier: .gregorian)
            let now = Date()
            let comp = cal.dateComponents([.weekday], from: now)
            
            self.currentDateIndex = ((numPerLine-1)*7 - 1) + comp.weekday!
        }
    }
    
    func collectionViewCellFlowLayout() {
        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 2 // 아이템간의 거리가 10보다는 크게
        flowLayout.minimumLineSpacing = 2 // 줄 간의 거리가 10보다는 크게
        
        flowLayout.scrollDirection = .horizontal

        self.grassCollectionView?.collectionViewLayout = flowLayout
    }
    
    func setAutoLayout() {
        if let label = userNameLabel, let collectionView = grassCollectionView {
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
            
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10).isActive = true
        }
    }
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addUserNameLabel()
        addGrassCollectionView()
        collectionViewCellFlowLayout()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension

extension SocialViewFriendsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOfCell = (collectionView.bounds.height - 14) / 7
            return CGSize(width: sizeOfCell, height: sizeOfCell)
        }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return 30
        let numPerLine = Int((collectionView.bounds.width - 20) / ((collectionView.bounds.height - 14) / 7 + 2))
        return 7 * numPerLine
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 날짜에 따라 레벨을 넣어주기
        guard let cell: GrassCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: GrassCollectionViewCell.identifier, for: indexPath) as? GrassCollectionViewCell else {
            preconditionFailure("fail to load cell")
        }
        
        var dateFormatter: DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-mm-dd"

            return dateFormatter
        }
        
        if let user = userCommitsSummery {
            // 유저의 정보
            for userdata in user.commitsRecord {
                guard let commitDate = dateFormatter.date(from: userdata.date) else { return GrassCollectionViewCell() }
                let date = Date()
                let nowDateStr = dateFormatter.string(from: date)
                let nowDate = dateFormatter.date(from: nowDateStr)
                
                let diff = nowDate!.timeIntervalSince(commitDate)
                if let index = currentDateIndex {
                    let indexOfCell = index - Int(diff / (60 * 60 * 24))
                    
                    if indexPath.item == indexOfCell {
                        cell.commitLevel = userdata.level
                    }
                }
            }
        }
        
        if let friend = commitSummary {
            // 친구의 정보
            for friendData in friend.commitsRecord {
                guard let commitDate = dateFormatter.date(from: friendData.date) else { return GrassCollectionViewCell() }
                let date = Date()
                let nowDateStr = dateFormatter.string(from: date)
                let nowDate = dateFormatter.date(from: nowDateStr)
                
                let diff = nowDate!.timeIntervalSince(commitDate)
                if let index = currentDateIndex {
                    let indexOfCell = index - Int(diff / (60 * 60 * 24))
                    
                    if indexPath.item == indexOfCell {
                        cell.commitLevel = friendData.level
                    }
                }
            }
        }
        
        // cell.commitLevel = 1
        cell.setColor()
        
        return cell
    }
}
