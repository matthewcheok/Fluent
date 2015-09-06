<p align="center">
<img src="https://github.com/matthewcheok/Fluent/raw/master/logo@2x.png" alt="Logo" width="348" height="145">
</p>

Fluent ![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)
======

[![Badge w/ Version](https://cocoapod-badges.herokuapp.com/v/Fluent/badge.png)](https://github.com/matthewcheok/Fluent)
[![Badge w/ Platform](https://cocoapod-badges.herokuapp.com/p/Fluent/badge.svg)](https://github.com/matthewcheok/Fluent)

Swift Animations made Easy

## Installation

- Add the following to your [`Podfile`](http://cocoapods.org/) and run `pod install`
```
    pod 'Fluent', '~> 0.1'
```
- or add the following to your [`Cartfile`](https://github.com/Carthage/Carthage) and run `carthage update`
```
    github "matthewcheok/Fluent"
```
- or clone as a git submodule,

- or just copy files in the ```Fluent``` folder into your project.

## Using Fluent

Fluent makes writing animations declarative and chainable.

```
boxView
.animate(0.5)
.rotate(0.5)
.scale(2)
.backgroundColor(.blueColor())
.waitThenAnimate(0.5)
.scale(1)
.backgroundColor(.redColor())
```

Simply call one of the animation methods, of which only `duration` is required:

- animate(duration: NSTimeInterval, velocity: CGFloat , damping: CGFloat, options: UIViewAnimationOptions) 
- waitThenAnimate(duration: NSTimeInterval, velocity: CGFloat , damping: CGFloat, options: UIViewAnimationOptions) 

All common properties on `UIView` are supported:

- scale(factor: CGFloat)
- translate(x: CGFloat, y: CGFloat)
- rotate(cycles: CGFloat)
- backgroundColor(color: UIColor) 
- alpha(alpha: CGFloat)
- frame(frame: CGRect)
- bounds(bounds: CGRect)
- center(center: CGPoint)

There are also relative versions of the transforms:

- scaleBy(factor: CGFloat)
- translateBy(x: CGFloat, y: CGFloat)
- rotateBy(cycles: CGFloat)

You may not mix absolute and relative transformations in the same animation.

### Using transforms

The order of the transformations are important!

To reverse the following:

```
boxView
.animate(1)
.translateBy(50, 50)
.rotateBy(0.5)
.scaleBy(2)
.backgroundColor(.blueColor())
.alpha(0.7)
```

We need to undo the transformations in reverse or get weird results:

```
boxView
.animate(1)
.scaleBy(0.5)
.rotateBy(-0.5)
.translateBy(-50, -50)
.backgroundColor(.redColor())
```
## License

Fluent is under the MIT license.
