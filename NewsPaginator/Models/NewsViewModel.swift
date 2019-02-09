//
//  NewsViewModel.swift
//  NewsPaginator
//
//  Created by Vlad Krut on 2/5/19.
//  Copyright © 2019 Vlad Krut. All rights reserved.
//

import ObjectMapper
import RealmSwift
import Reachability

protocol NewsViewModelDelegate: class {
    func newsViewModelFetchingComplete(_ viewModel: NewsViewModel, newIndexPathsToReload: [IndexPath]?)
    func newsViewModelFetchingFailed(_ viewModel: NewsViewModel, reason: String)
}

class NewsViewModel {
    
    // MARK: - Constants
    
    private let pageSize: Int = 10

    // MARK: - Properties

    private weak var delegate: NewsViewModelDelegate?
    
    private var news: [NewModel] = [] {
        didSet {
            print("Loaded news: \(news.count). Total: \(totalCount)")
        }
    }
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    private var isAllNewsLoaded = false
    
    private var reachability = Reachability()
    
    // MARK: - Lifecycle

    init(delegate: NewsViewModelDelegate) {
        self.delegate = delegate
        
        try? reachability?.startNotifier()
        if reachability?.connection == Reachability.Connection.none {
            restoreFromDatabase()
        } else {
            refresh()
        }
    }
    
    // MARK: - Public Accessors

    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return news.count
    }
    
    func new(at index: Int) -> NewModel? {
        return news[safe: index]
    }
    
    func refresh() {
        
        guard reachability!.connection != .none else {
            delegate?.newsViewModelFetchingFailed(self, reason: "The Internet connection appears to be offline")
            return
        }
        
        news = []
        currentPage = 1
        total = 0
        isFetchInProgress = false
        isAllNewsLoaded = false
        
        let realm = try! Realm()
        let allNews = realm.objects(NewModel.self)
        try! realm.write {
            realm.delete(allNews)
        }
        
        fetchNews()
    }
    
    // MARK: - Data Loading
    
    func restoreFromDatabase() {
        let realm = try! Realm()
        let restoredNews = Array(realm.objects(NewModel.self))
        
        news = restoredNews
        currentPage = restoredNews.count / pageSize + 1
        total = restoredNews.count
        isAllNewsLoaded = true
        isFetchInProgress = false
    }

    func fetchNews() {
        
        guard !isFetchInProgress, !isAllNewsLoaded else { return }
        
        isFetchInProgress = true
        
        APIManager().getCampaigns(page: currentPage, pageSize: pageSize, success: { [weak self] response in
            
            guard let strongSelf = self else { return }
            
            if var parsedResponse = Mapper<PagedNewsResponse>().map(JSONObject: response) {
                parsedResponse.page = strongSelf.currentPage
                
                strongSelf.currentPage += 1
                strongSelf.isFetchInProgress = false
                
                strongSelf.total = parsedResponse.total ?? 0
                strongSelf.news.append(contentsOf: parsedResponse.news ?? [])
                
                let realm = try! Realm()
                try! realm.write {
                    for itemToAdd in parsedResponse.news ?? [] {
                        
                        let itemToReplace = realm.object(ofType: NewModel.self, forPrimaryKey: itemToAdd.urlToOriginalPage)
                        
                        if  itemToReplace == nil {
                            realm.add(itemToAdd)
                        } else {
                            itemToReplace?.update(with: itemToAdd)
                        }
                    }
                }
                
                if parsedResponse.news?.isEmpty == true {
                    strongSelf.isAllNewsLoaded = true
                }
                
                if (parsedResponse.page ?? 1) > 1 {
                    let indexPathsToReload = strongSelf.calculateIndexPathsToReload(from: parsedResponse.news ?? [])
                    
                    strongSelf.delegate?.newsViewModelFetchingComplete(strongSelf, newIndexPathsToReload: indexPathsToReload)
                } else {
                    strongSelf.delegate?.newsViewModelFetchingComplete(strongSelf, newIndexPathsToReload: .none)
                }
            }
            
            
        }, failure: { [weak self] error in
            
            var errorReason = error.localizedDescription
            
            if let json = error.json, let errorMessage = json["message"].string {
                errorReason = errorMessage
            }
            
            guard let strongSelf = self else { return }
            strongSelf.isFetchInProgress = false
            
            // We not need to display a lot of warnings every time, as user is scroll tableView down.
            // Instead, we should just hide all unloaded news and display only news already cached.
            // "else if error.isNoInternetConnectionError" case will only be executed if user starts to load news with internet connection, and after that connection is interrupted
            if strongSelf.news.isEmpty == true {
                strongSelf.delegate?.newsViewModelFetchingFailed(strongSelf, reason: errorReason)
            } else if error.isNoInternetConnectionError {
                strongSelf.total = strongSelf.news.count
                strongSelf.isAllNewsLoaded = true
                strongSelf.delegate?.newsViewModelFetchingFailed(strongSelf, reason: errorReason)
            } else {
                strongSelf.delegate?.newsViewModelFetchingFailed(strongSelf, reason: errorReason)
            }
        })
        
    }
    
    private func calculateIndexPathsToReload(from fetchedNews: [NewModel]) -> [IndexPath] {
        let startIndex = news.count - fetchedNews.count
        let endIndex = startIndex + fetchedNews.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
