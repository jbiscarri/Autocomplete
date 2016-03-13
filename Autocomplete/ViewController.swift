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
            Autocomplete.setupAutocompleteForViewcontroller(self)
        }
    }
}

extension ViewController: AutocompleteDelegate {
    func autoCompleteTextField() -> UITextField {
        return self.countriesTextField
    }
    func autoCompleteThreshold(textField: UITextField) -> Int {
        return 1
    }

    func autoCompleteItemsForSearchTerm(term: String) -> [AutocompleteCellData] {
        let filteredCountries = self.countriesList.filter { (country) -> Bool in
            return country.lowercaseString.containsString(term.lowercaseString)
        }

        let countriesAndFlags: [AutocompleteCellData] = filteredCountries.map { (var country) -> AutocompleteCellData in
            country.replaceRange(country.startIndex...country.startIndex, with: String(country.characters[country.startIndex]).capitalizedString)
            return AutocompleteCellData(text: country, image: UIImage(named: country))
        }

        return countriesAndFlags
    }

    func autoCompleteFrame() -> CGRect {
        return CGRect(x: CGRectGetMinX(self.countriesTextField.frame),
            y: CGRectGetMaxY(self.countriesTextField.frame),
            width: CGRectGetWidth(self.countriesTextField.frame),
            height: CGRectGetHeight(self.view.frame)/3.0)
    }
}