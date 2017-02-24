//
//  KSTokenView.swift
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


@objc public enum KSTokenViewStyle: Int {
   case rounded
   case squared
}

@objc public enum KSTokenViewScrollDirection: Int {
   case vertical
   case horizontal
}


//MARK: - KSTokenViewDelegate
//__________________________________________________________________________________
//

@objc public protocol KSTokenViewDelegate {
   
   /**
   Asks the delegate whether the token should be added
   
   - parameter tokenView: KSTokenView object
   - parameter token:     KSToken object that needs to be added
   
   - returns: Boolean
   
   */
   @objc optional func tokenView(_ tokenView: KSTokenView, shouldAddToken token: KSToken) -> Bool
   @objc optional func tokenView(_ tokenView: KSTokenView, willAddToken token: KSToken)
   @objc optional func tokenView(_ tokenView: KSTokenView, shouldChangeAppearanceForToken token: KSToken) -> KSToken?
   @objc optional func tokenView(_ tokenView: KSTokenView, didAddToken token: KSToken)
   @objc optional func tokenView(_ tokenView: KSTokenView, didFailToAdd token: KSToken)
   
   @objc optional func tokenView(_ tokenView: KSTokenView, shouldDeleteToken token: KSToken) -> Bool
   @objc optional func tokenView(_ tokenView: KSTokenView, willDeleteToken token: KSToken)
   @objc optional func tokenView(_ tokenView: KSTokenView, didDeleteToken token: KSToken)
   @objc optional func tokenView(_ tokenView: KSTokenView, didFailToDeleteToken token: KSToken)
   
   @objc optional func tokenView(_ tokenView: KSTokenView, willChangeFrameWithX: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)
   @objc optional func tokenView(_ tokenView: KSTokenView, didChangeFrameWithX: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)
   
   @objc optional func tokenView(_ tokenView: KSTokenView, didSelectToken token: KSToken)
   @objc optional func tokenViewDidBeginEditing(_ tokenView: KSTokenView)
   @objc optional func tokenViewDidEndEditing(_ tokenView: KSTokenView)
   
   func tokenView(_ token: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?)
   func tokenView(_ token: KSTokenView, displayTitleForObject object: AnyObject) -> String
   @objc optional func tokenView(_ token: KSTokenView, withObject object: AnyObject, tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
   @objc optional func tokenView(_ token: KSTokenView, didSelectRowAtIndexPath indexPath: IndexPath)
   
   @objc optional func tokenViewShouldDeleteAllToken(_ tokenView: KSTokenView) -> Bool
   @objc optional func tokenViewWillDeleteAllToken(_ tokenView: KSTokenView)
   @objc optional func tokenViewDidDeleteAllToken(_ tokenView: KSTokenView)
   @objc optional func tokenViewDidFailToDeleteAllTokens(_ tokenView: KSTokenView)
   
   @objc optional func tokenViewDidShowSearchResults(_ tokenView: KSTokenView)
   @objc optional func tokenViewDidHideSearchResults(_ tokenView: KSTokenView)
}

//MARK: - KSTokenView
//__________________________________________________________________________________
//

/**
*  A KSTokenView is a control that displays a collection of tokens in a an editable UITextField and sends messages to delegate object. It can be used to gather small amounts of text from user and perform search operation. User can choose multiple search results, which are displayed as token in UITextField.
*/
open class KSTokenView: UIView {
   
   //MARK: - Private Properties
   //__________________________________________________________________________________
   //
   fileprivate var _tokenField: KSTokenField!
   fileprivate var _searchTableView: UITableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
   fileprivate var _resultArray = [AnyObject]()
   fileprivate var _showingSearchResult = false
   fileprivate var _indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
   fileprivate let _searchResultHeight: CGFloat = 200.0
   fileprivate var _lastSearchString: String = ""
   fileprivate var _intrinsicContentHeight: CGFloat = UIViewNoIntrinsicMetric
   
   //MARK: - Public Properties
   //__________________________________________________________________________________
   //
   
