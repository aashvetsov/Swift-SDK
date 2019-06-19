//
//  CommandObject.swift
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

@objcMembers open class CommandObject: NSObject {

    open var type: String?
    open var connectionId: String?
    open var userId: String?
    open var data: Any?
    
    public static func decodeFromJson(_ json: [String: Any]) -> CommandObject {
        return ProcessResponse.shared.adaptToCommandObject(commandObjectDictionary: json)
    }
    
    public func encodeToJson() -> Any {
        return JSONUtils.shared.objectToJSON(objectToParse: self)
    }
}
