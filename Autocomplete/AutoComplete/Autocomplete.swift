//
//  Autocomplete.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/6/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit
public class Autocomplete {
    public class func attachToViewController<T: UIViewController where T: AutocompleteDelegate>(viewController: T, autoCompleteContainerView: UIView) {

        assert(viewController.view.subviews.contains(autoCompleteContainerView), "containerView in should be a subview of viewController")

        let storyboard = UIStoryboard(name: "Autocomplete", bundle: NSBundle.mainBundle())
        let autoCompleteViewController = storyboard.instantiateViewControllerWithIdentifier("autocompleteScene") as! AutoCompleteViewController
        
        autoCompleteViewController.delegate = viewController

        autoCompleteViewController.willMoveToParentViewController(viewController)
        viewController.addChildViewController(autoCompleteViewController)
        autoCompleteViewController.didMoveToParentViewController(viewController)

        autoCompleteViewController.view.frame.size.width = autoCompleteContainerView.frame.size.width
        autoCompleteViewController.view.willMoveToSuperview(autoCompleteContainerView)
        autoCompleteContainerView.addSubview(autoCompleteViewController.view)
        autoCompleteViewController.view.didMoveToSuperview()

    }
}
