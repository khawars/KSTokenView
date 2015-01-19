//
//  ViewController.swift
//  HorizontalExample
//
//  Created by Khawar Shahzad on 19/01/2015.
//  Copyright (c) 2015 Khawar Shahzad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
   @IBOutlet var tokenView: KSTokenView!
   let names: Array<String> = List.names()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      tokenView.delegate = self
      tokenView.promptText = "Top 5: "
      tokenView.placeholder = "Type to search"
      tokenView.descriptionText = "Languages"
      tokenView.maxTokenLimit = 5
      tokenView.style = .Squared
      tokenView.direction = .Vertical
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
}

extension ViewController: KSTokenViewDelegate {
   func tokenView(token: KSTokenView, performSearchWithString string: String, completion: ((results: Array<AnyObject>) -> Void)?) {
      var data: Array<String> = []
      for value: String in names {
         if value.lowercaseString.rangeOfString(string.lowercaseString) != nil {
            data.append(value)
         }
      }
      completion!(results: data)
   }
   
   func tokenView(token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
      return object as String
   }
}