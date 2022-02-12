//
//  UIStoryboard+.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 12/02/2022.
//

import UIKit
extension UITableView {
    
    func items<Element>(_ builder: @escaping (UITableView, IndexPath, Element) -> UITableViewCell) -> ([Element]) -> Void {
        let dataSource = CombineTableViewDataSource(builder: builder)
        self.dataSource = dataSource
        return { items in
            dataSource.pushElements(items, to: self)
        }
    }
    
    func setLoadingView() {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let loaderView = UIActivityIndicatorView(style: .medium)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.addSubview(loaderView)
        
        loaderView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        loaderView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        
        loaderView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        loaderView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        loaderView.startAnimating()
        
        self.backgroundView = emptyView
    }
    
    func setNotFoundView(message: String) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let messageLabel = UILabel()
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false        
        emptyView.addSubview(messageLabel)
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        
        messageLabel.textAlignment = .center
        messageLabel.text = message
        
        self.backgroundView = emptyView
        
    }
    func restore(_ separatorStyle: UITableViewCell.SeparatorStyle = .none) {
        self.backgroundView = nil
        
    }
}
