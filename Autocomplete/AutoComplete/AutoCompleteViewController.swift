//
//  AutoCompleteViewController.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/6/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit

let AutocompleteCellReuseIdentifier = "autocompleteCell"

open class AutoCompleteViewController: UIViewController {
    //MARK: - outlets
    @IBOutlet fileprivate weak var tableView: UITableView!

    //MARK: - internal items
    internal var autocompleteItems: [AutocompletableOption]?
    internal var cellHeight: CGFloat?
    internal var cellDataAssigner: ((_ cell: UITableViewCell, _ data: AutocompletableOption) -> Void)?
    internal var textField: UITextField?
    internal let animationDuration: TimeInterval = 0.3
    internal var currentSet = Set<String>()
    internal var closing: Bool = false

    //MARK: - private properties
    fileprivate var autocompleteThreshold: Int?
    fileprivate var maxHeight: CGFloat = 0
    fileprivate var height: CGFloat = 0

    //MARK: - public properties
    open weak var delegate: AutocompleteDelegate?

    //MARK: - view life cycle
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.view.isHidden = true
        self.textField = self.delegate!.autoCompleteTextField()
        if let vc = delegate as? UIViewController {
            let textViewFrame = self.textField!.convert(self.textField!.frame, to: vc.view)

            self.height = self.delegate!.autoCompleteHeight()
            
            let viewOffset: CGFloat = 24.0
            let viewWidth = UIScreen.main.bounds.width - 24.0 * 2
            
            self.view.frame = CGRect(x: viewOffset,
                y: textViewFrame.maxY - 3,
                width: viewWidth,
                height: self.height)

            self.tableView.register(self.delegate!.nibForAutoCompleteCell(), forCellReuseIdentifier: AutocompleteCellReuseIdentifier)

            self.textField?.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), for: UIControl.Event.editingChanged)
            self.autocompleteThreshold = self.delegate!.autoCompleteThreshold(self.textField!)
            self.cellDataAssigner = self.delegate!.getCellDataAssigner()

            self.cellHeight = self.delegate!.heightForCells()
            // not to go beyond bound height if list of items is too big
            self.maxHeight = UIScreen.main.bounds.height - textViewFrame.minY
            
            
        }
    }
    
    public func adjustViewsLocation() {
        if !closing {
            if let vc = delegate as? UIViewController {
                let textViewFrame = self.textField!.convert(self.textField!.frame, to: vc.view)
                let viewOffset: CGFloat = 24.0
                let viewWidth = UIScreen.main.bounds.width - 24.0 * 2
                
                self.height = self.delegate!.autoCompleteHeight()
                self.view.frame = CGRect(x: viewOffset,
                                         y: textViewFrame.maxY - 3,
                                         width: viewWidth,
                                         height: self.height)
                self.maxHeight = self.delegate!.autoCompleteHeight()
                self.view.customShapeForAutocomplete(radius: 3.0)
            }
        }
    }

    //MARK: - private methods
    @objc func textDidChange(_ textField: UITextField) {
        self.closing = false
        let numberOfCharacters = textField.text?.count
        if let numberOfCharacters = numberOfCharacters {
            if numberOfCharacters > self.autocompleteThreshold! {
                guard let searchTerm = textField.text else { return }
                let newItems = self.delegate!.autoCompleteItemsForSearchTerm(searchTerm)
                let oldItems = self.autocompleteItems
                
                self.view.isHidden = newItems.count == 0
                
                self.autocompleteItems = newItems
                UIView.animate(withDuration: self.animationDuration,
                    delay: 0.0,
                    options: UIView.AnimationOptions(),
                    animations: { () -> Void in
                        self.view.frame.size.height = min(
                            CGFloat(self.autocompleteItems!.count) * CGFloat(self.cellHeight!),
                            self.maxHeight,
                            self.height
                        )
                    },
                    completion: nil)
                
                var removedIndexPaths = [IndexPath]()
                let newSet = Set(newItems.map{ $0.text })
                
                if let autocompleteItems = oldItems {
                    for i in stride(from: 0, to: autocompleteItems.count, by: 1) {
                        if !newSet.contains(autocompleteItems[i].text) {
                            removedIndexPaths.append(IndexPath(row: i, section: 0))
                        }
                    }
                }
                
                var insertedIndexPaths = [IndexPath]()
                for i in stride(from: 0, to: newItems.count, by: 1) {
                    if !currentSet.contains(newItems[i].text) {
                        insertedIndexPaths.append(IndexPath(row: i, section: 0))
                    }
                }
                
                currentSet = newSet
                
                self.tableView.beginUpdates()
                if newSet.count != 0 && self.tableView.numberOfSections == 0 {
                    self.tableView.insertSections(IndexSet(integer: 0), with: self.delegate?.animationForInsertion() ?? .fade)
                }
                
                if newSet.count == 0 && self.tableView.numberOfSections > 0 {
                    self.tableView.deleteSections(IndexSet(integer: 0), with: self.delegate?.animationForInsertion() ?? .fade)
                }
                
                self.tableView.insertRows(at: insertedIndexPaths, with: self.delegate?.animationForInsertion() ?? .fade)
                self.tableView.deleteRows(at: removedIndexPaths, with: self.delegate?.animationForInsertion() ?? .fade)
                self.tableView.endUpdates()
                
            } else {
                self.view.isHidden = true
            }
        }
    }

}

extension UIView {
    
    func customShapeForAutocomplete(radius: CGFloat) {
        self.layer.mask = nil
        let width = self.bounds.width
        let height = self.bounds.height
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addQuadCurve(to: CGPoint(x: radius, y: radius), controlPoint: CGPoint(x: 0, y: radius))
        path.addLine(to: CGPoint(x: width - radius, y: radius))
        path.addQuadCurve(to: CGPoint(x: width, y: 0), controlPoint: CGPoint(x: width, y: radius))
        path.addLine(to: CGPoint(x: width, y: height - radius))
        path.addQuadCurve(to: CGPoint(x: width - radius, y: height), controlPoint: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: radius, y: height))
        path.addQuadCurve(to: CGPoint(x: 0, y: height - radius), controlPoint: CGPoint(x: 0, y: height))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layer.masksToBounds = false
    }
}

