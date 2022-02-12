//
//  ISBNSCell.swift
//  Jisr
//
//  Created by Ali Bamohammad on 04/02/19.
//  Copyright © 2019 Clickapps. All rights reserved.
//

import UIKit

class ISBNSCell: UITableViewCell {
    
    @IBOutlet var lblTitl: UILabel!
    @IBOutlet var imgConver: UIImageView!
    fileprivate var data: String!
    private let cancelBag = CancelBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(with data: String) {
        self.data = data
        setData()
    }
    
    func commonInit() {
        self.setFonts()
        
    }
}

//MARK: - setUp methods
extension ISBNSCell {
    func setData() {
        lblTitl.text = data
        if let url = URL(string: "https://covers.openlibrary.org/b/isbn/\(data!).jpg?default=false") {
            imgConver.downloadImage(from: url, placeholder: UIImage(named: "book-cover-placeholder") , cancelBag:cancelBag)
        }
    }
    
    func setFonts() {
//
    }
    
}

//MARK: - Helper Methods
extension ISBNSCell {
    public static var cellId: String {
        return "ISBNSCell"
    }
    
    public static var bundle: Bundle {
        return Bundle(for: ISBNSCell.self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: ISBNSCell.cellId, bundle: ISBNSCell.bundle)
    }
    
    public static func register(with tableView: UITableView) {
        tableView.register(ISBNSCell.nib, forCellReuseIdentifier: ISBNSCell.cellId)
    }
    
    public static func loadFromNib(owner: Any?) -> ISBNSCell {
        return bundle.loadNibNamed(ISBNSCell.cellId, owner: owner, options: nil)?.first as! ISBNSCell
    }
    
    public static func dequeue(from tableView: UITableView, for indexPath: IndexPath, with data: String) -> ISBNSCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ISBNSCell.cellId, for: indexPath) as! ISBNSCell
        cell.configure(with: data)
        return cell
    }
}