   /// returns the value of field
   open var text : String {
      get {
         return _tokenField.text!.substring(with: _tokenField.text!.characters.index(_tokenField.text!.startIndex, offsetBy: 1)..<self._tokenField.text!.endIndex)         
      }
      set (string) {
         _tokenField.text = KSTextEmpty+string
      }
   }
   
   /// default is true. token can be deleted with keyboard 'x' button
   open var shouldDeleteTokenOnBackspace = true
   
   /// Only works for iPhone now, not iPad devices. default is false. If true, search results are hidden when one of them is selected
   open var shouldHideSearchResultsOnSelect = false
   
   /// default is false. If true, already added token still appears in search results
   open var shouldDisplayAlreadyTokenized = false
   
   /// default is ture. Sorts the search results alphabatically according to title provided by tokenView(_:displayTitleForObject) delegate
   open var shouldSortResultsAlphabatically = true
   
   /// default is true. If false, token can only be added from picking search results. All the text input would be ignored
   open var shouldAddTokenFromTextInput = true
   
   /// default is 1. If set to 0, it shows all search results without typing anything
   open var minimumCharactersToSearch = 1
   
   /// default is nil
   weak open var delegate: KSTokenViewDelegate?
   
   /// default is .Vertical.
   open var direction: KSTokenViewScrollDirection = .vertical {
      didSet {
         _updateTokenField()
      }
   }
   
   /// Default is whiteColor
   override open var backgroundColor: UIColor? {
      didSet {
         if (oldValue != backgroundColor && _tokenField != nil) {
            _tokenField.backgroundColor = backgroundColor
         }
      }
   }
   
   /// Default is (TokenViewWidth, 200)
   open var searchResultSize: CGSize = CGSize.zero {
      didSet {
         _searchTableView.frame.size = searchResultSize
      }
   }
   
   /// Default is whiteColor()
   open var searchResultBackgroundColor: UIColor = UIColor.white {
      didSet {
         _searchTableView.backgroundColor = searchResultBackgroundColor
      }
   }
   
   /// default is UIColor.blueColor()
   open var activityIndicatorColor: UIColor = UIColor.blue {
      didSet {
         _indicator.color = activityIndicatorColor
      }
   }
   
   /// default is 120.0. After maximum limit is reached, tokens starts scrolling vertically
   open var maximumHeight: CGFloat = 120.0 {
      didSet {
         _tokenField.maximumHeight = maximumHeight
      }
   }
   
   /// default is UIColor.grayColor()
   open var cursorColor: UIColor = UIColor.gray {
      didSet {
         _updateTokenField()
      }
   }
   
   /// default is 10.0. Horizontal padding of title
   open var paddingX: CGFloat = 10.0 {
      didSet {
         if (oldValue != paddingX) {
            _updateTokenField()
         }
      }
   }
   
   /// default is 2.0. Vertical padding of title
   open var paddingY: CGFloat = 2.0 {
      didSet {
         if (oldValue != paddingY) {
            _updateTokenField()
         }
      }
   }
   
   /// default is 5.0. Horizontal margin between tokens
   open var marginX: CGFloat = 5.0 {
      didSet {
         if (oldValue != marginX) {
            _updateTokenField()
         }
      }
   }
   
   /// default is 5.0. Vertical margin between tokens
   open var marginY: CGFloat = 5.0 {
      didSet {
         if (oldValue != marginY) {
            _updateTokenField()
         }
      }
   }
    
    /// default is 0. Horizontal buffer between prompt and content
    open var bufferX: CGFloat = 0.0 {
        didSet {
            if (oldValue != bufferX) {
                _updateTokenField()
            }
        }
    }
   
   /// default is UIFont.systemFontOfSize(16)
   open var font: UIFont = UIFont.systemFont(ofSize: 16) {
      didSet {
         if (oldValue != font) {
            _updateTokenField()
         }
      }
   }
   
   /// default is 50.0. Caret moves to new line if input width is less than this value
   open var minWidthForInput: CGFloat = 50.0 {
      didSet {
         if (oldValue != minWidthForInput) {
            _updateTokenField()
         }
      }
   }
   
