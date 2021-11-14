//
//  CompositionalVIewPractice.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 11/11/21.
//

import UIKit

class CompositionalVIewPractice: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
    }
    
    
    func setupCollectionView(){
        let searchCollectionView = UICollectionView(frame: .zero,
                                                    collectionViewLayout: getCompositionalLayout())
        searchCollectionView.frame = self.view.frame
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.backgroundColor = .white
        searchCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        self.view.addSubview(searchCollectionView)
    }
    
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout{
        
        // Single top Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1/3)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        
        // ---- Group1 --- //
        let group1Item1 = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),
                                               heightDimension: .fractionalHeight(1)))
        group1Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
    
        
        let nestedHorizontalItem1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

        let nestedHorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2)), subitems: [nestedHorizontalItem1])
        
        let nestedGroup1Item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2)))
        nestedGroup1Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

        
        let nestedGroup1 = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)), subitems: [nestedGroup1Item1,nestedHorizontalGroup])
        
        let group1 = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/3)),
            subitems: [group1Item1,nestedGroup1])
        
        
        
        // ---- Group2 --- //
        let group2Item1 = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                               heightDimension: .fractionalHeight(1)))
        let group2 = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/3)),
            subitems: [group2Item1])
        
        group2Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        
        // ------ Container Group --- //
        let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(600)), subitems: [item,group1,group2])
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
extension CompositionalVIewPractice : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        cell.backgroundColor = .random
        return cell
    }
    
    
}

extension UIColor {
    static var random : UIColor {
        return UIColor(red: .random(in: 0.4...1),
                       green: .random(in: 0.4...1),
                       blue: .random(in: 0.4...1),
                       alpha: 1)
    }
}
