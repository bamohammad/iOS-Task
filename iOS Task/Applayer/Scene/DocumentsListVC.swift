//
//  DocumentsListVC.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 11/02/2022.
//

import UIKit
import Combine

class DocumentsListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var output: DocumentsListVM.Output!
    private let cancelBag = CancelBag()
    private let loadTrigger = PassthroughSubject<APIFetchType, Never>()
    private let reloadTrigger = PassthroughSubject<APIFetchType, Never>()
    private let loadMoreTrigger = PassthroughSubject<APIFetchType, Never>()
    
    private var documents = [DocumentItemViewModel]()
    private let selectDocumentTrigger = PassthroughSubject<IndexPath, Never>()
        
    private var refreshControl = UIRefreshControl()
    private   var searchBar:UISearchBar = UISearchBar()
    
    private var searchValues = SearchDocuemtFilds()
    private let spinner = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVew()
    }
    
    /**
    /// this function uses to crate object of this ViewController
    
     - Warning: use config function to pass valuse to VC
     - Parameter data: document details.
     - Returns: object of type DocumentDetailsVC`.
    */
    
    func config(with documentsListVM:DocumentsListVM) {
        
        let input = DocumentsListVM.Input(
            loadTrigger: loadTrigger.eraseToAnyPublisher(),
            reloadTrigger: reloadTrigger.eraseToAnyPublisher(),
            loadMoreTrigger: loadMoreTrigger.eraseToAnyPublisher()
            
        )
        output = documentsListVM.perform(input, cancelBag: cancelBag)
    }
    
    /**
    /// use this function to prepare views and asign values
    
     - Warning: use config function to pass valuse to VC
     - Parameter void.
     - Returns: object of type DocumentDetailsVC`.
    */
    func setUpVew() {
        DocumentCell.register(with: tableView)
        loadTrigger.send(.fetch())
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
       
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchAction(_:)))
        
        self.navigationItem.leftBarButtonItem = search
        navigationItem.hidesBackButton = true
                
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

        handelDataChanges()
    }
    
    /**
    /// use this function to handel changes comes from APIs and asign this to UI
     - Parameter void.
     - Returns: object of type DocumentDetailsVC`.
    */
    
    func handelDataChanges() {
        output.$alert
            .sink ( receiveValue: { [unowned self] alert in
                if alert.isShowing {
                self.showAlert(alert) {}
                }
                
            })
            .store(in: cancelBag)
        
        output.$documents
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: tableView.items { tableView, indexPath, item in
                
                let cell = DocumentCell.dequeue(from: tableView, for: indexPath, with: item)
                return cell
            })
            .store(in: cancelBag)
        
        output.$isLoading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] value in
                if self.output.documents.isEmpty {
                    if value {
                    self.tableView.setLoadingView()
                    } else {
                        self.tableView.setNotFoundView(message: "No documents")
                    }
                } else {
                    self.tableView.restore()
                }
            })
            .store(in: cancelBag)
        
        output.$isReloading
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { coom in
                if self.output.documents.isEmpty {
                self.tableView.setNotFoundView(message: "No documents")
                }
            }, receiveValue: {
                if $0 == false {
                    self.refreshControl.endRefreshing()
                }})
        
            .store(in: cancelBag)
        
        output.$isLoadingMore
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] value in
                if value {
                    self.tableView.tableFooterView = spinner
                    self.tableView.tableFooterView?.isHidden = false
                }else {
                    self.tableView.tableFooterView = nil
                    self.tableView.tableFooterView?.isHidden = true
                }
                
            })
            .store(in: cancelBag)
        
    }
    
    @objc private func refresh(_ sender: Any) {
        reloadTrigger.send(getAPIFetchType())
    }
    
    @objc private func searchAction(_ sender: Any) {

        let vc = SearchVC.fromStoryboard(with: searchValues)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    private func getAPIFetchType() -> APIFetchType {
        if searchValues.title != nil || searchValues.auther != nil || searchValues.query != nil  {
            return .srearch(0,searchValues)
        }
        return .fetch()
    }
}

extension DocumentsListVC :UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DocumentDetailsVC.fromStoryboard(with: output.documents[indexPath.row])
        vc.delegate = self
        vc.title = output.documents[indexPath.row].title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 2 {
            loadMoreTrigger.send(getAPIFetchType())
        }
    }

}

extension DocumentsListVC :SearchDelegate{
    func searchBy(values: SearchDocuemtFilds) {
        searchValues = values
        output.documents.removeAll()
        loadTrigger.send(getAPIFetchType())
    }
   
}
//MARK: - Helper Methods
extension DocumentsListVC {
    
    /**
    /// this function uses to crate object of this ViewController
    
     - Warning: use config function to pass valuse to VC
     - Parameter data: document details.
     - Returns: object of type DocumentDetailsVC`.
    */
    static func fromStoryboard() -> DocumentsListVC {
        let viewController:DocumentsListVC = UIStoryboard.main.instantiateViewController(withIdentifier: "DocumentsListVC") as! DocumentsListVC
        viewController.config(with: DocumentsListVM(getDocumentsUC: GetDocumentsUC(repo: DocumentRepoImp())))
        return viewController
    }
}





