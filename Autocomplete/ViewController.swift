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
    @IBOutlet weak var lblSelectedCountryName: UILabel!

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

    func autoCompleteItemsForSearchTerm(term: String) -> [AutocompletableOption] {
        let filteredCountries = self.countriesList.filter { (country) -> Bool in
            return country.lowercaseString.containsString(term.lowercaseString)
        }

        let countriesAndFlags: [AutocompletableOption] = filteredCountries.map { (var country) -> AutocompleteCellData in
            country.replaceRange(country.startIndex...country.startIndex, with: String(country.characters[country.startIndex]).capitalizedString)
            return AutocompleteCellData(text: country, image: UIImage(named: country)) 
            }.map( { $0 as AutocompletableOption })

        return countriesAndFlags
    }

    func autoCompleteHeight() -> CGFloat {
        return CGRectGetHeight(self.view.frame) / 3.0
    }


    func didSelectItem(item: AutocompletableOption) {
        self.lblSelectedCountryName.text = item.text
    }
}