//
//  ViewModel+GetPage.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/31/20.
//  Copyright © 2020 Tuan Truong. All rights reserved.
// this class is pre defined and we modify it to match our requierments

import Combine

public struct GetPageInput<TriggerInput, Item , U> {
    let pageSubject: CurrentValueSubject<PagingInfo<Item>, Never>
    let errorTracker: ErrorTracker
    let loadTrigger: AnyPublisher<TriggerInput, Never>
    let reloadTrigger: AnyPublisher<TriggerInput, Never>
    let loadMoreTrigger: AnyPublisher<TriggerInput, Never>
    let fetchItems: (TriggerInput) -> AnyPublisher<PagingInfo<Item>, Error>    
    let reloadItems: (TriggerInput) -> AnyPublisher<PagingInfo<Item>, Error>
    let loadMoreItems: (TriggerInput) -> AnyPublisher<PagingInfo<Item>, Error>
    let mapper: (Item) -> U
    public init(pageSubject: CurrentValueSubject<PagingInfo<Item>, Never>,
                errorTracker: ErrorTracker,
                loadTrigger: AnyPublisher<TriggerInput, Never>,
                fetchItems: @escaping (TriggerInput) -> AnyPublisher<PagingInfo<Item>, Error>,
                reloadTrigger: AnyPublisher<TriggerInput, Never>,
                reloadItems: @escaping (TriggerInput) -> AnyPublisher<PagingInfo<Item>, Error>,
                loadMoreTrigger: AnyPublisher<TriggerInput, Never>,
                loadMoreItems: @escaping (TriggerInput) -> AnyPublisher<PagingInfo<Item>, Error>,
                mapper: @escaping (Item) -> U
    ) {
        self.pageSubject = pageSubject
        self.errorTracker = errorTracker
        self.loadTrigger = loadTrigger
        self.reloadTrigger = reloadTrigger
        self.loadMoreTrigger = loadMoreTrigger
        self.fetchItems = fetchItems
        self.reloadItems = reloadItems
        self.loadMoreItems = loadMoreItems
        self.mapper = mapper
    }
}


public extension GetPageInput{
    // swiftlint:disable:next line_length
    init(loadTrigger: AnyPublisher<TriggerInput, Never>,
         reloadTrigger: AnyPublisher<TriggerInput, Never>,
         loadMoreTrigger: AnyPublisher<TriggerInput, Never>,
         fetchItems: @escaping (TriggerInput) -> AnyPublisher<PagingInfo<Item>, Error>
         ) {
    
        self.init(pageSubject: CurrentValueSubject<PagingInfo<Item>, Never>(PagingInfo<Item>()),
                  errorTracker: ErrorTracker(),
                  loadTrigger: loadTrigger,
                  fetchItems: { x in fetchItems(x) },
                  reloadTrigger: reloadTrigger,
                  reloadItems: { fetchItems($0) },
                  loadMoreTrigger: loadMoreTrigger,
                  loadMoreItems: { x in fetchItems(x) },
                  mapper: {c in c as! U }
        )
    }
}


public struct GetPageResult<Item> {
    public var page: AnyPublisher<PagingInfo<Item>, Never>
    public var error: AnyPublisher<Error, Never>
    public var isLoading: AnyPublisher<Bool, Never>
    public var isReloading: AnyPublisher<Bool, Never>
    public var isLoadingMore: AnyPublisher<Bool, Never>
    
    // swiftlint:disable:next large_tuple
    public var destructured: (
        AnyPublisher<PagingInfo<Item>, Never>,
        AnyPublisher<Error, Never>,
        AnyPublisher<Bool, Never>,
        AnyPublisher<Bool, Never>,
        AnyPublisher<Bool, Never>) {
        return (page, error, isLoading, isReloading, isLoadingMore)
    }
    
    public init(page: AnyPublisher<PagingInfo<Item>, Never>,
                error: AnyPublisher<Error, Never>,
                isLoading: AnyPublisher<Bool, Never>,
                isReloading: AnyPublisher<Bool, Never>,
                isLoadingMore: AnyPublisher<Bool, Never>) {
        self.page = page
        self.error = error
        self.isLoading = isLoading
        self.isReloading = isReloading
        self.isLoadingMore = isLoadingMore
    }
}


