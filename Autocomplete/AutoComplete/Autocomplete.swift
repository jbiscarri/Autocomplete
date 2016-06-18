//
//  Autocomplete.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/6/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit
public class Autocomplete {
    public class func setupAutocompleteForViewcontroller<T: UIViewController where T: AutocompleteDelegate>(viewController: T) {
        let autoCompleteViewController = initAutoCompleteVC()
        autoCompleteViewController.delegate = viewController

        setupUI(autoCompleteViewController, parentViewController: viewController)

    }
    public class func setupAutocompleteForViewcontrollerWithDetachedDelegate(viewController: UIViewController, delegate:AutocompleteDelegate) {
        let autoCompleteViewController = initAutoCompleteVC()
        autoCompleteViewController.delegate = delegate
        
        setupUI(autoCompleteViewController, parentViewController: viewController)
        
    }
    
    private class func initAutoCompleteVC() -> AutoCompleteViewController {
        let podBundle: NSBundle = NSBundle(forClass: Autocomplete.self)
        
        let storyboard = UIStoryboard(name: "Autocomplete", bundle: podBundle)
        return storyboard.instantiateViewControllerWithIdentifier("autocompleteScene") as! AutoCompleteViewController
    }
    
    private class func setupUI(autoCompleteViewController: AutoCompleteViewController, parentViewController: UIViewController) {
        //Remove from any superview and super viewcontrollers
        autoCompleteViewController.view.removeFromSuperview()
        autoCompleteViewController.removeFromParentViewController()
        
        autoCompleteViewController.willMoveToParentViewController(parentViewController)
        parentViewController.addChildViewController(autoCompleteViewController)
        autoCompleteViewController.didMoveToParentViewController(parentViewController)
        
        autoCompleteViewController.view.willMoveToSuperview(parentViewController.view)
        parentViewController.view.addSubview(autoCompleteViewController.view)
        autoCompleteViewController.view.didMoveToSuperview()
    }
}
