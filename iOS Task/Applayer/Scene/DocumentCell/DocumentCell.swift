//
//  DocumentCell.swift
//  Jisr
//
//  Created by Ali Bamohammad on 04/02/19.
//  Copyright © 2019 Clickapps. All rights reserved.
//

import UIKit

class DocumentCell: UITableViewCell {
    
    @IBOutlet var lblTitl: UILabel!
    @IBOutlet var lblAuther: UILabel!
    fileprivate var data: DocumentItemViewModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(with data: DocumentItemViewModel) {
        self.data = data
        setData()
    }
    
    func commonInit() {
        self.setFonts()
        
    }
}

//MARK: - setUp methods
extension DocumentCell {
    func setData() {
        lblTitl.text = data.title
        lblAuther.text = "By: " + data.auther
    }
    
    func setFonts() {
//
    }
    
}

//MARK: - Helper Methods
extension DocumentCell {
    public static var cellId: String {
        return "DocumentCell"
    }
    
    public static var bundle: Bundle {
        return Bundle(for: DocumentCell.self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: DocumentCell.cellId, bundle: DocumentCell.bundle)
    }
    
    public static func register(with tableView: UITableView) {
        tableView.register(DocumentCell.nib, forCellReuseIdentifier: DocumentCell.cellId)
    }
    
    public static func loadFromNib(owner: Any?) -> DocumentCell {
        return bundle.loadNibNamed(DocumentCell.cellId, owner: owner, options: nil)?.first as! DocumentCell
    }
    
    public static func dequeue(from tableView: UITableView, for indexPath: IndexPath, with data: DocumentItemViewModel) -> DocumentCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCell.cellId, for: indexPath) as! DocumentCell
        cell.configure(with: data)
        return cell
    }
}
