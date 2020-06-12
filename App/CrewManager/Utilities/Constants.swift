//
//  Constants.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import Foundation
import UIKit



//UserTypes
public enum UserTypes: String {
    //user type for manager
    case manger = "00-manager"
    //user type for employee
    case employee = "00-employee"
}


//K is for constant
class K {
    /*
     Firebase Data base Tree Name
     */
    //Emplyoee Tree for Employee data store in firebase
    static let employeeTree = "00-employee"
    //manager Tree for manager data store in firebase
    static let managerTree = "00-manager"
    //inbox Tree for inbox data store in firebase
    static let inboxTree = "inbox"
    //sent Tree for sent data store in firebase
    static let sentTree = "sent"
    //Jobs request Tree for Jobs request data store in firebase
    static let requestUUID = "job_request_uuid"
    //user profile request Tree for user profile data store in firebase
    static let profileTree = "profile"
    //accepted Jobs requested for accepted Jobs requested data store in firebase
    static let acceptedJobRequestTree = "accepted_job_request"
    //time table Tree for time table data stored in firebase
    static let timeTable = "time_table"
    //Number of key use for store data in fire ase
    static let numberOfHours = "number_of_hours"
    
    
    // Data type
    static let StatuKey = "status"
    static let RejectKey = "reject"
    static let PendingKey = "pending"
    static let StatusUpdateOnKey = "status_update_on"
    static let AcceptedJobRequestUIDKey = "accepted_job_request_uid"
    static let AcceptedJobRequestDataKey = "accepted_job_request_date"
    static let messageTypeJobRequest = "job_request"
    static let messageTypeResponse = "job_request_response"
    
    
    static let ContentType = "image/jpg"
    static let FontNameRobotoBlack = "Roboto-Black"
    static let FontNameRobotoBold = "Roboto-Bold"
    static let FontNameRobotoItalic = "Roboto-Italic"
    static let FontNameRobotoLight = "Roboto-Light"
    static let FontNameRobotoMedium = "Roboto-Medium"
    static let FontNameRobotoRegular = "Roboto-Regular"
    static let FontNameRobotoThin = "Roboto-Thin"
    static let FontNameRobotoCondensedBold = "RobotoCondensed-Bold"
    static let FontNameRobotoCondensedRegular = "RobotoCondensed-Regular"
    
    
    static let ServerDateTimeFormat = "yyyy-MM-dd HH:mm:ss"
    static let ServerDateFormat = "yyyy-MM-dd"
    static let ClientDateTimeFormat = "MM/dd/yyyy hh:mm aa"
    static let ClientDateFormat = "MM/dd/yyyy"
    static let ClientDayWithTimeFormat = "EEE hh:mm aa"
    static let DateTimeFormatStandard3 = "MM/dd/yyyy HH:mm"
    static let TimeFormatShort = "HH:mm:ss"
    static let TimeFormatShort2 = "hh:mm aa"
    static let TimeFormatShort3 = "HH:mm"
    
    
    static let GenderOptions = ["Male", "Female", "Others"]
    
    static let mangerMenu = ["Crew", "Jobs", "Time Sheets"]
    static let employerMenu = ["Job requests", "My Sheets", "My Shifts"]
    
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    
    static let DefaultHeaderHeight: CGFloat = K.IS_IPAD ? 250 : 220
    static let DefaultFooterHeight: CGFloat = K.IS_IPAD ? 140 : 100
}

//reference class to get views from story board from nib
class R {
    
    class StoryboardRef {
        
        static let Main : UIStoryboard = UIStoryboard(name: R.Storyboards.Main, bundle: nil)
        static let JMPickerStoryboard : UIStoryboard = UIStoryboard(name: R.Storyboards.JMPicker, bundle: nil)
        static let EmployeeStoryboard : UIStoryboard = UIStoryboard(name: R.Storyboards.Employee, bundle: nil)
    }
    
    class Storyboards {
        
        static let Main = "MainStoryboard"
        static let JMPicker = "JMPickerStoryboard"
        static let Employee = "EmployeerStoryboard"
    }
    
