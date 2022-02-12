//
//  DocumentsListVC.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 11/02/2022.
//

import UIKit
import Combine


class SpalshVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(goToHome), with: nil, afterDelay: 2)
    }
    
    @objc func goToHome() {
        let vc = DocumentsListVC.fromStoryboard()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



