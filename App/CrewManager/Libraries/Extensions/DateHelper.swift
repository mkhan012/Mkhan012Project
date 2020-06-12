
//This is not my code, i took this from git hub link below


import UIKit

extension Date {
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func monthNumberOfYear() -> Int? {
        return Calendar.current.dateComponents([.month], from: self).month
    }
    
    func dayNumberOfMonth() -> Int? {
        return Calendar.current.dateComponents([.day], from: self).day
    }
    
    func dayFromToday() -> Int? {
        return Calendar.current.dateComponents([.day], from: self, to: Date()).day
    }
    
    func isInSameYear(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
    }
}

class DateHelper: NSObject {
    
    static let sharedInstance = DateHelper()
    let dateFormatter: DateFormatter = DateFormatter()

    
    class func dateFromString(_ dateString: String?, dateFormat: String = K.ServerDateTimeFormat) -> Date? {
        
        if let dateString = dateString {
            
            let dateHelper = DateHelper.sharedInstance
            dateHelper.dateFormatter.dateFormat = dateFormat
            
            let dateObj = dateHelper.dateFormatter.date(from: dateString)
            return dateObj
            
        } else {
            return nil
        }
    }
    
    class func stringFromDate(_ date: Date, dateFormat: String = K.ServerDateTimeFormat) -> String? {
        
        let dateHelper = DateHelper.sharedInstance
        dateHelper.dateFormatter.dateFormat = dateFormat
        
        let dateStr = dateHelper.dateFormatter.string(from: date)
        return dateStr
    }
    
    class func dateStringFromString(_ dateString: String?,
                                    inputDateFormat: String = K.ServerDateTimeFormat,
                                    outputDateFormat: String = K.ClientDateTimeFormat) -> String? {
        
        if let dateObj = DateHelper.dateFromString(dateString, dateFormat: inputDateFormat) {
            
            return DateHelper.stringFromDate(dateObj, dateFormat: outputDateFormat)
            
        } else {
            return nil
        }
    }
    
    class func UTCFormattedCurrentDate() -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = K.ServerDateTimeFormat
        
        let currentDate = dateFormatter.string(from: Date())
     
        return dateFormatter.date(from: currentDate)!
    }
    
    class func UTCFormattedDate(_ date: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = K.ServerDateTimeFormat
        
        return dateFormatter.date(from: date)!
    }
    
    class func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
        
    }
    
    class func getDateStringForChat(_ date: Date, withoutTime: Bool = false) -> String {
        
        if let day = date.dayFromToday(), day <= 7 {
            if Calendar.current.isDateInToday(date) {
                if withoutTime {
                    return "\(String(describing: DateHelper.stringFromDate(date, dateFormat: K.TimeFormatShort2)!))"
                }
                return "today at \(String(describing: DateHelper.stringFromDate(date, dateFormat: K.TimeFormatShort2)!))"
            } else if Calendar.current.isDateInYesterday(date) {
                if withoutTime {
                    return "yesterday"
                }
                return "yesterday at \(String(describing: DateHelper.stringFromDate(date, dateFormat: K.TimeFormatShort2)!))"
            } else {
                let days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
                if let weekDay = date.dayNumberOfWeek() {
                    if withoutTime {
                        return days[weekDay-1]
                    }
                    return "\(days[weekDay-1]) at \(String(describing: DateHelper.stringFromDate(date, dateFormat: K.TimeFormatShort2)!))"
                } else {
                    return DateHelper.stringFromDate(date, dateFormat: K.ClientDateTimeFormat) ?? ""
                }
            }
            
        } else {
            if withoutTime {
                return DateHelper.stringFromDate(date, dateFormat: K.ClientDateFormat) ?? ""
            }
            return DateHelper.stringFromDate(date, dateFormat: K.ClientDateTimeFormat) ?? ""
        }
    }
    
    
    class func getDateStringForChatHeader(_ date: Date) -> String {
        
        if let day = date.dayFromToday(), day <= 7 {
            if Calendar.current.isDateInToday(date) {
                return "Today"
            } else if Calendar.current.isDateInYesterday(date) {
                return "Yesterday"
            } else {
                let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
                if let weekDay = date.dayNumberOfWeek() {
                    return "\(days[weekDay-1])"
                } else {
                    return DateHelper.stringFromDate(date, dateFormat: K.ClientDateFormat) ?? ""
                }
            }
            
        } else {
            if date.isInSameYear(date: Date()) {
                
                let days = ["Sun,", "Mon,", "Tue,", "Wed,", "Thu,", "Fri,", "Sat,"]
                let months = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"]
                
                return "\(days[date.dayNumberOfWeek()!-1]) \(date.dayNumberOfMonth()!) \(months[date.monthNumberOfYear()!-1])"
                
                
            } else {
                return DateHelper.stringFromDate(date, dateFormat: K.ClientDateFormat) ?? ""
            }
        }
    }
}
