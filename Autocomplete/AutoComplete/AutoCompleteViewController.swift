//
//  AutoCompleteViewController.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/6/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit
public protocol AutocompleteDelegate {
    func autoCompleteTextField() -> UITextField
    func autoCompleteThreshold(textField: UITextField) -> Int
    func autoCompleteItemsForSearchTerm(term: String) -> [(text: String, image: UIImage?)]
}



public class AutoCompleteViewController: UIViewController {
    //MARK: - outlets
    @IBOutlet private weak var tableView: UITableView!

    //MARK: - private properties
    internal var autocompleteItem: [(text: String, image: UIImage?)]?
    private var textField: UITextField?
    private var autocompleteThreshold: Int?

    //MARK: - public properties
    public var delegate: AutocompleteDelegate?

    //MARK: - view life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.hidden = true
        self.textField = self.delegate!.autoCompleteTextField()

        self.textField?.addTarget(self, action: "textDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.autocompleteThreshold = self.delegate!.autoCompleteThreshold(self.textField!)
    }

    //MARK: - private methods
    @objc func textDidChange(textField: UITextField) {
        let numberOfCharacters = textField.text?.characters.count
        if let numberOfCharacters = numberOfCharacters {
            if numberOfCharacters > self.autocompleteThreshold! {
                self.view.hidden = false
                guard let searchTerm = textField.text else { return }
                self.autocompleteItem = self.delegate!.autoCompleteItemsForSearchTerm(searchTerm)
                let animationDuration: NSTimeInterval = 0.3
                UIView.animateWithDuration(animationDuration,
                    delay: 0.0,
                    options: .CurveEaseInOut,
                    animations: { () -> Void in
                        self.view.frame.size.height = CGFloat(self.autocompleteItem!.count) * CGFloat(44.0)
                    },
                    completion: nil)

                UIView.transitionWithView(self.tableView,
                    duration: 0.3,
                    options: .TransitionCrossDissolve,
                    animations: { () -> Void in
                        self.tableView.reloadData()
                    },
                    completion: nil)

            } else {
                self.view.hidden = true
            }
        }
    }

}
