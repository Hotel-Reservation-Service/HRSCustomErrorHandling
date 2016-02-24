# Credits

The project was initially developed in 2014 to have an easy to use and fast way to implement error handling on iOS. It takes the concepts that are used by Apple on OS X and implements them on iOS. There are slight adjustments done to take advantage of new features Objective-C has to offer (such as blocks), however the main concept remains the same.

The project is available under the Apache 2 license. Please see the LICENSE file for more information.


## Original Author

- Michael Ochs ([@_mochs](http://twitter.com/_mochs) / [michael.ochs@hrs.com](mailto:michael.ochs@hrs.com))


## Contributors
### v0.4.0
- Alex Hoppen - [Fixed issue when importing into Swift CocoaPod](https://github.com/Hotel-Reservation-Service/HRSCustomErrorHandling/pull/10)
### v0.3.0
- Roland Lindner - [Fix compiler error on uncasted objc_msgSend calls in Xcode 6.2](https://github.com/Hotel-Reservation-Service/HRSCustomErrorHandling/pull/6)

The list of contributors is updated with every new version tag that is added to the project.


## Honorable Mentions

- [Cocoa Error Handling and Recovery](http://realmacsoftware.com/blog/cocoa-error-handling-and-recovery) by James from RealMac Software  
This is a great writeup about the concepts behind this implementation.

- [Standard localizations](http://www.mczonk.de/standard-localizations/) by McZonk  
This is a blog post about the concept this library uses to generate the default recovery options like 'Cancel'. The private API mentioned in this project is removed in our implementation of this, but the concept stays the same.