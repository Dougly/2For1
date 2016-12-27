//
//  ActionProtocol.swift
//  2for1
//
//  Created by Douglas Galante on 12/26/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import Foundation

protocol ActionProtocol {
    
    var players: [Player] { get set }
    var player: Player? { get set }
    var dice: [Die] { get set }
    var score: Int { get set }
    var drinks: Int { get set }
    var action: PlayerAction { get set }
    var turn: Int { get set }
    var dieAdded: Bool { get set }
    
}

