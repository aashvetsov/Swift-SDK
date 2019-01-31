//
//  UserSevice.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2019 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

import SwiftyJSON

@objcMembers open class UserService: NSObject {
    
    open private(set) var currentUser: BackendlessUser?
    open var stayLoggedIn = false
    open private(set) var isValidUserToken: Bool {
        get {
            if getPersistentUserToken() != nil {
                return true
            }
            return false
        }
        set {
        }
    }
    
    private let processResponse = ProcessResponse.shared
    private let userDefaultsHelper = UserDefaultsHelper.shared
    
    private struct NoReply: Decodable {}
    
    open func describeUserClass(responseBlock: (([UserProperty]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "users/userclassprops", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: [UserProperty].self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    responseBlock(result as! [UserProperty])
                }
            }
        })
    }
    
    open func registerUser(user: BackendlessUser, responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["email": user.email, "password": user._password, "name": user.name]
        BackendlessRequestManager(restMethod: "users/register", httpMethod: .POST, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    responseBlock(result as! BackendlessUser)
                }
            }
        })
    }
    
    open func login(identity: String, password: String, responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["login": identity, "password": password]
        BackendlessRequestManager(restMethod: "users/login", httpMethod: .POST, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    self.setPersistentUser(currentUser: result as! BackendlessUser)
                    responseBlock(result as! BackendlessUser)
                }
            }
        })
    }
    
    // ******************************************************
    
    open func logingWithFacebook(accessToken: String, fieldsMapping: [String: String], responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["accessToken": accessToken, "fieldsMapping": fieldsMapping] as [String : Any]
        BackendlessRequestManager(restMethod: "users/social/facebook/sdk/login", httpMethod: .POST, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    self.setPersistentUser(currentUser: result as! BackendlessUser)
                    responseBlock(result as! BackendlessUser)
                }
            }
        })
    }
    
    open func loginWithTwitter(fieldsMapping: [String: String], responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["fieldsMapping": fieldsMapping, "redirect": true] as [String : Any]
        BackendlessRequestManager(restMethod: "users/social/oauth/twitter/request_url", httpMethod: .POST, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    self.setPersistentUser(currentUser: result as! BackendlessUser)
                    responseBlock(result as! BackendlessUser)
                }
            }
        })
    }
    
    /*open func loginWithGoogleSDK(responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
     
     }*/
    
    // ******************************************************
    
    open func update(user: BackendlessUser, responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = user.getProperties()
        BackendlessRequestManager(restMethod: "users/\(user.objectId)", httpMethod: .PUT, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    responseBlock(result as! BackendlessUser)
                }
            }
        })
    }
    
    open func logout(responseBlock: (() -> Void)!, errorBlock: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "users/logout", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            let result = self.processResponse.adapt(response: response, to: NoReply.self)
            if result is Fault {
                errorBlock(result as! Fault)
            }
            else {
                self.resetPersistentUser()
                responseBlock()
            }
        })
    }
    
    open func restorePassword(login: String, responseBlock: (() -> Void)!, errorBlock: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "users/restorepassword/\(login)", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            let result = self.processResponse.adapt(response: response, to: NoReply.self)
            if result is Fault {
                errorBlock(result as! Fault)
            }
            else {
                self.resetPersistentUser()
                responseBlock()
            }
        })
    }
    
    open func getUserRoles(responseBlock: (([String]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers: [String: String]? = nil
        BackendlessRequestManager(restMethod: "users/userroles", httpMethod: .GET, headers: headers, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: [String].self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    responseBlock(result as! [String])
                }
            }
        })
    }
    
    func setPersistentUser(currentUser: BackendlessUser) {
        self.currentUser = currentUser
        savePersistentUser(currentUser: self.currentUser!)
    }
    
    func resetPersistentUser() {
        self.currentUser = nil
        removePersistentUser()        
    }
    
    func savePersistentUser(currentUser: BackendlessUser) {
        var properties = self.currentUser?.getProperties()
        properties?["user-token"] = self.currentUser?.userToken
        self.currentUser?.setProperties(properties: properties!)
        userDefaultsHelper.savePersistentUserToken(userToken: currentUser.userToken!)
    }
    
    func getPersistentUserToken() -> String? {
        if let userToken = userDefaultsHelper.getPersistentUserToken() {
            return userToken
        }
        return nil
    }
    
    func removePersistentUser() {
        userDefaultsHelper.removePersistentUser()
    }
}
