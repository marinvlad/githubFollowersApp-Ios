//
//  FollowersViewController.swift
//  GitHub
//
//  Created by Vlad on 7/22/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

protocol FollowerListVCDelegate : class{
    func didRequestFollowers(for username: String)
}

class FollowersViewController: UIViewController {
    
    enum Section{
         case main
     }
    
    var username : String!
    var collectionView : UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<Section, Follower>!
    var followers : [Follower] = []
    var filteredFollowers : [Follower] = []
    var hasMoreFollowers = false
    var isSearching = false
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureCollectionView()
        configureSearchController()
        configureDataSource()
        getFollowers(username: username, page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          navigationController?.setNavigationBarHidden(false, animated: true)
    }
    //MARK: - Configure methods
    
    func configureView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: "FollowerCell")
    }
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(with: follower)
            return cell
        })
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = " Search for a username"
        navigationItem.searchController = searchController
    }
    
    //MARK: - Other methods
    
    func getFollowers(username : String, page : Int){
        showLoadingView()
        NetworkManager.shared.getFollower(for: username, page: page, completed: { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
           switch result {
           case .success(let followers):
            if followers.count < 100 { self.hasMoreFollowers = false }
            self.followers.append(contentsOf: followers)
            
            if self.followers.isEmpty {
                DispatchQueue.main.async {
                    self.showEmptyStateView(with: "This user dosen't have any follower. Go follow him 😂", in: self.view)
                }
                return
            }
            
            self.updateData(with: self.followers)
           case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "ok")
           }
        })
    }
    
    func updateData(with followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot,animatingDifferences: true)
        }
    }
    
    @objc func addButtonTapped(){
        
    }
}

//MARK: - UICollectionView delegate methods

extension FollowersViewController : UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoViewController()
        destVC.username = follower.login
        destVC.delegate = self
        let navigationController = UINavigationController(rootViewController: destVC)
        present(navigationController, animated: true)
    }
}

//MARK: - SearchBar methods

extension FollowersViewController : UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        
        filteredFollowers = followers.filter({$0.login.lowercased().contains(filter.lowercased())})
        updateData(with: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(with: followers)
        isSearching = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        updateData(with: followers)
        isSearching = false
    }
}

//MARK: - FollowerListVCDelegate methods

extension FollowersViewController : FollowerListVCDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        followers.removeAll()
        filteredFollowers.removeAll()
        page = 1
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }
}
