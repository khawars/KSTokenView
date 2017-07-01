//
//  ViewController.swift
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
//

import UIKit

class ViewController: UIViewController {
    let names: Array<String> = List.names()

    @IBOutlet weak var tableView: UITableView!
    
    let examples = ["Autolayout", "Programtically", "UIStackView", "Horizontal", "Objective-C"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Examples"
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: UIViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if indexPath.row == 0 {
            vc = storyboard.instantiateViewController(withIdentifier: "Autolayout")
            
        } else if indexPath.row == 1 {
            vc = storyboard.instantiateViewController(withIdentifier: "Programmatically")
            
        } else if indexPath.row == 2 {
            vc = storyboard.instantiateViewController(withIdentifier: "StackView")
            
        } else if indexPath.row == 3 {
            vc = storyboard.instantiateViewController(withIdentifier: "Horizontal")
        
        } else if indexPath.row == 4 {
            vc = storyboard.instantiateViewController(withIdentifier: "ObjectiveC")
            
        } else {
            vc = storyboard.instantiateViewController(withIdentifier: "TableView")
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentfier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentfier) as UITableViewCell?
        
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:cellIdentfier)
        }
        
        cell?.textLabel?.text = examples[indexPath.row]
        
        return cell!
    }
}
