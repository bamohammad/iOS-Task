//
//  SearchVC.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 12/02/2022.
//

import UIKit
import Combine

protocol SearchDelegate: AnyObject {
    func searchBy(values:SearchDocuemtFilds)
}

class SearchVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtAuther: UITextField!
    @IBOutlet weak var txtQuery: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    fileprivate var data:SearchDocuemtFilds!
    weak var delegate:SearchDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpVew()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func setUpVew() {
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(resetAction(_:)))
        cancel.title = "reset"
        self.navigationItem.rightBarButtonItem = cancel

        txtTitle.text = data.title
        txtAuther.text = data.auther
        txtQuery.text = data.query
    }
    
    func config(with data:SearchDocuemtFilds) {
        self.data = data
    }
    
   @IBAction func searchAction(_ sender: Any) {

        var searchValues = SearchDocuemtFilds()
        if let title =  txtTitle.text , !title.isEmpty {
            searchValues.title = title
        }
        
        if let auther =  txtAuther.text , !auther.isEmpty {
            searchValues.auther = auther
        }
        
        if let query =  txtQuery.text , !query.isEmpty {
            searchValues.query = query
        }
        
        delegate?.searchBy(values: searchValues)
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func resetAction(_ sender: Any) {


        delegate?.searchBy(values: SearchDocuemtFilds())
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func keyboardWillShowNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            if let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let frame = frameValue.cgRectValue

                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.size.height, right: 0)
            }
        }
    }
    
    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
//MARK: - Helper Methods
extension SearchVC {
    /**
    /// this function uses to crate object of this ViewController
    
     - Warning: use config function to pass valuse to VC
     - Parameter data: document details.
     - Returns: object of type DocumentDetailsVC`.
    */
    static func fromStoryboard(with data:SearchDocuemtFilds) -> SearchVC {
        
        let viewController:SearchVC = UIStoryboard.main.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        viewController.config(with: data)
        
        return viewController
    }
}
