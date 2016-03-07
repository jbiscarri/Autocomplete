//
//  ViewController.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/6/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var countriesTextField: UITextField!
    @IBOutlet weak var autocompleteContainerView: UIView!
    var autoCompleteViewController: AutoCompleteViewController!


    let countriesList = countries
    var isFirstLoad: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if self.isFirstLoad {
            self.isFirstLoad = false
            self.autoCompleteViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("autocompleteScene") as! AutoCompleteViewController

            self.autoCompleteViewController.delegate = self
            
            self.autoCompleteViewController.willMoveToParentViewController(self)
            self.addChildViewController(self.autoCompleteViewController)
            self.autoCompleteViewController.didMoveToParentViewController(self)

            self.autoCompleteViewController.view.frame.size.width = self.autocompleteContainerView.frame.size.width
            self.autoCompleteViewController.view.willMoveToSuperview(self.autocompleteContainerView)
            self.autocompleteContainerView.addSubview(self.autoCompleteViewController.view)
            self.autoCompleteViewController.view.didMoveToSuperview()
        }
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: AutocompleteDelegate {
    func autoCompleteTextField() -> UITextField {
        return self.countriesTextField
    }
    func autoCompleteThreshold(textField: UITextField) -> Int {
        return 1
    }

    func autoCompleteItemsForSearchTerm(term: String) -> [(text: String, image: UIImage?)] {
        let filteredCountries = self.countriesList.filter { (country) -> Bool in
            return country.lowercaseString.containsString(term.lowercaseString)
        }

        let countriesAndFlags: [(text: String, image: UIImage?)] = filteredCountries.map { (var country) -> (String, UIImage?) in
            country.replaceRange(country.startIndex...country.startIndex, with: String(country.characters[country.startIndex]).capitalizedString)
            return (country, UIImage(named: country))
        }

        return countriesAndFlags
    }
}