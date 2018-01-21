![Preview](https://github.com/ideil/ios-viper-arch/blob/master/viper_arch.png)

---------

ViperArch is a helper library for [VIPER architecture](https://www.objc.io/issues/13-architecture/viper/) written in Swift.

It is a default library that we use for all our applications on iOS at ideil. You can also check our [generamba templates for ViperArch](https://github.com/ideil/generamba-viper-arch).

## Documentation

Documentation is missing for this framework for now, but being a Swift port of [ViperMcFlurry](https://github.com/rambler-digital-solutions/ViperMcFlurry), you can find a lot of useful info there. It is strongly recommended to get acquainted with general principles of the architecture at [The Book of VIPER](https://github.com/strongself/The-Book-of-VIPER) repository.

For dependency injection we use [Swinject](https://github.com/Swinject/Swinject), so our default [viper_arch templates](https://github.com/ideil/generamba-viper-arch) include the framework out of the box.

If the VIPER module structure looks to verbose for you, there is a way to automate its generation using [Generamba](https://github.com/rambler-digital-solutions/Generamba).

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.3+ is required to build ViperArch 1.0+.

To integrate ViperArch into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ViperArch', '~> 1.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate ViperArch into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "ideil/ios-viper-arch" ~> 1.0
```

Run `carthage update` to build the framework and drag the built `ViperArch.framework` into your Xcode project.

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate ViperArch into your project manually.
