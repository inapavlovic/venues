//
//  Collection.swift
//  vennu
//
//  Created by Ina Statkic on 06/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    public subscript(contains index: Index) -> Iterator.Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}
