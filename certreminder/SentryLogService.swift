//
//  SentryLogService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 04/10/2019.
//  Copyright © 2019 Viktor Yamchinov. All rights reserved.
//

import Foundation
import Sentry
import os.log

class SentryLogService {
    /*
     Service for sending logs to Sentry.io
     */
    
    static let instance = SentryLogService()
    static var sentryClient = Client.shared
    private let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "application")
    
    private func createEvent(message: String, level: SentrySeverity, extra: [String: Any]?) -> Event {
        // Create Sentry event
        let event = Event(level: level)
        event.message = message
        if let extraInfo = extra {
            event.extra = extraInfo
        }
        return event
    }
    
    private func isOnTests() -> Bool {
        /*
         Check if running tests
         */
        if let value = ProcessInfo.processInfo.environment[TESTS_ENV], value == "true" {
            return true
        }
        return false
    }
    
    func logError(message: String, extra: [String: Any]?) {
        /*
         Sending error to sentry. If sentry not enabled - (for example in test environment) - log to default logger
         */
        if !self.isOnTests() {
            if let client = SentryLogService.sentryClient {
                let event = self.createEvent(message: message, level: .error, extra: extra)
                client.send(event: event) { (error) in
                    if let err = error {
                        let errorString = "Could not send sentry error. Error: \(err)"
                        os_log("%@", log: self.logger, type: .error, errorString)
                    }
                }
                return
            }
        }
        os_log("%@", log: self.logger, type: .error, message)
    }
}