   /// default is ", ". Used to separate titles when untoknized
   open var separatorText: String = ", " {
      didSet {
         if (oldValue != separatorText) {
            _updateTokenField()
         }
      }
   }
   
   /// An array of string values. Default values are "." and ",". Token is created with typed text, when user press any of the character mentioned in this Array
   open var tokenizingCharacters = [".", ","]
   
   /// default is 0.25.
   open var animateDuration: TimeInterval = 0.25 {
      didSet {
         if (oldValue != animateDuration) {
            _updateTokenField()
         }
      }
   }
   
   /// default is true. When resignFirstResponder is called tokens are removed and description is displayed.
   open var removesTokensOnEndEditing: Bool = true {
      didSet {
         if (oldValue != removesTokensOnEndEditing) {
            _updateTokenField()
         }
      }
   }
   
   /// Default is "selections"
   open var descriptionText: String = "selections" {
      didSet {
         if (oldValue != descriptionText) {
            _updateTokenField()
         }
      }
   }
   
   /// set -1 for unlimited.
   open var maxTokenLimit: Int = -1 {
      didSet {
         if (oldValue != maxTokenLimit) {
            _updateTokenField()
         }
      }
   }
   
   /// default is "To: "
   open var promptText: String = "To: " {
      didSet {
         if (oldValue != promptText) {
            _updateTokenField()
         }
      }
   }
   
   /// default is true. If false, cannot be edited
   open var editable: Bool = true {
      didSet {
         _tokenField.isEnabled = editable
      }
   }
   
   /// default is nil
   open var placeholder: String {
      get {
         return _tokenField.placeholder!
      }
      set {
         _tokenField.placeholder = newValue
      }
   }

    /// default is UIColor.grayColor()
    open var promptColor: UIColor = UIColor.gray {
        didSet {
            _updateTokenField()
        }
    }

    /// default is UIColor.grayColor()
    open var placeholderColor: UIColor = UIColor.gray {
        didSet {
            _updateTokenField()
        }
    }
   
   /// default is .Rounded, creates rounded corner
   open var style: KSTokenViewStyle = .rounded {
      didSet(newValue) {
         _updateTokenFieldLayout(style)
      }
   }
   
   //MARK: - Constructors
   //__________________________________________________________________________________
   //
   
   /**
   Create and inialize KSTokenView object
   
   - parameter frame: An object of type CGRect
   
   - returns: KSTokenView object
   */
   override public init(frame: CGRect) {
      super.init(frame: frame)
      _commonSetup()
   }
   
   /**
   Create and inialize KSTokenView object from Interface builder
   
   - parameter aDecoder: An object of type NSCoder
   
   - returns: KSTokenView object
   */
   required public init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }
   
   override open func awakeFromNib() {
      _commonSetup()
   }
   
   //MARK: - Common Setup
   //__________________________________________________________________________________
   //
   
