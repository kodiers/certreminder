//
//  UITableViewExtension.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 28/02/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import UIKit


extension UITableView {
    // Simple extension to get all cells in table view
    func getAllCells() -> [UITableViewCell] {
        var cells = [UITableViewCell]()
        for i in 0...self.numberOfSections - 1 {
            for j in 0...self.numberOfRows(inSection: i) - 1 {
                if let cell = self.cellForRow(at: IndexPath(row: j, section: i)) {
                    cells.append(cell)
                }
            }
        }
        return cells
    }
}
