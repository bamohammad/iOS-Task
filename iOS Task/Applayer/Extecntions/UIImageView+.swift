//
//  UIImageView+.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 12/02/2022.
//

import UIKit
import Combine

extension UIImageView {
    func downloadImage(from url: URL , placeholder:UIImage?, cancelBag: CancelBag) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map {
                UIImage(data: $0.data)
                
            }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.image = $0 != nil ? $0 : placeholder
            }
            .store(in: cancelBag)
    }
}
