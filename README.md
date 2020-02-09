# PageView

SwiftUI view enabling page-based navigation, imitating the behaviour of `UIPageViewController` in iOS.

## Why

SwiftUI doesn't have any kind of paging control component,  with features similar to `UIPageViewController` from UIKit. While on iOS this could be solved by wrapping `UIPageControl` into  `UIViewRepresentable`, on watchOS horizontal paging functionality cannot be achieved without using storyboards, which forces developers into using multiple WKHostingControllers.

This package attempts to provide native SwiftUI component for navigation between pages of content.

## Installation

Package requires iOS 13, watchOS 6 and Xcode 11.

### Swift Package Manager

For Swift Package Manager add the following package to your Package.swift:
```swift
.package(url: "https://github.com/fredyshox/PageView.git", .upToNextMajor(from: "0.1")),
```

### Carthage

Carthage is also supported, add FormView by adding to Cartfile:
```
github "fredyshox/PageView" ~> 0.1
```

## Demo

Demo app for both iOS and watchOS is provided in `Examples/` directory.

## Usage

Add paged view with 3 pages using following code:
```swift
PageView(pageCount: 3) { pageIndex in
    if pageIndex == 0 || pageIndex == 1 {
        return AnyView(SomeCustomView())
    } else {
        return AnyView(AnotherCustomView())
    }
}
```

By default `PageView` fills all the available area, you can constrain it's size using `.frame(width:, height:)` View modifier.

You can customize the styling of page control component by passing `PageControlTheme`. Customizable properties:
* background color
* active page dot color
* inactive page dot color
* size of page dot
* spacing between dots
* padding of page control
* y-offset from bottom 

```swift
let theme = PageControlTheme(
    backgroundColor: .white,
    dotActiveColor: .black,
    dotInactiveColor: .gray,
    dotSize: 10.0,
    spacing: 12.0,
    padding: 5.0,
    offset: 8.0
)
...
PageView(theme: theme, pageCount: 4) { pageIndex in 
    ...
}
```

There is also a built-in `PageControlTheme.default` style, mimicking `UIPageControl` appearance.

## Screenshots
