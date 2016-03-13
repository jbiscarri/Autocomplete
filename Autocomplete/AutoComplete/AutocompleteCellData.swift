//
//  AutocompleteCellData.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/12/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit

public class AutocompleteCellData {
    public let text: String
    public let image: UIImage?

    public init(text: String, image: UIImage?) {
        self.text = text
        self.image = image
    }
}