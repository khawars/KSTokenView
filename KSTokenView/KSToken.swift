//
//  KSToken.swift
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


//MARK: - KSToken
//__________________________________________________________________________________
//
public class KSToken : UIControl {
   
   //MARK: - Public Properties
   //__________________________________________________________________________________
   //
   
   /// retuns title as description
   override public var description : String {
      get {
         return title
      }
   }
   
   /// default is ""
   public var title = ""
   
   /// default is nil. Any Custom object.
   public var object: AnyObject?
   
   /// default is false. If set to true, token can not be deleted
   public var sticky = false
   
   /// Token Title color
   public var tokenTextColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
   
   /// Token background color
   public var tokenBackgroundColor = UIColor(red: 50/255, green: 50/255, blue: 255/255, alpha: 1)
   
   /// Token title color in selected state
   public var tokenTextHighlightedColor: UIColor?
   
   /// Token backgrould color in selected state
   public var tokenBackgroundHighlightedColor: UIColor?
   
   /// Token background color in selected state. It doesn't have effect if 'tokenBackgroundHighlightedColor' is set
   public var darkRatio: CGFloat = 0.75
   
   /// Token border width
   public var borderWidth: CGFloat = 0.0
   
   ///Token border color
   public var borderColor: UIColor = UIColor.blackColor()

   /// default is 200. Maximum width of token. After maximum limit is reached title is truncated at end with '...'
   private var _maxWidth: CGFloat? = 200
   var maxWidth: CGFloat {
      get{
         return _maxWidth!
      }
      set (newWidth) {
         if (_maxWidth != newWidth) {
            _maxWidth = newWidth
            sizeToFit()
            setNeedsDisplay()
         }
      }
   }
   
   /// returns true if token is selected
   override public var selected: Bool {
      didSet (newValue) {
         setNeedsDisplay()
      }
   }
   
   //MARK: - Constructors
   //__________________________________________________________________________________
   //
   convenience required public init(coder aDecoder: NSCoder) {
      self.init(title: "")
   }
   
   convenience public init(title: String) {
      self.init(title: title, object: title);
   }
   
   public init(title: String, object: AnyObject?) {
      self.title = title
      self.object = object
      super.init(frame: CGRect.zero)
      backgroundColor = UIColor.clearColor()
   }
   
   //MARK: - Drawing code
   //__________________________________________________________________________________
   //
   override public func drawRect(rect: CGRect) {
      //// General Declarations
      let context = UIGraphicsGetCurrentContext()
      
      //// Rectangle Drawing
      
      // fill background
      let rectanglePath = UIBezierPath(roundedRect: rect, cornerRadius: 15)
      
      var textColor: UIColor
      var backgroundColor: UIColor
      
      if (selected) {
         if (tokenBackgroundHighlightedColor != nil) {
            backgroundColor = tokenBackgroundHighlightedColor!
         } else {
            backgroundColor = tokenBackgroundColor.darkendColor(darkRatio)
         }
         
         if (tokenTextHighlightedColor != nil) {
            textColor = tokenTextHighlightedColor!
         } else {
            textColor = tokenTextColor
         }
         
      } else {
         backgroundColor = tokenBackgroundColor
         textColor = tokenTextColor
      }
      
      backgroundColor.setFill()
      rectanglePath.fill()
      
      var paddingX: CGFloat = 0.0
      var font = UIFont.systemFontOfSize(14)
      var tokenField: KSTokenField? {
         return superview! as? KSTokenField
      }
      if ((tokenField) != nil) {
         paddingX = tokenField!.paddingX()!
         font = tokenField!.tokenFont()!
      }
      
      // Text
      let rectangleTextContent = title
      let rectangleStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
      rectangleStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
      rectangleStyle.alignment = NSTextAlignment.Center
      let rectangleFontAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: textColor, NSParagraphStyleAttributeName: rectangleStyle]
      
      let maxDrawableHeight = max(rect.height , font.lineHeight)
      let textHeight: CGFloat = KSUtils.getRect(rectangleTextContent, width: rect.width, height: maxDrawableHeight , font: font).size.height
      
      
      let textRect = CGRect(x: rect.minX + paddingX, y: rect.minY + (maxDrawableHeight - textHeight) / 2, width: min(maxWidth, rect.width) - (paddingX*2), height: maxDrawableHeight)
      
      rectangleTextContent.drawInRect(textRect, withAttributes: rectangleFontAttributes)
      
      CGContextSaveGState(context)
      CGContextClipToRect(context, rect)
      CGContextRestoreGState(context)
      
      // Border
      if (borderWidth > 0.0 && borderColor != UIColor.clearColor()) {
         borderColor.setStroke()
         rectanglePath.lineWidth = borderWidth
         rectanglePath.stroke()
      }
   }
}