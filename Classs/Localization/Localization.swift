//
//  Localization.swift
//  Movecoins
//
//  Created by eww090 on 04/02/20.
//  Copyright © 2020 eww090. All rights reserved.
//

import Foundation

//let secondLanguage = "ar-AE" // "sw"

/// Internal current language key
let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"

/// Default language. English. If English is unavailable defaults to base localization.
//let LCLDefaultLanguage = "en"

/// Name for language change notification
public let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"
public let LocalizeTabbarItems = "LocalizeTabbarItems"



enum Languages : String {
    case English = "en"
    case Spanish = "es"
}

// MARK: Language Setting Functions

open class Localize: NSObject {
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    open class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.firstIndex(of: "Base"), excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    /**
     Current language
     - Returns: The current language. String.
     */
    open class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    /**
     Change the current language
     - Parameter language: Desired language.
     */
    open class func setCurrentLanguage(_ language: String) {
        
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
        }
      //  UIView.appearance().semanticContentAttribute = (Localize.currentLanguage() == Languages.Greek.rawValue) ? .forceRightToLeft : .forceLeftToRight
        NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    open class func defaultLanguage() -> String {
        return Languages.English.rawValue
    }
    
    /**
     Resets the current language to the default
     */
    open class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    open class func displayNameForLanguage(_ language: String) -> String {
        let locale : Locale = Locale(identifier: currentLanguage())
        if let displayName = (locale as NSLocale).displayName(forKey: NSLocale.Key.languageCode, value: language) {
            return displayName
        }
        return String()
    }
}

extension String {
    var localized: String {
        let lang = UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? Languages.English.rawValue
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