   fileprivate func _commonSetup() {
      backgroundColor = UIColor.clear
      clipsToBounds = true
      _tokenField = KSTokenField(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
      _tokenField.textColor = UIColor.black
      _tokenField.isEnabled = true
      _tokenField.tokenFieldDelegate = self
      _tokenField.placeholder = ""
      _tokenField.autoresizingMask = [.flexibleWidth]
      _updateTokenField()
      addSubview(_tokenField)
      
      _indicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
      _indicator.hidesWhenStopped = true
      _indicator.stopAnimating()
      _indicator.color = activityIndicatorColor
      
      searchResultSize = CGSize(width: frame.width, height: _searchResultHeight)
      _searchTableView.frame = CGRect(x: 0, y: frame.height, width: searchResultSize.width, height: searchResultSize.height)
      _searchTableView.delegate = self
      _searchTableView.dataSource = self
      
      _hideSearchResults()
      _intrinsicContentHeight = _tokenField.bounds.height
      invalidateIntrinsicContentSize()
   }
   
   //MARK: - Layout Changes
   //__________________________________________________________________________________
   //
   override open func layoutSubviews() {
      _tokenField.updateLayout(false)
      _searchTableView.frame.size = CGSize(width: frame.width, height: searchResultSize.height)
   }
   
    override open var intrinsicContentSize : CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: _intrinsicContentHeight)
    }
    
    //MARK: - Public Methods
    //__________________________________________________________________________________
    //
    
    /// Changes the returnKeyType of KSTokenField
    open func returnKeyType(type: UIReturnKeyType) {
        _tokenField.returnKeyType = type
    }
    
   //MARK: - Private Methods
   //__________________________________________________________________________________
   //
   
   fileprivate func _updateTokenField() {
      _tokenField.parentView = self
   }
   
   fileprivate func _updateTokenFieldLayout(_ newValue: KSTokenViewStyle) {
      switch (newValue) {
      case .rounded:
         _tokenField.borderStyle = .roundedRect
         backgroundColor = UIColor.clear
         
      case .squared:
         _tokenField.borderStyle = .bezel
         backgroundColor = _tokenField.backgroundColor
      }
   }
   
   fileprivate func _lastToken() -> KSToken? {
      if _tokenField.tokens.count == 0 {
         return nil
      }
      return _tokenField.tokens.last
   }
   
   fileprivate func _removeToken(_ token: KSToken, removingAll: Bool = false) {
      if token.sticky {return}
      if (!removingAll) {
         var shouldRemoveToken: Bool? = true
         
         if let shouldRemove = delegate?.tokenView?(self, shouldDeleteToken: token) {
            shouldRemoveToken = shouldRemove
         }
         if (shouldRemoveToken != true) {
            delegate?.tokenView?(self, didFailToDeleteToken: token)
            return
         }
         delegate?.tokenView?(self, willDeleteToken: token)
      }
      _tokenField.removeToken(token, removingAll: removingAll)
      if (!removingAll) {
         delegate?.tokenView?(self, didDeleteToken: token)
         _startSearchWithString("")
      }
   }
   
   fileprivate func _canAddMoreToken() -> Bool {
      if (maxTokenLimit != -1 && _tokenField.tokens.count >= maxTokenLimit) {
         _hideSearchResults()
         return false
      }
      return true
   }
   
   
   /**
   Returns an Array of KSToken objects
   
   - returns: Array of KSToken objects
   */
   open func tokens () -> Array<KSToken>? {
      return _tokenField.tokens
   }
   
   //MARK: - Add Token
   //__________________________________________________________________________________
   //
   
   
   /**
   Creates KSToken from input text, when user press keyboard "Done" button
   
   - parameter tokenField: Field to add in
   
   - returns: Boolean if token is added
   */
   fileprivate func _addTokenFromUntokenizedText(_ tokenField: KSTokenField) -> Bool {
      if (shouldAddTokenFromTextInput && tokenField.text != nil && tokenField.text != KSTextEmpty) {         
         let trimmedString = tokenField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        addTokenWithTitle(trimmedString)
         _hideSearchResults()
         return true
      }
      return false
   }
   
   /**
   Creates and add a new KSToken object
   
   - parameter title:       Title of token
   - parameter tokenObject: Any custom object
   
   - returns: KSToken object
   */
   @discardableResult open func addTokenWithTitle(_ title: String, tokenObject: AnyObject? = nil) -> KSToken? {
      let token = KSToken(title: title, object: tokenObject)
      return addToken(token)
   }
   
   
   /**
   Creates and add a new KSToken object
   
   - parameter token: KSToken object
   
   - returns: KSToken object
   */
   @discardableResult open func addToken(_ token: KSToken) -> KSToken? {
      if (!_canAddMoreToken()) {
         return nil
      }
      
      var shouldAddToken: Bool? = true
      if let shouldAdd = delegate?.tokenView?(self, shouldAddToken: token) {
         shouldAddToken = shouldAdd
      }
      
      if (shouldAddToken != true) {
         delegate?.tokenView?(self, didFailToAdd: token)
         return nil
      }
      
      delegate?.tokenView?(self, willAddToken: token)
      var addedToken: KSToken?
      if let updatedToken = delegate?.tokenView?(self, shouldChangeAppearanceForToken: token) {
         addedToken = _tokenField.addToken(updatedToken)
         
      } else {
         addedToken = _tokenField.addToken(token)
      }
      
      delegate?.tokenView?(self, didAddToken: addedToken!)
      return addedToken
   }
   
   
   //MARK: - Delete Token
   //__________________________________________________________________________________
   //
   
   /**
   Deletes an already added KSToken object
   
   - parameter token: KSToken object
   */
   open func deleteToken(_ token: KSToken) {
      _removeToken(token)
   }
   
   /**
   Searches for KSToken object and deletes
   
   - parameter object: Custom object
   */
   open func deleteTokenWithObject(_ object: AnyObject?) {
      if object == nil {return}
      for token in _tokenField.tokens {
         if (token.object!.isEqual(object)) {
            _removeToken(token)
            break
         }
      }
   }
   
   /**
   Deletes all added tokens. This doesn't delete sticky token
   */
   open func deleteAllTokens() {
      if (_tokenField.tokens.count == 0) {return}
      var shouldDeleteAllTokens: Bool? = true
      
      if let shouldRemoveAll = delegate?.tokenViewShouldDeleteAllToken?(self) {
         shouldDeleteAllTokens = shouldRemoveAll
      }
      
      if (shouldDeleteAllTokens != true) {
         delegate?.tokenViewDidFailToDeleteAllTokens?(self)
         return
      }
      
      delegate?.tokenViewWillDeleteAllToken?(self)
      for token in _tokenField.tokens {_removeToken(token, removingAll: true)}
      _tokenField.updateLayout()
      delegate?.tokenViewDidDeleteAllToken?(self)
      
      if (_showingSearchResult) {
         _startSearchWithString(_lastSearchString)
      }
   }
   
   /**
   Deletes last added KSToken object
   */
   open func deleteLastToken() {
      let token: KSToken? = _lastToken()
      if token != nil {
         _removeToken(token!)
      }
   }
   
   /**
   Deletes selected KSToken object
   */
   open func deleteSelectedToken() {
      let token: KSToken? = selectedToken()
      if (token != nil) {
         _removeToken(token!)
      }
   }
   
   /**
   Returns Selected KSToken object
   
   - returns: KSToken object
   */
   open func selectedToken() -> KSToken? {
      return _tokenField.selectedToken
   }
   
   
   //MARK: - KSTokenFieldDelegates
   //__________________________________________________________________________________
   //
   func tokenFieldDidBeginEditing(_ tokenField: KSTokenField) {
      delegate?.tokenViewDidBeginEditing?(self)
      tokenField.tokenize()
      if (minimumCharactersToSearch == 0) {
         _startSearchWithString("")
      }
   }
   
   func tokenFieldDidEndEditing(_ tokenField: KSTokenField) {
      delegate?.tokenViewDidEndEditing?(self)
      tokenField.untokenize()
      _hideSearchResults()
   }
   
   open override var isFirstResponder : Bool {
      return _tokenField.isFirstResponder
   }
   
   override open func becomeFirstResponder() -> Bool {
      return _tokenField.becomeFirstResponder()
   }
   
   @discardableResult override open func resignFirstResponder() -> Bool {
      if (!_addTokenFromUntokenizedText(_tokenField)) {
         _tokenField.resignFirstResponder()
      }
      return false
   }
   
   //MARK: - Search
   //__________________________________________________________________________________
   //
   
   /**
   Triggers the search after user input text
   
   - parameter string: Search keyword
   */
   fileprivate func _startSearchWithString(_ string: String) {
      if (!_canAddMoreToken()) {
         return
      }
      _showEmptyResults()
      _showActivityIndicator()
      
      let trimmedSearchString = string.trimmingCharacters(in: CharacterSet.whitespaces)
      delegate?.tokenView(self, performSearchWithString:trimmedSearchString, completion: { (results) -> Void in
         self._hideActivityIndicator()
         if (results.count > 0) {
            self._displayData(results)
         }
      })
   }
   
   fileprivate func _displayData(_ results: Array<AnyObject>) {
      _resultArray = _filteredSearchResults(results)
      _searchTableView.reloadData()
      _showSearchResults()
   }
   
   fileprivate func _showEmptyResults() {
      _resultArray.removeAll(keepingCapacity: false)
      _searchTableView.reloadData()
      _showSearchResults()
   }
   
    fileprivate func _showSearchResults() {
        guard !_showingSearchResult else {return}
        _showingSearchResult = true
        addSubview(_searchTableView)
        let tokenFieldHeight = _tokenField.frame.height
        _searchTableView.isHidden = false
        _changeHeight(tokenFieldHeight)
        delegate?.tokenViewDidShowSearchResults?(self)
    }
   
    fileprivate func _hideSearchResults() {
        guard _showingSearchResult else {return}
        _showingSearchResult = false
        let searchTableView = self._searchTableView
        _changeHeight(_tokenField.frame.height) {
            searchTableView.isHidden = true
            searchTableView.removeFromSuperview()
        }
        delegate?.tokenViewDidHideSearchResults?(self)
    }
   
    fileprivate func _repositionSearchResults(_ height: CGFloat) {
      if (!_showingSearchResult) {
         return
      }
      _searchTableView.frame.origin = CGPoint(x: 0, y: height)
   }
   
   fileprivate func _filteredSearchResults(_ results: Array <AnyObject>) -> Array <AnyObject> {
      var filteredResults: Array<AnyObject> = Array()
      
      for object: AnyObject in results {
         // Check duplicates in array
         var shouldAdd = !(filteredResults as NSArray).contains(object)
         
         if (shouldAdd) {
            if (!shouldDisplayAlreadyTokenized && _tokenField.tokens.count > 0) {
               
               // Search if already tokenized
               for token: KSToken in _tokenField.tokens {
                  if (object.isEqual(token.object)) {
                     shouldAdd = false
                     break
                  }
               }
            }
            
            if (shouldAdd) {
               filteredResults.append(object)
            }
         }
      }
      
      if (shouldSortResultsAlphabatically) {
         return filteredResults.sorted(by: { s1, s2 in return self._sortStringForObject(s1) < self._sortStringForObject(s2) })
      }
      return filteredResults
   }
   
   fileprivate func _sortStringForObject(_ object: AnyObject) -> String {
      let title = (delegate?.tokenView(self, displayTitleForObject: object))!
      return title
   }
   
   fileprivate func _showActivityIndicator() {
      _indicator.startAnimating()
      _searchTableView.tableHeaderView = _indicator
   }
   
   fileprivate func _hideActivityIndicator() {
      _indicator.stopAnimating()
      _searchTableView.tableHeaderView = nil
   }
    
    fileprivate func _changeHeight(_ tokenFieldHeight: CGFloat, completion: (() -> Void)? = nil) {
        let fullHeight = tokenFieldHeight + (_showingSearchResult ? _searchResultHeight : 0.0)
        delegate?.tokenView?(self, willChangeFrameWithX: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: fullHeight)
        self._repositionSearchResults(tokenFieldHeight)
        
        UIView.animate(
            withDuration: animateDuration,
            animations: {
                self._tokenField.frame.size.height = tokenFieldHeight
                self.frame.size.height = fullHeight
                self._intrinsicContentHeight = fullHeight
                self.invalidateIntrinsicContentSize()
                self.superview?.layoutIfNeeded()
            },
            completion: {completed in
                completion?()
                if (completed) {
                    self.delegate?.tokenView?(self, didChangeFrameWithX: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: fullHeight)
                }
        })
    }
   
   //MARK: - Memory Mangement
   //__________________________________________________________________________________
   //
   deinit {
      
   }
   
}

