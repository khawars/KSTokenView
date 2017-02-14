//
//  StackView.swift
//  Examples
//
//  Created by Khawar Shahzad on 01/01/2015.
//  Copyright (c) 2015 Khawar Shahzad. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

class StackView: UIViewController {

    @IBOutlet var tokenView: KSTokenView!
    let names: Array<String> = List.names()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokenView.delegate = self
        tokenView.promptText = "Top 5: "
        tokenView.placeholder = "Type to search"
        tokenView.descriptionText = "Languages"
        tokenView.maxTokenLimit = 5
        tokenView.minimumCharactersToSearch = 0 // Show all results without without typing anything
        tokenView.style = .squared
    }
}

extension StackView: KSTokenViewDelegate {
    func tokenView(_ token: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
        if (string.characters.isEmpty){
            completion!(names as Array<AnyObject>)
            return
        }
        
        var data: Array<String> = []
        for value: String in names {
            if value.lowercased().range(of: string.lowercased()) != nil {
                data.append(value)
            }
        }
        completion!(data as Array<AnyObject>)
    }
    
    func tokenView(_ token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        return object as! String
    }
    
    func tokenView(_ tokenView: KSTokenView, shouldAddToken token: KSToken) -> Bool {
        if token.title == "f" {
            return false
        }
        return true
    }
}
