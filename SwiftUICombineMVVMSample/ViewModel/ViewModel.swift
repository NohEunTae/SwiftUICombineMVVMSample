//
//  ViewModel.swift
//  SwiftUICombineMVVMSample
//
//  Created by NohEunTae on 2021/01/12.
//

import Combine

final class ViewModel: ObservableObject  {
    
    // Related Input
    private let currentPage = CurrentValueSubject<Int, Never>(1)
    let filter = CurrentValueSubject<Filter, Never>(.newest)
    let purchaseTap = PassthroughSubject<Void, Never>()
    let likeTap = PassthroughSubject<Void, Never>()
    
    // Related Output
    @Published private(set) var items: [Data] = []
    @Published private(set) var like: Bool = false
    @Published var showingPurchageAlert = false
    @Published var showingLikeAlert = false

    private let initalPage = 1
    private var nextPage: Int?
    
    private var isNextPageExist: Bool {
        nextPage != nil && nextPage != initalPage
    }
    
    private var isFetchingNextPage: Bool {
        nextPage == currentPage.value
    }
    
    private var isFirstPage: Bool {
        currentPage.value == initalPage
    }
    
    private func resetPage() {
        currentPage.send(initalPage)
    }
    
    private func availableNextPageIfCan() -> Int? {
        (isNextPageExist && !isFetchingNextPage) ? nextPage : nil
    }
    
    func updatePageIfNeeded(item: Data) {
        if let nextPage = availableNextPageIfCan(),
            items.last == item {
            currentPage.send(nextPage)
        }
    }
    
    typealias DisposeBag = Set<AnyCancellable>
    private var bag = DisposeBag()
    
    func bind() {
        filter
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] _ in self?.resetPage() }
            .store(in: &bag)
        
        currentPage
            .compactMap({ [weak self] page -> (Int, Filter)? in
                guard let self = self else { return nil }
                return (page, self.filter.value)
            })
            .map(NetworkManager.shared.fetchItems)
            .switchToLatest()
            .sink { [weak self] result in
                switch result {
                case .success(let response):
                    self?.nextPage = response.meta.next_page
                    self?.setItems(using: response.meta.next_page, data: response.data)
                case .failure: return
                }
            }
            .store(in: &bag)
        
        purchaseTap
            .map(NetworkManager.shared.purchaseItem)
            .switchToLatest()
            .sink { [weak self] result in
                switch result {
                case .success: self?.showingPurchageAlert = true
                case .failure: return
                }
            }
            .store(in: &bag)
        
        likeTap
            .map(NetworkManager.shared.like)
            .switchToLatest()
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.like.toggle()
                    self.showingLikeAlert = true
                case .failure: return
                }
            }
            .store(in: &bag)
        
    }
    
    private func setItems(using nextPage: Int, data: [Data]) {
        nextPage == 2 || nextPage == 0
            ? self.items = data
            : self.items.append(contentsOf: data)
    }

}

