//
//  SocialViewFriendsTableViewCell.swift
//  Git-it
//
//  Created by 박윤배 on 2021/05/31.
//

import UIKit

class SocialViewFriendsTableViewCell: UITableViewCell {
    
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
    
    // MARK: - Property
    
    static let identifier = "SocialViewFriendsTableViewCell"
    var userNameLabel: UILabel?
    var grassCollectionView: GrassCollectionView?
    var currentDateIndex: Int {
        let numPerLine = 53
        let cal = Calendar(identifier: .gregorian)
        let now = Date()
        let comp = cal.dateComponents([.weekday], from: now)
        
        return ((numPerLine-1)*7 - 1) + comp.weekday!
    }
    
    var indexOfFriend: Int?
    var userName: String?
    var userCommitRecords: [CommitsRecord]?
    
    // MARK: - UIFunction
    
    func addUserNameLabel() {
        userNameLabel = { label in
            label.font = UIFont.boldSystemFont(ofSize: CGFloat(30))
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }(UILabel())
        
        if let label = userNameLabel {
            contentView.addSubview(label)
        }
    }
    
    func addGrassCollectionView() {
        grassCollectionView = GrassCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        grassCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        grassCollectionView?.register(GrassCollectionViewCell.self, forCellWithReuseIdentifier: GrassCollectionViewCell.identifier)
        grassCollectionView?.delegate = self
        grassCollectionView?.dataSource = self
        
        grassCollectionView?.backgroundColor = UIColor.white
                
        if let grass = grassCollectionView {
            contentView.addSubview(grass)
        }
    }
    
    func collectionViewCellFlowLayout() {
        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 2
        flowLayout.scrollDirection = .horizontal

        self.grassCollectionView?.collectionViewLayout = flowLayout
        
        DispatchQueue.main.async {
            self.grassCollectionView?.scrollToItem(at: IndexPath(item: self.currentDateIndex - 1, section: 0), at: .centeredHorizontally, animated: false)
            }
    }
    
    func setAutoLayout() {
        if let label = userNameLabel, let collectionView = grassCollectionView {
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
            
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomSpace: CGFloat = 10.0
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: bottomSpace, right: 0))
    }
}

// MARK: - Extension

extension SocialViewFriendsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOfCell = (collectionView.bounds.height - 22) / 7
            return CGSize(width: sizeOfCell, height: sizeOfCell)
        }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDateIndex + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: GrassCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: GrassCollectionViewCell.identifier, for: indexPath) as? GrassCollectionViewCell else {
            preconditionFailure("fail to load cell")
        }
        
        if let records = userCommitRecords {
            cell.setColor(commitLevel: records[indexPath.item].level)
            
            // test code
//            for userdata in records {
//                var dateFormatter: DateFormatter {
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "YYYY-MM-dd"
//                    return dateFormatter
//                }
//
//                guard let commitDate = dateFormatter.date(from: userdata.date) else { return GrassCollectionViewCell() }
//                let date = Date()
//                let nowDateStr = dateFormatter.string(from: date)
//                let nowDate = dateFormatter.date(from: nowDateStr)
//                let diff = nowDate!.timeIntervalSince(commitDate)
//
//                let indexOfCell = currentDateIndex - Int(diff / (60 * 60 * 24))
//                if indexOfCell < 0 {
//                    break
//                }
//
//                if indexPath.item == indexOfCell {
//                    cell.setColor(commitLevel: userdata.level)
//                    break
//                } else {
//                    cell.setColor(commitLevel: 0)
//                }
//            }
        }

        return cell
    }
}