public extension ViewModel {
    func getPage<Item>(input: GetPageInput<APIFetchType, Item, String>)
        -> GetPageResult<Item> {
            
        let loadingActivityTracker = ActivityTracker(false)
        let reloadingActivityTracker = ActivityTracker(false)
        let loadingMoreActivityTracker = ActivityTracker(false)
        let loadingMoreSubject = CurrentValueSubject<Bool, Never>(false)
            
        let loadItems = Publishers.Merge(
                input.loadTrigger.map { ScreenLoadingType.loading($0) },
                input.reloadTrigger.map { ScreenLoadingType.reloading($0) }
            )
            .filter { _ in
                !loadingActivityTracker.value
                    && !reloadingActivityTracker.value
                    && !(loadingMoreActivityTracker.value || loadingMoreSubject.value)
            }
            .map { triggerType -> AnyPublisher<PagingInfo<Item>, Never> in
                
                
                switch triggerType {
                case .loading(let triggerInput):
                    switch triggerInput{
                    case .fetch:
                        return input.fetchItems(.fetch(0))
                            .trackError(input.errorTracker)
                            .trackActivity(loadingActivityTracker)
                            .catch { _ in Empty() }
                            .eraseToAnyPublisher()
                    case .srearch( _ , let search):
                        return input.fetchItems(.srearch(1, search))
                            .trackError(input.errorTracker)
                            .trackActivity(loadingActivityTracker)
                            .catch { _ in Empty() }
                            .eraseToAnyPublisher()
                    }
                
                    
                case .reloading(let triggerInput):
                    switch triggerInput {
                    case .fetch(_):
                        
                        return input.reloadItems(.fetch(0))
                            .trackError(input.errorTracker)
                            .trackActivity(reloadingActivityTracker)
                            .catch { _ in Empty() }
                            .eraseToAnyPublisher()
                    case .srearch(_, let search):
                        
                        return input.reloadItems(.srearch(1, search))
                            .trackError(input.errorTracker)
                            .trackActivity(reloadingActivityTracker)
                            .catch { _ in Empty() }
                            .eraseToAnyPublisher()
                    }
                    
                }
            }
            .switchToLatest()
            .handleEvents(receiveOutput: { page in
                let newPage = PagingInfo<Item>(offset: page.offset,
                                                     items: page.items,hasMorePages: page.items.count < page.totalItems, totalItems: page.totalItems)
                
                input.pageSubject.send(newPage)
            })
            
        let loadMoreItems = input.loadMoreTrigger
            .filter { _ in
                !loadingActivityTracker.value
                    && !reloadingActivityTracker.value
                    && !(loadingMoreActivityTracker.value || loadingMoreSubject.value)
            }
            .handleEvents(receiveOutput: { _ in
                if input.pageSubject.value.items.isEmpty {
                    loadingMoreSubject.send(false)
                }
            })
            .filter { _ in !input.pageSubject.value.items.isEmpty }
            .map { triggerInput -> AnyPublisher<PagingInfo<Item>, Never> in
                
                switch triggerInput{
                    
                case .fetch(_):
                    let offset = input.pageSubject.value.items.count
                    return input.loadMoreItems(.fetch(offset))
                        .trackError(input.errorTracker)
                        .trackActivity(loadingMoreActivityTracker)
                        .catch { _ in Empty() }
                        .eraseToAnyPublisher()
                    
                case .srearch(_, let search):
                    
                    let page = input.pageSubject.value.page
                    
                    return input.loadMoreItems(.srearch(page + 1, search))
                    
                        .trackError(input.errorTracker)
                        .trackActivity(loadingMoreActivityTracker)
                        .catch { _ in Empty() }
                        .eraseToAnyPublisher()
                }
               
            }
            .switchToLatest()
            .filter { !$0.items.isEmpty || !$0.hasMorePages }
            .handleEvents(receiveOutput: { page in
                let currentPage = input.pageSubject.value
                let items = currentPage.items + page.items
            
                
                let newPage = PagingInfo<Item>(offset: page.offset + items.count,
                                                     items: items,
                                                     hasMorePages: items.count < page.totalItems
                                                     ,totalItems: page.totalItems)
                
                input.pageSubject.send(newPage)
            })
            
        let page = Publishers.Merge(loadItems, loadMoreItems)
           
            .map { _ in input.pageSubject.value }
            .eraseToAnyPublisher()
        
        let error = input.errorTracker.eraseToAnyPublisher()
        let isLoading = loadingActivityTracker.eraseToAnyPublisher()
        let isReloading = reloadingActivityTracker.eraseToAnyPublisher()
        let isLoadingMore = loadingMoreActivityTracker.eraseToAnyPublisher()
        
        return GetPageResult(
            page: page,
            error: error,
            isLoading: isLoading,
            isReloading: isReloading,
            isLoadingMore: isLoadingMore
        )
    }
}



                          