//MARK: - Extension KSTokenFieldDelegate
//__________________________________________________________________________________
//
extension KSTokenView : KSTokenFieldDelegate {
   func tokenFieldDidSelectToken(_ token: KSToken) {
      delegate?.tokenView?(self, didSelectToken: token)
   }
   
   func tokenFieldShouldChangeHeight(_ height: CGFloat) {
      _changeHeight(height)
   }
}


//MARK: - Extension UITextFieldDelegate
//__________________________________________________________________________________
//
extension KSTokenView : UITextFieldDelegate {
   public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
      // If backspace is pressed
      if (_tokenField.tokens.count > 0 && _tokenField.text == KSTextEmpty && string.isEmpty == true && shouldDeleteTokenOnBackspace) {
         if (_lastToken() != nil) {
            if (selectedToken() != nil) {
               deleteSelectedToken()
            } else {
               _tokenField.selectToken(_lastToken()!)
            }
         }
         return false
      }
      
      // Prevent removing KSTextEmpty
      if (string.isEmpty == true && _tokenField.text == KSTextEmpty) {
         return false
      }
    
      var searchString: String
      let olderText = _tokenField.text
      var olderTextTrimmed = olderText!
      // remove the empty text marker from the beginning of the string
      if (olderText?.characters.first == KSTextEmpty.characters.first) {
         olderTextTrimmed = olderText!.substring(from: olderText!.characters.index(olderText!.startIndex, offsetBy: 1))
      }
    
