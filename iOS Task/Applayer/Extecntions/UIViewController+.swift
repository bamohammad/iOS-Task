//
//  UIStoryboard+.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 12/02/2022.
//

import UIKit
import Combine

extension UIViewController {
    func showAlert(_ alert: AlertMessage, completion: (() -> Void)? = nil) {
        let ac = UIAlertController(title: alert.title,
                                   message: alert.message,
                                   preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
    
}
