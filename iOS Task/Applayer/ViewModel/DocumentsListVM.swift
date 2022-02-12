//
//  DocumentsListVM.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 10/02/2022.


import Foundation
import Combine

class DocumentsListVM:ViewModel {
    
    struct Input {
        let loadTrigger:AnyPublisher<APIFetchType, Never>
        let reloadTrigger: AnyPublisher<APIFetchType, Never>
        let loadMoreTrigger: AnyPublisher<APIFetchType, Never>
    }
    
    final class Output: ObservableObject {
        @Published var documents = [DocumentItemViewModel]()
        @Published var isLoading = false
        @Published var isReloading = false
        @Published var isLoadingMore = false
        @Published var alert = AlertMessage()
    }
    
    private var getDocumentsUC:GetDocumentsUC
    init(getDocumentsUC:GetDocumentsUC) {
        self.getDocumentsUC = getDocumentsUC
    }
    
    /**
     /// this function uses to crate output object of type ObservableObject that we can uses to fetch data and handel errors
     /// this function used tp get list of items with ablity to reload and load more items
     
     - Warning: use this function to create output object and after that use trigers to fetch data
     - Parameter input: Input contains trigers and any values neet to pass to this function .
     - Parameter cancelBag: CancelBag to store subscriptions.
     - Returns: Output `.
     */
    
    func perform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        let getPageInput = GetPageInput<APIFetchType,DocumentItemViewModel,String>(loadTrigger: input.loadTrigger,
                                                                                   reloadTrigger: input.reloadTrigger,
                                                                                   loadMoreTrigger: input.loadMoreTrigger,
                                                                                   fetchItems: getDocumentsUC.getDocuments)
        
        
        
        let (page, error, isLoading, isReloading, isLoadingMore) = getPage(input: getPageInput).destructured
        
        
        page
            .map { $0.items }
            .assign(to: \.documents, on: output)
            .store(in: cancelBag)
        error
            .receive(on: RunLoop.main)
            .map { AlertMessage(error: $0) }
            .assign(to: \.alert, on: output)
            .store(in: cancelBag)
        
        isLoading
            .map{$0}
            .assign(to: \.isLoading, on: output)
            .store(in: cancelBag)
        
        isReloading
            .assign(to: \.isReloading, on: output)
            .store(in: cancelBag)
        
        isLoadingMore
            .assign(to: \.isLoadingMore, on: output)
            .store(in: cancelBag)
        
        return output
    }
    
}
