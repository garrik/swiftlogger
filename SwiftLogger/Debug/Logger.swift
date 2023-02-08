//
//  Logger.swift
//  SwiftLogger
//
//  Created by Sauvik Dolui on 03/05/2017.
//  Copyright © 2016 Innofied Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

/// Enum which maps an appropiate symbol which added as prefix for each log message
///
/// - error: Log type error
/// - info: Log type info
/// - debug: Log type debug
/// - verbose: Log type verbose, aka trace
/// - warning: Log type warning
/// - severe: Log type severe, aka critical
enum LogEvent: Int {
    case s = 1 // severe
    case e = 2 // error
    case w = 3 // warning
    case i = 4 // info
    case d = 5 // debug
    case v = 6 // verbose
}

extension LogEvent {
  static func <= (lhs: LogEvent, rhs: LogEvent) -> Bool {
    return lhs.rawValue <= rhs.rawValue
  }
}

extension LogEvent: CustomStringConvertible {
  
    var description: String {
      switch self {
      case .s: return "S"
      case .e: return "E"
      case .w: return "W"
      case .i: return "I"
      case .d: return "D"
      case .v: return "V"
      }
    }
}


/// Wrapping Swift.print() within DEBUG flag
///
/// - Note: *print()* might cause [security vulnerabilities](https://codifiedsecurity.com/mobile-app-security-testing-checklist-ios/)
///
/// - Parameter object: The object which is to be logged
///
func printer(_ string: String) {
    // Only allowing in DEBUG mode
    #if DEBUG
    Swift.print("\(Date().toString()) \(string)")
    #endif
}

class Log {
    // Allow to replace printer method, e.g. to use NSLog
    public static var print = printer
    public static var level = LogEvent.d

    static var dateFormat = "yyyy-MM-dd HH:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    private static func isLogged(_ logEvent: LogEvent) -> Bool {
      return logEvent <= level
    }

    // MARK: - Logging methods
    
    
    /// Logs error messages on console with prefix `E`
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func e( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        log(object, logEvent: LogEvent.e, filename: filename, line: line, column: column, funcName: funcName)
    }
    
    /// Logs info messages on console with prefix `I`
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func i ( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        log(object, logEvent: LogEvent.i, filename: filename, line: line, column: column, funcName: funcName)
    }
    
    /// Logs debug messages on console with prefix `D`
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func d( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        log(object, logEvent: LogEvent.d, filename: filename, line: line, column: column, funcName: funcName)
    }
    
    /// Logs messages verbosely on console with prefix `V`
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func v( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        log(object, logEvent: LogEvent.v, filename: filename, line: line, column: column, funcName: funcName)
    }
    
    /// Logs warnings verbosely on console with prefix `W`
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func w( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        log(object, logEvent: LogEvent.w, filename: filename, line: line, column: column, funcName: funcName)
    }
    
    /// Logs severe events on console with prefix `S`
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func s( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        log(object, logEvent: LogEvent.s, filename: filename, line: line, column: column, funcName: funcName)
    }
    
    
    /// Extract the file name from the file path
    ///
    /// - Parameter filePath: Full file path in bundle
    /// - Returns: File Name with extension
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }

  /// Logs messages on console with a prefix according to the logEvent parameter
  ///
  /// - Parameters:
  ///   - object: Object or message to be logged
  ///   - logEvent: Enum that determine the prefix need to be added in the beginning of the log message
  ///   - filename: File name from where loggin to be done
  ///   - line: Line number in file from where the logging is done
  ///   - column: Column number of the log message
  ///   - funcName: Name of the function from where the logging is done
  private class func log(_ object: Any, logEvent: LogEvent, filename: String, line: Int, column: Int, funcName: String) {
      guard isLoggingEnabled, isLogged(logEvent) else {
          return
      }
      Log.print("\(logEvent)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
  }
}

internal extension Date {
    func toString() -> String {
        return Log.dateFormatter.string(from: self as Date)
    }
}
