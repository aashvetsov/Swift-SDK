//
//  UnitOfWorkCreate.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2020 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

class UnitOfWorkCreate {
    
    private var countCreate = 1
    private var countBulkCreate = 1
    private var uow: UnitOfWork
    
    init(uow: UnitOfWork) {
        self.uow = uow
    }
    
    func create(tableName: String, entity: [String : Any]) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(operationType: .CREATE, tableName: tableName)
        let payload = TransactionHelper.shared.preparePayloadWithOpResultValueReference(entity)
        let operation = Operation(operationType: .CREATE, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .CREATE, uow: uow)
        return (operation, opResult)
    }
    
    func bulkCreate(tableName: String, entities: [[String : Any]]) -> (Operation, OpResult) {
        var preparedPayload = [[String : Any]]()
        for entity in entities {
            let payload = TransactionHelper.shared.preparePayloadWithOpResultValueReference(entity)
            preparedPayload.append(payload)
        }
        let opResultId = generateOpResultId(operationType: .CREATE_BULK, tableName: tableName)
        let operation = Operation(operationType: .CREATE_BULK, tableName: tableName, opResultId: opResultId, payload: preparedPayload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .CREATE_BULK, uow: uow)
        return (operation, opResult)
    }
    
    private func generateOpResultId(operationType: OperationType, tableName: String) -> String {
        var opResultId = TransactionHelper.shared.generateOperationTypeString(operationType) + tableName
        if operationType == .CREATE {
            opResultId += String(countCreate)
            countCreate += 1
        }
        else if operationType == .CREATE_BULK {
            opResultId += String(countBulkCreate)
            countBulkCreate += 1
        }
        return opResultId
    }
}
