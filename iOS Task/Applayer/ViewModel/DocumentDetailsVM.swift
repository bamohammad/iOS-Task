//
//  DocumentsListVM.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 10/02/2022.
//

import Foundation
import Combine

class DocumentDetailsVM:ViewModel {
    
    struct Input {
        let loadTrigger: AnyPublisher<Void, Never>
        let reloadTrigger: AnyPublisher<Void, Never>
        let id:String
    }
    
    final class Output: ObservableObject {
        @Published var document:DocumentModel!
        @Published var isLoading = false
        @Published var isReloading = false
        @Published var alert = AlertMessage()
    }
    
    private var getDocumentsUC:GetDocumentsUC
    init(getDocumentsUC:GetDocumentsUC) {
        self.getDocumentsUC = getDocumentsUC
    }
    
    
    /**
     /// this function uses to crate output object of type ObservableObject that we can uses to fetch data and handel errors
     /// this function used to get one item
     
     - Warning: use this function to create output object and after that use trigers to fetch data
     - Parameter input: Input contains trigers and any values neet to pass to this function .
     - Parameter cancelBag: CancelBag to store subscriptions.
     - Returns: Output `.
     */
    
    func perform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        let error = ErrorTracker()
        let isLoading = ActivityTracker(false)
        let isReloading = ActivityTracker(false)

        
        Publishers.Merge(
                input.loadTrigger.map { ScreenLoadingType.loading($0) },
                input.reloadTrigger.map { ScreenLoadingType.reloading($0) }
            )
            .filter { _ in
                !isLoading.value
                    && !isReloading.value
                    
            }.map { _ in
                self.getDocumentsUC.getDocument(id: input.id)
                    .trackError(error)
                    .trackActivity(isLoading)
                    .trackActivity(isReloading)
                    .catch { _ in Empty() }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink {
                output.document = $0
            }
            .store(in: cancelBag)
        
        error
            .receive(on: RunLoop.main)
            .map { AlertMessage(error: $0) }
            .assign(to: \.alert, on: output)
            .store(in: cancelBag)
        
        isLoading
            .assign(to: \.isLoading, on: output)
            .store(in: cancelBag)
        
        isReloading
            .assign(to: \.isReloading, on: output)
            .store(in: cancelBag)
            
        return output
    }
    
}
