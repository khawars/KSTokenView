//
//  KSUtils.swift
//  KSTokenView
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

let KSTextEmpty = "\u{200B}"

class KSUtils : NSObject {
   
   class func getRect(str: NSString, width: CGFloat, height: CGFloat, font: UIFont) -> CGRect {
      let rectangleStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
      rectangleStyle.alignment = NSTextAlignment.Center
      let rectangleFontAttributes = [NSFontAttributeName: font, NSParagraphStyleAttributeName: rectangleStyle]
      return str.boundingRectWithSize(CGSizeMake(width, height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: rectangleFontAttributes, context: nil)
   }
   
   class func getRect(str: NSString, width: CGFloat, font: UIFont) -> CGRect {
      let rectangleStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
      rectangleStyle.alignment = NSTextAlignment.Center
      let rectangleFontAttributes = [NSFontAttributeName: font, NSParagraphStyleAttributeName: rectangleStyle]
      return str.boundingRectWithSize(CGSizeMake(width, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: rectangleFontAttributes, context: nil)
   }
   
   class func widthOfString(str: String, font: UIFont) -> CGFloat {
      let attrs = [NSFontAttributeName: font]
      let attributedString = NSMutableAttributedString(string:str, attributes:attrs)
      return attributedString.size().width
   }
   
}

extension UIColor {
   func darkendColor(darkRatio: CGFloat) -> UIColor {
      var h: CGFloat = 0.0, s: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
      if (getHue(&h, saturation: &s, brightness: &b, alpha: &a)) {
         return UIColor(hue: h, saturation: s, brightness: b*darkRatio, alpha: a)
      } else {
         return self
      }
   }
}