      // Check if character is removed at some index
      // Remove character at that index
      if (string.isEmpty) {
         let first: String = olderText!.substring(to: olderText!.characters.index(olderText!.startIndex, offsetBy: range.location)) as String
         let second: String = olderText!.substring(from: olderText!.characters.index(olderText!.startIndex, offsetBy: range.location+1)) as String
         searchString = first + second
         searchString = searchString.trimmingCharacters(in: CharacterSet.whitespaces)
         
      } else { // new character added
         if (tokenizingCharacters.contains(string) && olderText != KSTextEmpty && olderTextTrimmed != "") {
            addTokenWithTitle(olderTextTrimmed, tokenObject: nil)
            _hideSearchResults()
            return false
         }
         searchString = (olderText! as NSString).replacingCharacters(in: range, with: string)
         if (searchString.characters.first == KSTextEmpty.characters.first) {
            searchString = searchString.substring(from: searchString.characters.index(searchString.startIndex, offsetBy: 1))
         }
      }
    
      // Allow all other characters
      if (searchString.characters.count >= minimumCharactersToSearch && searchString != "\n") {
         _lastSearchString = searchString
         _startSearchWithString(_lastSearchString)
      } else {
         _hideSearchResults()
      }
    
      _tokenField.scrollViewScrollToEnd()
      return true
   }
   
   public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      resignFirstResponder()
      return true
   }
}

