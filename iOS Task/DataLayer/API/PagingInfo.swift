//
//  PagingInfo.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/14/20.
//  Copyright © 2020 Tuan Truong. All rights reserved.
//

public struct PagingInfo<T> {
    public var offset: Int
    public var page: Int
    public var items: [T]
    public var hasMorePages: Bool
    public var totalItems: Int
    public var itemsPerPage: Int
    public var totalPages: Int
    
    public init(offset: Int,
                page: Int,
                items: [T],
                hasMorePages: Bool,
                totalItems: Int,
                itemsPerPage: Int,
                totalPages: Int) {
        self.offset = offset
        self.page = page
        self.items = items
        self.hasMorePages = hasMorePages
        self.totalItems = totalItems
        self.itemsPerPage = itemsPerPage
        self.totalPages = totalPages
    }
    

    
    public init(page: Int, items: [T]) {
        self.init(offset: 0,
                  page:page,
                  items: items,
                  hasMorePages: true,
                  totalItems: 0,
                  itemsPerPage: 0,
                  totalPages: 0)
    }
    
    public init(offset: Int, items: [T] ,hasMorePages:Bool = true, totalItems:Int) {
        self.init(offset: offset,
                  page:1,
                  items: items,
                  hasMorePages: hasMorePages,
                  totalItems: totalItems,
                  itemsPerPage: 0,
                  totalPages: 0)
    }
    
    public init() {
        self.init(offset: 0,
                  page: 1,
                  items: [],
                  hasMorePages: true,
                  totalItems: 0,
                  itemsPerPage: 0,
                  totalPages: 0)
    }
}

extension PagingInfo: Equatable where T: Equatable {
    
}
