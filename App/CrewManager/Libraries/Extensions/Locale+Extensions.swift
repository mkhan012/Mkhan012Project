
//This is not my code, i took this from git hub link below
//http://git.addrenaline.nl/wouter/alerts-and-pickers/tree/master/Source/Extensions
import Foundation

extension Locale {
    
    static func locale(forCountry countryName: String) -> String? {
        return Locale.isoRegionCodes.filter { self.countryName(fromLocaleCode: $0) == countryName }.first
    }
    
    static func countryName(fromLocaleCode localeCode : String) -> String {
        return (Locale(identifier: "en_UK") as NSLocale).displayName(forKey: .countryCode, value: localeCode) ?? ""
    }
}
