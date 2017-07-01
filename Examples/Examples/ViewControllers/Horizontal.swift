//
//  Horizontal.swift
//  Examples
//
//  Created by Khawar Shahzad on 12/13/16.
//  Copyright © 2016 Khawar Shahzad. All rights reserved.
//

import UIKit

class Horizontal: UIViewController {
    let names: Array<String> = List.names()
    @IBOutlet weak var tokenView: KSTokenView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokenView.delegate = self
        tokenView.promptText = "Top: "
        tokenView.placeholder = "Type to search"
        tokenView.descriptionText = "Languages"
        tokenView.maxTokenLimit = -1
        tokenView.minimumCharactersToSearch = 0 // Show all results without without typing anything
        tokenView.style = .squared
        tokenView.direction = .horizontal
    }
}


extension Horizontal: KSTokenViewDelegate {
    func tokenView(_ tokenView: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
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
    
    func tokenView(_ tokenView: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        return object as! String
    }
}
