//
//  ViewController.swift
//  ProgrammaticallyExample
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

class ViewController: UIViewController {
   let names = List.names()
   var tokenView: KSTokenView = KSTokenView(frame: .zeroRect)
   @IBOutlet weak var shouldChangeSwitch: UISwitch!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      tokenView = KSTokenView(frame: CGRect(x: 10, y: 160, width: 300, height: 30))
      tokenView.delegate = self
      tokenView.promptText = "Favorites: "
      tokenView.placeholder = "Type to search"
      tokenView.descriptionText = "Languages"
      tokenView.style = .Rounded
      view.addSubview(tokenView)
      for i in 0...20 {
         let token: KSToken = KSToken(title: names[i])
         tokenView.addToken(token)
      }
   }
   
   @IBAction func addToken(sender: AnyObject) {
      let title = names[Int(arc4random_uniform(UInt32(names.count)))] as String
      let token = KSToken(title: title, object: title)
      
      // Token background color
      var red = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
      var green = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
      var blue = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
      token.tokenBackgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
      
      // Token text color
      red = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
      green = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
      blue = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
      token.tokenTextColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
      
      tokenView.addToken(token)
   }
   
   @IBAction func deleteLastToken(sender: AnyObject) {
      tokenView.deleteLastToken()
   }
   
   @IBAction func deleteAllTokens(sender: AnyObject) {
      tokenView.deleteAllTokens()
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
      return object as! String
   }
   
   func tokenView(tokenView: KSTokenView, shouldChangeAppearanceForToken token: KSToken) -> KSToken? {
      if shouldChangeSwitch.on {
         token.tokenBackgroundColor = UIColor.redColor()
         token.tokenTextColor = UIColor.blackColor()
      }
      
      return token
   }
}