//
//  StatsViewController.swift
//  Git-it
//
//  Created by 서시언 on 2021/06/01.
//

import UIKit

class StatsViewController: UIViewController {
    // MARK: - property
    var buttonRefresh: UIButton?
    var labelYourStats: UILabel?
    var labelRank: UILabel?
    var labelTotalCommits: UILabel?
    var labelAverage: UILabel?
    var labelMaxCommitStreak: UILabel?
    var labelRankContent: UILabel?
    var labelTotalCommitsContent: UILabel?
    var labelAverageContent: UILabel?
    var labelMaxCommitStreakContent: UILabel?
        
    // MARK: - override method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButtonRefresh()
        addLabelYourStats()
        addLabelRank()
        addLabelRankContent()
        addLabelTotalCommits()
        addLabelTotalCommitsContent()
        addLabelAverage()
        addLabelAverageContent()
        addLabelMaxCommitStreak()
        addLabelMaxCommitStreakContent()
        
        refreshStats()
    }
    
    // MARK: - UI setting mothod
    func addButtonRefresh() {
        buttonRefresh = {button in
            button.setImage(UIImage(named: "buttonRefresh"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(refreshStats), for: UIControl.Event.touchUpInside)
            return button
        }(UIButton())
        
        if let button = buttonRefresh {
            self.view.addSubview(button)
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            button.widthAnchor.constraint(equalToConstant: 30).isActive = true
            button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
    }
    func addLabelYourStats() {
        labelYourStats = {label in
            label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.largeTitle)
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.text = "Your Stats"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }(UILabel())
        
        if let label = labelYourStats {
            self.view.addSubview(label)
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110).isActive = true
            label.widthAnchor.constraint(equalToConstant: 300).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    func addLabelRank() {
        labelRank = {label in
            label.font = label.font.withSize(26)
            label.textColor = UIColor.black
            label.text = "Rank"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }(UILabel())
        
        if let label = labelRank {
            self.view.addSubview(label)
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
            label.topAnchor.constraint(equalTo: labelYourStats!.bottomAnchor, constant: 30).isActive = true
            label.widthAnchor.constraint(equalToConstant: 300).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    func addLabelRankContent() {
        labelRankContent = {label in
            label.font = label.font.withSize(23)
            label.textColor = UIColor.darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }(UILabel())
        
        if let label = labelRankContent {
            self.view.addSubview(label)
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 65).isActive = true
            label.topAnchor.constraint(equalTo: labelRank!.bottomAnchor, constant: 8).isActive = true
            label.widthAnchor.constraint(equalToConstant: 300).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    func addLabelTotalCommits() {
        labelTotalCommits = {label in
            label.font = label.font.withSize(26)
            label.textColor = UIColor.black
            label.text = "Total Commits"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }(UILabel())
        
        if let label = labelTotalCommits {
            self.view.addSubview(label)
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
            label.topAnchor.constraint(equalTo: labelRankContent!.bottomAnchor, constant: 30).isActive = true
            label.widthAnchor.constraint(equalToConstant: 300).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    func addLabelTotalCommitsContent() {
        labelTotalCommitsContent = {label in
            label.font = label.font.withSize(23)
            label.textColor = UIColor.darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }(UILabel())
        
        if let label = labelTotalCommitsContent {
            self.view.addSubview(label)
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 65).isActive = true
            label.topAnchor.constraint(equalTo: labelTotalCommits!.bottomAnchor, constant: 8).isActive = true
            label.widthAnchor.constraint(equalToConstant: 300).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    func addLabelAverage() {
        labelAverage = {label in
            label.font = label.font.withSize(26)
            label.textColor = UIColor.black
            label.text = "Average"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }(UILabel())
        
        if let label = labelAverage {
            self.view.addSubview(label)
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
            label.topAnchor.constraint(equalTo: labelTotalCommitsContent!.bottomAnchor, constant: 30).isActive = true
            label.widthAnchor.constraint(equalToConstant: 300).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    func addLabelAverageContent() {
        labelAverageContent = {label in
            label.font = label.font.withSize(23)
            label.textColor = UIColor.darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }(UILabel())
        
        if let label = labelAverageContent {
            self.view.addSubview(label)
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 65).isActive = true
            label.topAnchor.constraint(equalTo: labelAverage!.bottomAnchor, constant: 8).isActive = true
            label.widthAnchor.constraint(equalToConstant: 300).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    func addLabelMaxCommitStreak() {
        labelMaxCommitStreak = {label in
            label.font = label.font.withSize(26)
            label.textColor = UIColor.black
            label.text = "Max Commit Streak"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }(UILabel())
        
        if let label = labelMaxCommitStreak {
            self.view.addSubview(label)
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
            label.topAnchor.constraint(equalTo: labelAverageContent!.bottomAnchor, constant: 30).isActive = true
            label.widthAnchor.constraint(equalToConstant: 300).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    func addLabelMaxCommitStreakContent() {
        labelMaxCommitStreakContent = {label in
            label.font = label.font.withSize(23)
            label.textColor = UIColor.darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }(UILabel())
        
        if let label = labelMaxCommitStreakContent {
            self.view.addSubview(label)
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 65).isActive = true
            label.topAnchor.constraint(equalTo: labelMaxCommitStreak!.bottomAnchor, constant: 8).isActive = true
            label.widthAnchor.constraint(equalToConstant: 300).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    
    // MARK: - objc method
    @objc func refreshStats() {
        let statsData: StatsData?
            
//        GitItApiProvider().fetchStatsData { result in
//            switch result {
//            case .success(let statsData):
//                self.statsData = statsData
//            case .failure(let error):
//                print(error.errorDescription!)
//            }
//        }
        statsData = try? JSONDecoder().decode(StatsData.self, from: GitItApi.stats("jeong").sampleData)

        labelRankContent!.text = statsData?.tier
        if let totalCommits = statsData?.totalCommits {
            labelTotalCommitsContent!.text = String(totalCommits)
        }
        if let average = statsData?.average {
            labelAverageContent!.text = String(average)
        }
        if let max = statsData?.maxCommitStreak {
            labelMaxCommitStreakContent!.text = String(max)
        }
    }
}
