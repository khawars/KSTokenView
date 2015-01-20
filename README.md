KSTokenView
===========
KSTokenView is a control that displays a collection of tokens in a an editable UITextField and sends messages to delegate object. It can be used to gather small amounts of text from user and perform search operation. User can choose multiple search results, which are displayed as token in UITextField.

## Demo
### Vertical
[![](/../screenshots/screenshots/gif1.gif?raw=true)]

### Horizontal
[![](/../screenshots/screenshots/gif2.gif?raw=true)]

### iPhone
[![](/../screenshots/screenshots/iphone1-thumb.png?raw=true)](/../screenshots/screenshots/iphone1.png?raw=true)
[![](/../screenshots/screenshots/iphone2-thumb.png?raw=true)](/../screenshots/screenshots/iphone2.png?raw=true)
[![](/../screenshots/screenshots/iphone3-thumb.png?raw=true)](/../screenshots/screenshots/iphone3.png?raw=true)
[![](/../screenshots/screenshots/iphone4-thumb.png?raw=true)](/../screenshots/screenshots/iphone4.png?raw=true)

### iPad
[![](/../screenshots/screenshots/ipad1-thumb.png?raw=true)](/../screenshots/screenshots/ipad1.png?raw=true)
[![](/../screenshots/screenshots/ipad2-thumb.png?raw=true)](/../screenshots/screenshots/ipad2.png?raw=true)
[![](/../screenshots/screenshots/ipad3-thumb.png?raw=true)](/../screenshots/screenshots/ipad3.png?raw=true)
[![](/../screenshots/screenshots/ipad4-thumb.png?raw=true)](/../screenshots/screenshots/ipad4.png?raw=true)

## Requirements

- iOS 7 and above.
- Xcode 6 and above


## Adding KSTokenView to your project

### METHOD 1: (Cocoapods)
1. Add a pod entry for `KSTokenView` to your Podfile `pod 'KSTokenView', '~> 1.0'`
2. Install the pod(s) by running `pod install`.

### MEHTOD 2: (Source files)
Alternatively you can directly add all source files under `KSTokenView` to your project.

1. Download the [latest code version](https://github.com/khawars/KSTokenView/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
2. Open your Xcode project, then drag and drop `KSTokenView` directory onto your project. Make sure to select Copy items when asked if you extracted the code archive outside of your project.


## Usage

## Interface Builder
- From interface builder, Drag and drop `UIView` onto your `View`.
- In `Identity inspector`, set custom class `KSTokenView`.
- Create an `outlet` in your source file.
- Customize properties and implement delegates.
```
tokenView.delegate = self
tokenView.promptText = "Top 5: "
tokenView.placeholder = "Type to search"
tokenView.descriptionText = "Languages"
tokenView.maxTokenLimit = 5 //default is -1 for unlimited number of tokens
tokenView.style = .Squared`
```


## Programmatically
Create `KSTokenView` object programmatically and add as `subview`.

```
let tokenView = KSTokenView(frame: CGRect(x: 10, y: 50, width: 300, height: 40))
tokenView.delegate = self
tokenView.promptText = "Top 5: "
tokenView.placeholder = "Type to search"
tokenView.descriptionText = "Languages"
tokenView.maxTokenLimit = 5
tokenView.style = .Squared
view.addSubview(tokenView)
```

See example projects for detail.

## License
This code is distributed under the terms and conditions of the [MIT license](LICENSE). 
