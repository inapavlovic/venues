//
//  FileManager.swift
//  users
//
//  Created by Ina Statkic on 31/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

extension FileManager {
    
    /// Home Directory
    public var homeURL: URL? {
        return URL(fileURLWithPath: NSHomeDirectory())
    }
    
    /// Document Directory
    /// User data
    public var documentsURL: URL? {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
    
    /// `Library/Application support/` directory
    /// Support files hidden from the user
    public var applicationSupportURL: URL? {
        let paths = urls(for: .applicationSupportDirectory, in: .userDomainMask)
        return paths.first
    }
}
