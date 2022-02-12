//
//  DocumentsListVC.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 11/02/2022.
//

import UIKit
import Combine

class DocumentDetailsVC: UIViewController {
    
    @IBOutlet weak var authersTableView: UITableView!
    @IBOutlet weak var ISBNSTableView: UITableView!
    fileprivate var data:DocumentItemViewModel!
    
    
    private let cancelBag = CancelBag()
//    private var output: DocumentDetailsVM.Output!
//    private let loadTrigger = PassthroughSubject<Void, Never>()
//    private let reloadTrigger = PassthroughSubject<Void, Never>()
    
    @Published var authers:[String] = []
    @Published var ISBNS:[String] = []
    var tapGestureRecognizer: UITapGestureRecognizer!

    weak var delegate:SearchDelegate?
    
    @IBOutlet weak var authersTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ISBNSTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.navigationBarTapped(_:)))

        setUpVew()
//        loadTrigger.send()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authersTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        ISBNSTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
            self.navigationController?.navigationBar.addGestureRecognizer(tapGestureRecognizer)
            tapGestureRecognizer.cancelsTouchesInView = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        authersTableView.removeObserver(self, forKeyPath: "contentSize")
        ISBNSTableView.removeObserver(self, forKeyPath: "contentSize")
        self.navigationController?.navigationBar.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.authersTableView && keyPath == "contentSize" {
                
                authersTableViewHeight.constant = authersTableView.contentSize.height + 2
            }
            
            if obj == self.ISBNSTableView && keyPath == "contentSize" {
                
                ISBNSTableViewHeight.constant = ISBNSTableView.contentSize.height + 2
            }
        }
    }
    
    func setUpVew() {
        
        ISBNSCell.register(with: ISBNSTableView)
        
        authersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "AutherCell")
        authersTableView.delegate = self
        
        authers = data.authers
        ISBNS = data.isbns
//        output.$document
//            .receive(on: RunLoop.main)
//            .sink { _ in
//                print("complete ")
//            } receiveValue: {[unowned self] output in
//                ISBNS = output?.ISBNS ?? []
//            }
//            .store(in: cancelBag)
        
        $ISBNS
            .sink(receiveValue: ISBNSTableView.items { tableView, indexPath, item in
                
                let cell = ISBNSCell.dequeue(from: tableView, for: indexPath, with: item)
                return cell
            })
            .store(in: cancelBag)
        
        $authers
            .sink(receiveValue:
                    authersTableView.items { tableView, indexPath, item in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "AutherCell", for: indexPath)
                            cell.textLabel?.text = item
                            return cell
            })
            .store(in: cancelBag)
    }
    
    /// since we don't have access to init function we use this function to pass valuee
    ///
    /// - Parameter data: ddocument details.
    /// - Returns: void`.
    
    func config(with data:DocumentItemViewModel, viewModel:DocumentDetailsVM) {
        self.data = data
        
        // to use details API un commet flowing code
//
//        let input = DocumentDetailsVM.Input(
//            loadTrigger: loadTrigger.eraseToAnyPublisher(),
//            reloadTrigger: reloadTrigger.eraseToAnyPublisher(),
//            id: data.key
//        )
//
//        output = viewModel.perform(input, cancelBag: cancelBag)
    }
    
    @IBAction func LoadMore() {
    }
    
    
    
    @objc func navigationBarTapped(_ sender: UITapGestureRecognizer){

        // To Make sure back button is not tapped.
        let location = sender.location(in: navigationController?.navigationBar)
        let hitedView = navigationController?.navigationBar.hitTest(location, with: nil)

        guard !(hitedView is UIControl) else { return }

        // Here, we know that the user wanted to tap the navigation bar and not a control inside it
        
        delegate?.searchBy(values: SearchDocuemtFilds(title:data.title))
        navigationController?.popViewController(animated: true)

    }
}
extension DocumentDetailsVC :UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == authersTableView {
            delegate?.searchBy(values: SearchDocuemtFilds(auther:authers[indexPath.row]))
            navigationController?.popViewController(animated: true)
        }
    }
}
//MARK: - Helper Methods
extension DocumentDetailsVC {
    /**
    /// this function uses to crate object of this ViewController
    
     - Warning: use config function to pass valuse to VC
     - Parameter data: document details.
     - Returns: object of type DocumentDetailsVC`.
    */
    static func fromStoryboard(with data:DocumentItemViewModel) -> DocumentDetailsVC {
        
        let viewController:DocumentDetailsVC = UIStoryboard.main.instantiateViewController(withIdentifier: "DocumentDetailsVC") as! DocumentDetailsVC
        viewController.config(with: data , viewModel:DocumentDetailsVM(getDocumentsUC: GetDocumentsUC(repo: DocumentRepoImp())))
        
        return viewController
    }
}



