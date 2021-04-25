//
//  SearchController.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/04.
//

import UIKit

final class SearchController: UITableViewController {
    // MARK: - Properties
    private var users: [User] = []
    private var filteredUsers: [User] = []
    private let searchController: UISearchController = .init(searchResultsController: nil)
    
    private var isSearchMode: Bool {
        return searchController.isActive && (searchController.searchBar.text?.isEmpty ?? true == false)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        configureTableView()
        fetchUsers()
    }
    
    // MARK: - API
    private func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    private func configureTableView() {
        view.backgroundColor = .systemBackground
        
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.identifier)
        tableView.rowHeight = 64
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false   // 검색시 화면에 표시되어있는 content들을 흐리게 노출시키는 옵션
        searchController.hidesNavigationBarDuringPresentation = false   // 검색시 네비게이션바를 숨기는 옵션
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

// MARK: - UITableViewDataSource
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        let user: User = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = .init(user: user)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user: User = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let profileController: ProfileController = .init(user: user)
        
        self.navigationController?.pushViewController(profileController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter { $0.username.contains(searchText) || $0.fullname.lowercased().contains(searchText) }
        
        self.tableView.reloadData()
    }
}