    class Nibs {
        static let Dashboardell = String(describing: ListTableViewCell.self)
        static let MainMenuCell = "MainMenuCell"
        static let LocationCell = "LocationCollectionViewCell"
        static let SettingCell = "SettingTableViewCell"
        static let DashMenuCell = String(describing: DashboardCollectionViewCell.self)
        static let GeneralCollectionReusableView = "GeneralCollectionReusableView"
        static let EmployeeCell = String(describing: EmployeeTableViewCell.self)
        static let MessageCell = String(describing: MessageTableViewCell.self)
    }
    
    class CellIdentifiers {
        static let Dashboardell = String(describing: ListTableViewCell.self)
        static let MainMenuCell = "MainMenuCell"
        static let LocationCell = "LocationCollectionViewCell"
        static let SettingCell = "SettingTableViewCell"
        static let DashMenuCell = String(describing: DashboardCollectionViewCell.self)
        static let GeneralCollectionReusableView = "GeneralCollectionReusableView"
        static let EmployeeCell = String(describing: EmployeeTableViewCell.self)
        static let MessageCell = String(describing: MessageTableViewCell.self)
    }
    
    class ViewControllerIds {
        
        static let LoginVC: String = String(describing: LoginViewController.self)
        static let SignupVC: String = String(describing: SingupViewController.self)
        static let ForgotPasswordVC: String = String(describing: ForgotPasswordViewController.self)
        static let DahboardCollection:String = String(describing: ManagerDashboardViewController.self)
        static let JobMessagesVC:String = String(describing: JobMessagesViewController.self)
        static let EmployeeVC:String = String(describing: EmployeeViewController.self)
        static let SettingVC:String = String(describing: SettingViewController.self)
        static let dashboardNav = "ManagerDashboardNavigation"
        static let DetailEmployeeVC:String = String(describing: DetailEmployeeViewController.self)
        static let AddJobMessagesVC:String = String(describing: AddJobMessagesViewController.self)
        static let WellComeVC:String = String(describing: WellComeViewController.self)
        static let ProfileUpdateVC:String = String(describing: ProfileUpdateViewController.self)
        static let jobRequestVC:String = String(describing: JobRequestViewController.self)
        static let MySheetsVC:String = String(describing: MySheetsViewController.self)
        static let ViewJobRequestVC:String = String(describing: ViewJobRequestViewController.self)
        static let MessageVC:String = String(describing: MessageViewController.self)
        static let JobsVC = String(describing: JobsViewController.self)
    }
    
    class Images {
        
    }
    
    class ThemeColor {
        
        static let selectedColor = UIColor.purple
        static let unSelectedColor = UIColor.white
        static let TableViewCellSelectedColor = UIColor(hexString: "#D1D1D6")
        static let DarkTextColor = UIColor(red: 47.0/255.0, green: 47.0/255.0, blue: 47.0/255.0, alpha: 1.0)
        static let ToastBackgroundColor = UIColor(red: 17.0/255.0, green: 71.0/255.0, blue: 62.0/255.0, alpha: 1.0)
        static let BlueBorderColor = UIColor(red: 1.0/255.0, green: 140.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        static let pendingColor = UIColor(red: 204.0/255.0, green: 204/255.0, blue: 0.0/255.0, alpha: 1.0)
        static let acceptedColor = UIColor(red: 76.0/255.0, green: 113/255.0, blue: 0.0/255.0, alpha: 1.0)
        static let rejectedColor = UIColor(red: 153.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    
    class Fonts {
        static let SmallTextFont = UIFont.robotoRegular(K.IS_IPAD ? 15 : 13.0)
        static let NormalTextFont = UIFont.robotoRegular(K.IS_IPAD ? 17 : 15.0)
        static let AppPrimaryFont = UIFont.robotoRegular(K.IS_IPAD ? 18 : 16.0)
        static let AppMediumFont = UIFont.robotoRegular(K.IS_IPAD ? 20 : 18.0)
        static let AppBoldFont = UIFont.robotoBold(K.IS_IPAD ? 17 : 15.0)
        static let AppMainHeaderBoldFont = UIFont.robotoBold(K.IS_IPAD ? 26.0 : 22.0)
        
    }
}
