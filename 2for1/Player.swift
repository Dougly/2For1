//
//  Player.swift
//  2for1
//
//  Created by Douglas Galante on 12/25/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import Foundation

class Player {

    var tag: String
    let firstName: String
    let lastName: String
    
    init(tag: String, firstName: String, lastName: String) {
        self.tag = tag
        self.firstName = firstName
        self.lastName = lastName
    }
}
