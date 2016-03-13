//
//  AutocompleteDelegate.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/10/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit

public protocol AutocompleteDelegate: class {
    func autoCompleteTextField() -> UITextField
    func autoCompleteThreshold(textField: UITextField) -> Int
    func autoCompleteItemsForSearchTerm(term: String) -> [AutocompleteCellData]
    func autoCompleteFrame() -> CGRect

    func nibForAutoCompleteCell() -> UINib
    func heightForCells() -> CGFloat
    func getCellDataAssigner() -> ((UITableViewCell, AutocompleteCellData) -> Void)
}

public extension AutocompleteDelegate {
    func nibForAutoCompleteCell() -> UINib {
        return UINib(nibName: "DefaultAutoCompleteCell", bundle: NSBundle(forClass: AutoCompleteViewController.self))
    }

    func heightForCells() -> CGFloat {
        return 60
    }

    func getCellDataAssigner() -> ((UITableViewCell, AutocompleteCellData) -> Void) {
        let assigner: ((UITableViewCell, AutocompleteCellData) -> Void) = {
            (cell: UITableViewCell, cellDatadata: AutocompleteCellData) -> Void in
            if let cell = cell as? AutoCompleteCell {
                cell.textImage = cellDatadata
            }
        }
        return assigner
    }
}
