# HRSCustomErrorHandling

[![CI Status](http://img.shields.io/travis/Hotel-Reservation-Service/HRSCustomErrorHandling.svg?style=flat-square)](https://travis-ci.org/Hotel-Reservation-Service/HRSCustomErrorHandling)
[![Version](https://img.shields.io/cocoapods/v/HRSCustomErrorHandling.svg?style=flat-square)](http://cocoadocs.org/docsets/HRSCustomErrorHandling)
[![License](https://img.shields.io/cocoapods/l/HRSCustomErrorHandling.svg?style=flat-square)](http://cocoadocs.org/docsets/HRSCustomErrorHandling)
[![Platform](https://img.shields.io/cocoapods/p/HRSCustomErrorHandling.svg?style=flat-square)](http://cocoadocs.org/docsets/HRSCustomErrorHandling)

HRSCustomErrorHandling is a small Framework that provides a base implementation for error handling in iOS applications. It deals with the problem to streamline the presentation of errors in various parts of an application as well as provide APIs to implement error specific recovery options the user of the application can choose from.

The presentation of an error is reduced to a single line of code that can be called from any view, view controller or any other class that inherits from `UIResponder`:

	[self presentError:error completionHandler:^(BOOL didRecover) {
		if (didRecover) {
	   		[self tryAgain];
    	}
    }];

This is all the code you need to implement in your view controllers if an operation that returns an `NSError` fails.


## Requirements

This project requires nothing more than the `Foundation` and `UIKit` frameworks.


## Installation

HRSCustomErrorHandling is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

    pod "HRSCustomErrorHandling", "~> 0.1"
    
Please note that we version our releases based on [Semantic Versioning](http://semver.org), so it is save to advice cocoapods to use every minor and patch version within a major version.

After installing the library through CocoaPods you should add the following line in your prefix header (.pch file):

    #import <HRSCustomErrorHandling/HRSCustomErrorHandling.h>
    

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

The example project shows a simple save operation that fails if the file in question already exists. The error handling asks you if you want to overwrite the file or not. If any other error occurs, a default error message is generated instead.


### Presenting an error

To present an error in your application you can call the following method in every instance of `UIView`, `UIViewController` or any other class that inherits from `UIResponder` to show a `UIAlertView` that represents the error:

    -[UIResponder presentError:completionHandler:]
    
You pass the `NSError` object you received as the first argument to this method. The second argument is a completion block that gets called once the user taps one of the options from the alert view and the error recovery attempt finished executing. The completion handler takes one argument, a `BOOL` that reports to you, whether error recovery was successful. If the recovery was successful it is save to try the same operation that previously lead to the error again and you should always do so.


### Creating an error

To create an error you need to provide a couple of informations the alert view will use to present and recover from the error. A basic error creation looks like this:

	HRSErrorRecoveryAttempter *attempter = [HRSErrorRecoveryAttempter new];
	[attempter addOkayRecoveryOption];
	
	NSString *localizedFailureReason = @"No internet connection";
	NSString *localizedRecoverySuggestion = @"Sorry, it seems like your device currently does not have access to the internet. Please try again later or check your network settings.";
	
	NSDictionary *userInfo = @{
							   NSLocalizedFailureReasonErrorKey: localizedFailureReason,
							   NSLocalizedRecoverySuggestionErrorKey: localizedRecoverySuggestion,
							   NSLocalizedRecoveryOptionsErrorKey: attempter.localizedRecoveryOptions,
							   NSRecoveryAttempterErrorKey: attempter
						   };
	
	NSError *error = [NSError errorWithDomain:MyErrorDomain code:MyErrorCode userInfo:userInfo];

When passing this error to `-[UIResponder presentError:completionHandler:]` it will create an alert view with the title that is stored in `NSLocalizedFailureReasonErrorKey` and the message stored in `NSLocalizedRecoverySuggestionErrorKey`. The alert view has only one button, labeled 'OK'. No recovery is done. This is the minimum information that is needed to present an error to the user.

To add recovery options, you call `addRecoveryOptionWithTitle:recoveryAttempt:` on the `HRSErrorRecoveryAttempter` once for every recovery option you want to add. It takes the localized title of the button and a block that contains the action that should be triggered if the user chooses this recovery option. The block returns a `BOOL` that describes whether error recovery was successful or not. **Please note** that you should always add at least one recovery option that returns NO. This gives the user the possibility to dismiss the alert view in the case that you think your error recovery was successful but the error still occurs on the next retry. To make this easier for you, the `HRSErrorRecoveryAttempter` has a couple of convenience methods that add such an option including a localized text.


## License

HRSCustomErrorHandling is available under the Apache 2 license. See the LICENSE file for more info.
