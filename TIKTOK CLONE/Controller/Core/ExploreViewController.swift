//
//  ExploreViewController.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//

import UIKit



class ExploreViewController: UIViewController {
    
    private let searchBar : UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search...."
        bar.layer.cornerRadius = 8
        bar.layer.masksToBounds = true
        return bar
    }()
    
    private var collectionView : UICollectionView?
    
    private var sections = [ExploreSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        ExploreManager.shared.delegate = self
        setupSearchBar()
        setupCollectionView()
        configureModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    func setupSearchBar(){
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    
    func configureModel() {
        
        //MARK: - Banners
        sections.append(
            ExploreSection(
                type: .banners,
                cells: ExploreManager.shared.getExploreBanners().compactMap({ exploreBannerVM in
                    return ExploreCell.banner(viewModel: exploreBannerVM)
                })
            )
        )
        
        
        //MARK: - TrendingPost
        sections.append(
            ExploreSection(type: .trendingPosts,
                           cells: ExploreManager.shared.getExploreTrendingPosts().compactMap({ exploreTrendingVM in
                               return ExploreCell.post(viewModel: exploreTrendingVM)
                           }))
        )
        
        //MARK: - Creators
        sections.append(
            ExploreSection(
                type: .users,
                cells: ExploreManager.shared.getExploreCreators().compactMap({ exploreUserViewModel in
                    return ExploreCell.user(viewModel: exploreUserViewModel)
                })
            )
        )
        //MARK: - Hashtags
        sections.append(
            ExploreSection(type: .trendingHashtags,
                           cells: ExploreManager.shared.getExploreHashtags().compactMap({ exploreHashtagViewModel in
                               return ExploreCell.hashtag(viewModel: exploreHashtagViewModel)
                           }))
        )
        //MARK: - Recommended
        sections.append(
            ExploreSection(type: .recommended,
                           cells:ExploreManager.shared.getExploreRecommendedPosts().compactMap({ exploreRecommendedPostViewModel in
                               return ExploreCell.post(viewModel: exploreRecommendedPostViewModel)
                           }))
        )
        //MARK: - Popular
        sections.append(
            ExploreSection(type: .popular,
                           cells: ExploreManager.shared.getExplorePopularPosts().compactMap({ explorePopularPostViewModel in
                               return ExploreCell.post(viewModel: explorePopularPostViewModel)
                           }))
        )
        //MARK: - Recents
        sections.append(
            ExploreSection(type: .new,
                           cells: ExploreManager.shared.getExploreRecents().compactMap({ exploreRecentPostViewModel in
                               return ExploreCell.post(viewModel: exploreRecentPostViewModel)
                           }))
        )
    }
    
    func setupCollectionView () {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layout(for:section)
        }
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier:"cell")
        
        collectionView.register(ExploreHashtagCollectionViewCell.self,
                                forCellWithReuseIdentifier:ExploreHashtagCollectionViewCell.identifier )
        
        collectionView.register(ExploreBannerCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExploreBannerCollectionViewCell.identifier)
        
        collectionView.register(ExplorePostCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier)
        
        collectionView.register(ExploreUserCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    
}

//MARK: - Collection view Delegates
extension ExploreViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    //MARK: - Number of section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    //MARK: - Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    //MARK: - Cell configuration
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
            
        case .banner(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreBannerCollectionViewCell.identifier,
                for: indexPath )
                    as? ExploreBannerCollectionViewCell else {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                        cell.backgroundColor = .random
                        return cell
                    }
            cell.configure(with: viewModel)
            return cell
            
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExplorePostCollectionViewCell.identifier,
                for: indexPath )
                    as? ExplorePostCollectionViewCell else {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                        cell.backgroundColor = .random
                        return cell
                    }
            cell.configure(with: viewModel)
            return cell
            
        case .hashtag(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreHashtagCollectionViewCell.identifier,
                for: indexPath )
                    as? ExploreHashtagCollectionViewCell else {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                        cell.backgroundColor = .random
                        return cell
                    }
            cell.configure(with: viewModel)

            return cell
            
        case .user(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreUserCollectionViewCell.identifier,
                for: indexPath )
                    as? ExploreUserCollectionViewCell else {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                        cell.backgroundColor = .random
                        return cell
                    }
            cell.configure(with: viewModel)

            return cell
        }
        
        
    }
    //MARK: - Cell tap handler
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let model = sections[indexPath.section].cells[indexPath.row]
        switch model {
    
        case .banner(viewModel: let viewModel):
            viewModel.handler()
        case .post(viewModel: let viewModel):
            viewModel.handler()
        case .hashtag(viewModel: let viewModel):
            viewModel.handler()
        case .user(viewModel: let viewModel):
            viewModel.handler()
        }
    }
}

//MARK: - SearchBarDelegate
extension ExploreViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
    }
    
    @objc func didTapCancel() {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil

    }
}

//MARK: - Compositional Layout
extension ExploreViewController {
    func layout(for section : Int) -> NSCollectionLayoutSection{
        
        let sectionType = sections[section].type
        
        switch sectionType {
            
        case .banners:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            //Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            //Return layout
            return sectionLayout
            
            
        case .trendingPosts,.recommended,.new:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            //Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(300)
                ),
                subitem: item,
                count: 2
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .absolute(110),
                        heightDimension: .absolute(300)),
                subitems: [verticalGroup])
            
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            //Return layout
            return sectionLayout
            
            
        case .users:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            //Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            //Return layout
            return sectionLayout
            
            
        case .trendingHashtags:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            //Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                subitems: [item]
                
            )
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: verticalGroup)
            //Return layout
            return sectionLayout
            
        case .popular:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            //Group
            
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize:
                    NSCollectionLayoutSize(
                        widthDimension: .absolute(110),
                        heightDimension: .absolute(200)),
                subitems: [item])
            
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            //Return layout
            return sectionLayout
            
            
            
        }
    }
}

extension ExploreViewController : ExploreManagerDelegate {
    func didTapHashtag(_ hashtag: String) {
        searchBar.text = hashtag
        searchBar.becomeFirstResponder()
    }
    
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