//MARK: - Extension UITableViewDelegate
//__________________________________________________________________________________
//

extension KSTokenView : UITableViewDelegate {
   
   public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      delegate?.tokenView?(self, didSelectRowAtIndexPath: indexPath)
      let object: AnyObject = _resultArray[(indexPath as NSIndexPath).row]
      let title  = delegate?.tokenView(self, displayTitleForObject: object)
      let token = KSToken(title: title!, object: object)
      addToken(token)
      
      if (shouldHideSearchResultsOnSelect) {
         _hideSearchResults()
         
      } else if (!shouldDisplayAlreadyTokenized) {
         _resultArray.remove(at: (indexPath as NSIndexPath).row)
         tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
      }
   }
}

//MARK: - Extension UITableViewDataSource
//__________________________________________________________________________________
//
extension KSTokenView : UITableViewDataSource {
   
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return _resultArray.count
   }
   
   public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      var cell: UITableViewCell? = delegate?.tokenView?(self, withObject: _resultArray[(indexPath as NSIndexPath).row], tableView: tableView, cellForRowAtIndexPath: indexPath)
      if cell != nil {
         return cell!
      }
      
      let cellIdentifier = "KSSearchTableCell"
      cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as UITableViewCell?
      if (cell == nil) {
         cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
      }
      
      let title = delegate?.tokenView(self, displayTitleForObject: _resultArray[(indexPath as NSIndexPath).row])
      cell!.textLabel!.text = (title != nil) ? title : "No Title"
      cell!.selectionStyle = UITableViewCellSelectionStyle.none
      return cell!
   }
}
