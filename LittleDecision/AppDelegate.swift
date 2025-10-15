//
//  AppDelegate.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/29.
//

import Sentry
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        SentrySDK.start { options in
            options.dsn = "https://a51608421af645fc8824915755586310@o4507787710627840.ingest.us.sentry.io/4508130349154304"
//            options.debug = true // Enabled debug when first installing is always helpful
            options.tracesSampleRate = 0.1
            options.profilesSampleRate = 0.1

            // Uncomment the following lines to add more data to your events
            // options.attachScreenshot = true // This adds a screenshot to the error events
            // options.attachViewHierarchy = true // This adds the view hierarchy to the error events
        }
        // Remove the next line after confirming that your Sentry integration is working.
//        SentrySDK.capture(message: "This app uses Sentry! :)")
        return true
    }
}
