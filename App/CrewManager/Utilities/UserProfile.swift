//
//  UserProfile.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import Foundation

extension Array where Element: NSCopying {
      func copy() -> [Element] {
            return self.map { $0.copy() as! Element }
      }
}


// User profile modile
open class UserProfile :NSObject{
    
    var uid:String! // user id
    var sex:String! // user gender
    var username:String! // user name
    var photoURL:String! // user profile
    var fname:String! // first name
    var lname:String! // last name
    var phoneNumber:String! // phone number
    var userType:String! // user type
    var email:String! // user email
    var address:String! // user address
    var acceptJobRequestUID:String! // job id
    var acceptJobDate:String! // job date
    var createdOn:String! // job created
    
    
    public override init() {}
    // constructore intitlizer with dictioary object
    public init(fromDictionary dictionary: [String:Any]) {
        
        acceptJobDate = dictionary["accepted_job_request_date"] as? String // accept job string
        acceptJobRequestUID = dictionary["accepted_job_request_uid"] as? String // accept job request id
        uid = dictionary["uid"] as? String //get user id
        sex = dictionary["sex"] as? String //get gender
        username = dictionary["username"] as? String //get username
        photoURL = dictionary["photoURL"] as? String //get photo url
        fname = dictionary["fname"] as? String //get first name
        lname = dictionary["lname"] as? String // get last name
        phoneNumber = dictionary["phone_number"] as? String // get phone number
        userType = dictionary["user_type"] as? String // get user type
        email = dictionary["email"] as? String // get emil
        address = dictionary["address"] as? String //get address
        createdOn = dictionary["created_on"] as? String//get created on
    }
    
    // get all date to dictioary
    public func toDictionary() -> [String:Any] {
        var dictionary: [String:Any] = [:]
        
        if createdOn != nil {
            dictionary["created_on"] = createdOn
        }
        if sex != nil {
            dictionary["sex"] = sex
        }
        if acceptJobDate != nil {
            dictionary["accept_job_request_date"] = acceptJobDate
        }
        if acceptJobRequestUID != nil {
            dictionary["accept_job_request_uid"] = acceptJobRequestUID
        }
        if uid != nil {
            dictionary["uid"] = uid
        }
        if username != nil {
            dictionary["username"] = username
        }
        if photoURL != nil {
            dictionary["photoURL"] = photoURL
        }
        if fname != nil {
            dictionary["fname"] = fname
        }
        if lname != nil {
            dictionary["lname"] = lname
        }
        if phoneNumber != nil {
            dictionary["phone_number"] = phoneNumber
        }
        if userType != nil {
            dictionary["user_type"] = userType
        }
         
        if email != nil {
            dictionary["email"] = email
        }
        if address != nil {
            dictionary["address"] = address
        }
        
        return dictionary
    }
}

// job request model
open class JobRequest :NSObject {
    
    var subject:String! // job subject
    var on:String! // job on
    var type:String! // job type
    var message:String! // job message
    var title:String! //job title
    var employeeUID:String! // employee id
    var managerUID:String! // manager id
    var uid:String! // user id
    var jobNumber:String! //job number
    var jobLocation:String! // job location
    var jobHour:String! // job hour
    var clientName:String! // client name
    var clientContantNumber:String! // client contact number
    var status:String! // job status
    var updateOn:String! // job update on
    var mangerName:String! // job manager
    var jobUID:String! // job id
    var employeeName:String! // employee name
    var jobTitle:String! // job title
    var jobHourPerDay:String! // job hour
    var acceptedJobRequestDate:String! // job request date
    var joiningDate:String! // job join date
    var jobDateTime:String! // job datetime
    var payRate:String! // job payrate
    
    
    public override init() {}
    //initlizer constructor with dictionary
    public init(fromDictionary dictionary: [String:Any]) {

        jobDateTime = dictionary["job_date_time"] as? String
        jobTitle = dictionary["job_title"] as? String
        employeeName = dictionary["employee_name"] as? String
        subject = dictionary["subject"] as? String
        message = dictionary["message"] as? String
        mangerName = dictionary["manger_name"] as? String
        status = dictionary["status"] as? String
        on = dictionary["on"] as? String
        type = dictionary["type"] as? String
        message = dictionary["message"] as? String
        title = dictionary["title"] as? String
        jobUID = dictionary["job_request_uuid"] as? String
        employeeUID = dictionary["employee_uid"] as? String
        managerUID = dictionary["manager_uid"] as? String
        jobNumber = dictionary["job_number"] as? String
        jobLocation = dictionary["job_location"] as? String
        jobHour = dictionary["job_hour"] as? String
        clientName = dictionary["client_name"] as? String
        clientContantNumber = dictionary["client_contant_number"] as? String
        updateOn = dictionary["status_update_on"] as? String
        jobHourPerDay = dictionary["jobHour_per_day"] as? String
        acceptedJobRequestDate = dictionary["accepted_job_request_date"] as? String
        employeeName = dictionary["employee_name"] as? String
        joiningDate = dictionary["joining_date"] as? String
        message = dictionary["message"] as? String
        payRate = dictionary["pay_rate"] as? String
        
    }
    
    public func toDictionary() -> [String:Any] {
        var dictionary: [String:Any] = [:]
        
        if payRate != nil {
            dictionary["pay_rate"] = payRate
        }
        if jobDateTime != nil {
            dictionary["job_date_time"] = jobDateTime
        }
        if jobHourPerDay != nil {
            dictionary["jobHour_per_day"] = jobHourPerDay
        }
        if acceptedJobRequestDate != nil {
            dictionary["accepted_job_request_date"] = acceptedJobRequestDate
        }
        if employeeName != nil {
            dictionary["employee_name"] = employeeName
        }
        if joiningDate != nil {
            dictionary["joining_date"] = joiningDate
        }
        if jobTitle != nil {
            dictionary["job_title"] = jobTitle
        }
        if employeeName != nil {
            dictionary["employee_name"] = employeeName
        }
        if subject != nil {
            dictionary["subject"] = subject
        }
        if message != nil {
            dictionary["message"] = message
        }
        if jobUID != nil {
            dictionary["job_request_uuid"] = jobUID
        }
        if mangerName != nil {
            dictionary["manger_name"] = mangerName
        }
        if updateOn != nil {
            dictionary["status_update_on"] = updateOn
        }
        if status != nil {
            dictionary["status"] = status
        }
        if on != nil {
            dictionary["on"] = on
        }
        if type != nil {
            dictionary["type"] = type
        }
        if message != nil {
            dictionary["message"] = message
        }
        if title != nil {
            dictionary["title"] = title
        }
        if employeeUID != nil {
            dictionary["employee_uid"] = employeeUID
        }
        if managerUID != nil {
            dictionary["manager_uid"] = managerUID
        }
        if jobNumber != nil {
            dictionary["job_number"] = jobNumber
        }
        if jobLocation != nil {
            dictionary["job_location"] = jobLocation
        }
        if jobHour != nil {
            dictionary["job_hour"] = jobHour
        }
        if clientName != nil {
            dictionary["client_name"] = clientName
        }
        if clientContantNumber != nil {
            dictionary["client_contant_number"] = clientContantNumber
        }
         
        return dictionary
    }
}
