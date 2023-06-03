//
//  GoogleSheetsController.swift
//  UserAuthentication
//
//  Created by Rick DeAmicis on 5/17/23.
//

import Foundation
import UIKit
import PencilKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

class GoogleSheetsController {
    private var SPREADSHEET_ID = "1jsw7hEPgUXZn6hSMtrjjLdfgy4KhvzzY1u1ys2PHxt0"
    
    private let sheetService = GTLRSheetsService()
    
    
    func createNewTab(title: String) {
        sheetService.authorizer = GIDSignIn.sharedInstance.currentUser!.fetcherAuthorizer
        let batchUpdate = GTLRSheets_BatchUpdateSpreadsheetRequest.init()
        let sheetRequest = GTLRSheets_Request.init()
        let properties = GTLRSheets_SheetProperties.init()
        properties.title = title
        
        let addSheetRequest = GTLRSheets_AddSheetRequest.init()
        addSheetRequest.properties = properties
        
        sheetRequest.addSheet = addSheetRequest
        batchUpdate.requests = [sheetRequest]
        
        let query1 = GTLRSheetsQuery_SpreadsheetsBatchUpdate
            .query(withObject: batchUpdate, spreadsheetId: SPREADSHEET_ID)
        
        executeQuery(query: query1)
    }
    
    func executeQuery(query: GTLRQueryProtocol) {
        sheetService.executeQuery(query) { (ticket, something, error) in
            if let error = error {
                print("ERROR")
                print(error)
                print("------------------------------------\n\n")
            }
            
            if let sthg = something {
                print("SOMETHING!")
                print(sthg)
                print("------------------------------------\n\n")
            }
            print("TICKET!")
            print(ticket)
            print("------------------------------------\n\n")
        }
    }

    func writeToGoogleSheets(data: [[Any]], range: String) {
        sheetService.authorizer = GIDSignIn.sharedInstance.currentUser!.fetcherAuthorizer
        
        let valueRange = GTLRSheets_ValueRange.init()
        valueRange.values = data

        let query = GTLRSheetsQuery_SpreadsheetsValuesAppend
            .query(withObject: valueRange, spreadsheetId: SPREADSHEET_ID, range: range)
        query.valueInputOption = "USER_ENTERED"
        executeQuery(query: query)
    }
}
