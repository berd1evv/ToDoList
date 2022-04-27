//
//  EditCellViewModel.swift
//  To-Do-List
//
//  Created by Eldiiar on 27/4/22.
//

import Foundation

protocol EditCellProtocol {
    var isRead: Bool { get set }
}

class EditCellViewModel: EditCellProtocol {
    var isRead = false
    
}
