# PageView

SwiftUI view enabling page-based navigation, imitating the behaviour of `UIPageViewController` in iOS.

## Why

SwiftUI doesn't have any kind of paging control component,  with features similar to `UIPageViewController` from UIKit on iOS. This could be solved by wrapping `UIPageControl` into  `UIViewRepresentable`. On the other hand in watchOS horizontal paging functionality cannot be achieved without using storyboards, which forces developers into using multiple WKHostingControllers in SwiftUI.

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

## Screenshots
