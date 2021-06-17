//
//  HomeViewController.swift
//  Git-it
//
//  Created by 박윤배 on 2021/06/11.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Property
    
    var settingButton: UIButton?
    var profileImage: UIImageView?
    var userNameLabel: UILabel?
    var todayCommitLabel: UILabel?
    var todayCommitCountLabel: UILabel?
    var commitStreakLabel: UILabel?
    var commitStreakCountLabel: UILabel?
    var grassCollectionView: GrassCollectionView?
    var refreshButton: UIButton?
    var userData: CommitsSummary?
    
    var currentDateIndex: Int {
        let numPerLine = 53
        let cal = Calendar(identifier: .gregorian)
        let now = Date()
        let comp = cal.dateComponents([.weekday], from: now)
        
        return ((numPerLine-1)*7 - 1) + comp.weekday!
    }
    
    // MARK: - ViewLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUserData()
        addSettingButton()
        addProfileImage()
        addUserNameLabel()
        addTodayCommitLabel()
        addCommitStreakLabel()
        addGrassCollectionView()
        addRefreshButton()
        collectionViewCellFlowLayout()
        setAutoLayout()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchUpUsernameLabel(_:)))
        userNameLabel?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - UIFunction
    
    func addSettingButton() {
        settingButton = { btn in
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
            let largeBoldDoc = UIImage(systemName: "gearshape.fill", withConfiguration: largeConfig)
            btn.setImage(largeBoldDoc, for: .normal)
            btn.tintColor = UIColor.systemBlue
            
            btn.addTarget(self, action: #selector(touchUpSettingButton(_:)), for: .touchUpInside)
            btn.contentMode = UIView.ContentMode.scaleAspectFill
            
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }(UIButton())
        
        if let btn = settingButton {
            self.view.addSubview(btn)
        }
    }
    
    func addProfileImage() {
        profileImage = { imgView in
            imgView.translatesAutoresizingMaskIntoConstraints = false
            guard let key = UserInfo.profileImageData else {
                imgView.image = UIImage(named: "profile.png")
                return imgView
            }
            imgView.image = UIImage(data: key)
            
//            ImageCache.shared.load(url: key) { profileImage in
//                imageView.image = profileImage
//            }
            
            return imgView
        }(UIImageView())
        
        if let img = profileImage {
            self.view.addSubview(img)
        }
    }
    
    func addUserNameLabel() {
        userNameLabel = { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            if let user = userData {
                label.text = user.username
                label.isUserInteractionEnabled = false
            } else {
                label.text = "submit username"
                label.isUserInteractionEnabled = true
            }
            label.font = UIFont.boldSystemFont(ofSize: 30)
            
            return label
        }(UILabel())
        
        if let label = userNameLabel {
            self.view.addSubview(label)
        }
    }
    
    func addTodayCommitLabel() {
        todayCommitLabel = { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Today's Commit"
            return label
        }(UILabel())
        
        todayCommitCountLabel = { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            if let data = userData {
                label.text = "\(data.commitsRecord.count)"
            } else {
                label.text = "0"
            }
            label.font = UIFont.boldSystemFont(ofSize: 40)
            
            return label
        }(UILabel())
        
        if let label = todayCommitLabel, let countLabel = todayCommitCountLabel {
            self.view.addSubview(label)
            self.view.addSubview(countLabel)
        }
    }
    
    func addCommitStreakLabel() {
        commitStreakLabel = { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Commit Streak"
            return label
        }(UILabel())
        
        commitStreakCountLabel = { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            if let data = userData {
                label.text = "\(data.commitStreak)"
            } else {
                label.text = "0"
            }
            label.font = UIFont.boldSystemFont(ofSize: 40)
            return label
        }(UILabel())
        
        if let label = commitStreakLabel, let countLabel = commitStreakCountLabel {
            self.view.addSubview(label)
            self.view.addSubview(countLabel)
        }
    }
    
    func addGrassCollectionView() {
        grassCollectionView = GrassCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        grassCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        grassCollectionView?.register(GrassCollectionViewCell.self, forCellWithReuseIdentifier: GrassCollectionViewCell.identifier)
        grassCollectionView?.delegate = self
        grassCollectionView?.dataSource = self
        grassCollectionView?.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        grassCollectionView?.backgroundColor = UIColor.white
                
        if let grass = grassCollectionView {
            self.view.addSubview(grass)
        }
    }
    
    func addRefreshButton() {
        refreshButton = { btn in
            btn.translatesAutoresizingMaskIntoConstraints = false
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            let largeBoldDoc = UIImage(systemName: "arrow.clockwise", withConfiguration: largeConfig)
            btn.setImage(largeBoldDoc, for: .normal)
            
            btn.addTarget(self, action: #selector(touchUpRefreshButton(_:)), for: .touchUpInside)
            btn.contentMode = .scaleAspectFill
            btn.tintColor = UIColor.systemBlue
            return btn
        }(UIButton())
        
        if let btn = refreshButton {
            self.view.addSubview(btn)
        }
    }
    
    func setAutoLayout() {
        if let settingBtn = settingButton, let profileImg = profileImage, let userName = userNameLabel, let todayCommit = todayCommitLabel, let todayCommitCount = todayCommitCountLabel, let commitStreak = commitStreakLabel, let commitStreakCount = commitStreakCountLabel, let grass = grassCollectionView, let refreshBtn = refreshButton {
            
            settingBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            settingBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
            
            profileImg.topAnchor.constraint(equalTo: settingBtn.bottomAnchor, constant: 20).isActive = true
            profileImg.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
            profileImg.widthAnchor.constraint(equalToConstant: 100).isActive = true
            profileImg.heightAnchor.constraint(equalToConstant: 100).isActive = true

            userName.leadingAnchor.constraint(equalTo: profileImg.trailingAnchor, constant: 10).isActive = true
            userName.centerYAnchor.constraint(equalTo: profileImg.centerYAnchor).isActive = true

            todayCommit.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
            todayCommit.topAnchor.constraint(equalTo: profileImg.bottomAnchor, constant: 10).isActive = true
            todayCommitCount.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
            todayCommitCount.topAnchor.constraint(equalTo: todayCommit.bottomAnchor, constant: 10).isActive = true

            commitStreak.topAnchor.constraint(equalTo: todayCommitCount.bottomAnchor, constant: 20).isActive = true
            commitStreak.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
            commitStreakCount.topAnchor.constraint(equalTo: commitStreak.bottomAnchor, constant: 10).isActive = true
            commitStreakCount.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true

            refreshBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
            refreshBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            
            grass.topAnchor.constraint(equalTo: commitStreakCount.bottomAnchor, constant: 10).isActive = true
            grass.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
            grass.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
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
    
    // MARK: - Function
    
    func updateUserData() {
        
        // test code
        
        self.userData = try? JSONDecoder().decode(CommitsSummary.self, from: GitItApi.commitsSummary(UserInfo.username!).sampleData)
        
//        DispatchQueue.main.async {
//            GitItApiProvider().fetchCommitsSummary { result in
//                switch result {
//                case .failure(let error):
//                    print(error)
//                case .success(let commitSummary):
//                    self.userData = commitSummary
//                }
//            }
//        }
    }
    
    func updateView() {
        updateUserData()
        if let data = userData {
            if let name = userNameLabel, let todayCommit = todayCommitCountLabel, let commitStreak = commitStreakCountLabel, let grass = grassCollectionView {
                name.text = data.username
                todayCommit.text = "\(data.commitsRecord.count)"
                commitStreak.text = "\(data.commitStreak)"
                
//            ImageCache.shared.load(url: key) { profileImage in
//                imageView.image = profileImage
//            }"
                
                grass.reloadData()
            }
        }
    }
    
    // MARK: - IBAction func

    @IBAction func touchUpSettingButton(_ sender: UIButton) {
        if let settingVc = self.storyboard?.instantiateViewController(identifier: "SettingView") {
            self.navigationController?.pushViewController(settingVc, animated: true)
        }
    }
    
    @IBAction func touchUpUsernameLabel(_ sender: UITapGestureRecognizer) {
        if let settingVc = self.storyboard?.instantiateViewController(identifier: "SettingView") {
            self.navigationController?.pushViewController(settingVc, animated: true)
        }
    }
    
    @IBAction func touchUpRefreshButton(_ sender: UIButton) {
        updateView()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        
        if let records = userData {
 //           cell.setColor(commitLevel: records.commitsRecord[indexPath.item].level)
            
            // test code
            for userdata in records.commitsRecord {
                var dateFormatter: DateFormatter {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    return dateFormatter
                }

                guard let commitDate = dateFormatter.date(from: userdata.date) else { return GrassCollectionViewCell() }
                let date = Date()
                let nowDateStr = dateFormatter.string(from: date)
                let nowDate = dateFormatter.date(from: nowDateStr)
                let diff = nowDate!.timeIntervalSince(commitDate)

                let indexOfCell = currentDateIndex - Int(diff / (60 * 60 * 24))
                if indexOfCell < 0 {
                    break
                }

                if indexPath.item == indexOfCell {
                    cell.setColor(commitLevel: userdata.level)
                    break
                } else {
                    cell.setColor(commitLevel: 0)
                }
            }
            
        } else {
            cell.setColor(commitLevel: 0)
        }

        return cell
    }
}
