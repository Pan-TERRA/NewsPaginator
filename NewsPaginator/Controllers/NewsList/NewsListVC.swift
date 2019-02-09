//
//  NewsListVC.swift
//  NewsPaginator
//
//  Created by Vlad Krut on 2/5/19.
//  Copyright © 2019 Vlad Krut. All rights reserved.
//

import UIKit
import ConvenientKit
import EmptyDataSet_Swift

class NewsListVC: BasicVC {
    
    // MARK: - Properties
    
    var viewModel: NewsViewModel!
    
    let refreshControl = UIRefreshControl()
    var isRefreshing = false
    var pullToRefreshCompletion: (()->())?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        
        setupTableView()
        
        viewModel = NewsViewModel(delegate: self)
        tableView.reloadData()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView.registerFromNib(NewItemTVCell.self)
        
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.addSubview(refreshControl)
        
        setupEmptyDataSet()
        
        pullToRefreshCompletion = { [unowned self] in
            self.tableView.reloadData()
            self.isRefreshing = false
            self.refreshControl.endRefreshing()
            
            if self.viewModel.totalCount != 0, self.haveInternetConnection {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
    private func setupEmptyDataSet() {
        
        tableView.emptyDataSetView({ [weak self] emptyStateView in
            var emptyStateText: String
            
            if self?.haveInternetConnection == true {
                emptyStateText = "No News to display. Try to reload later"
            } else {
                emptyStateText = "The Internet connection appears to be offline"
            }
            let attributedText = NSAttributedString(string: emptyStateText)
            emptyStateView.titleLabelString(attributedText).isScrollAllowed(true)
        })
        
    }
    
    // MARK: - Actions
    
    @objc func refresh() {
        
        if !isRefreshing {
            isRefreshing = true
            viewModel.refresh()
        }
    }
    
}

// MARK: - TableView DataSource

extension NewsListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: NewItemTVCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.newModel = viewModel.new(at: indexPath.row)
        
        return cell
    }
    
}

// MARK: - TableView Delegate

extension NewsListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewItemTVCell.height
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewItemTVCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let selectedNew = viewModel.new(at: indexPath.row) else { return }
        
        let detailsVC = NewDetailsVC(new: selectedNew)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}

// MARK: - Prefetching

extension NewsListVC: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchNews()
        }
    }
}

// MARK: - ViewModel Delegate

extension NewsListVC: NewsViewModelDelegate {
    
    func newsViewModelFetchingComplete(_ viewModel: NewsViewModel, newIndexPathsToReload: [IndexPath]?) {
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            tableView.reloadData()
            return
        }
        
        if isRefreshing {
            pullToRefreshCompletion?()
        } else {
            let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
            tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        }
    }
    
    func newsViewModelFetchingFailed(_ viewModel: NewsViewModel, reason: String) {
        
        DispatchQueue.main.async {
            self.pullToRefreshCompletion?()
            self.showAlertWith(text: reason, controller: self)
        }
    }
}

// MARK: - Helpers

private extension NewsListVC {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
