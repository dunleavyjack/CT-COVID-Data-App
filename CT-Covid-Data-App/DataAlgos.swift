//
//  DataAlgos.swift
//  CT-Covid-Data-App
//
//  Created by Jack on 12/15/20.
//

import Foundation

func getPercentPositive(increasedTests: String, increasedCases: String) -> String {
    let increasedTestsFloat = (increasedTests as NSString).floatValue
    let increasedCasesFloat = (increasedCases as NSString).floatValue
    let percent = increasedCasesFloat/increasedTestsFloat * 100
    let percentString = String(format: "%.2f", percent)
    return percentString
}


func getPercentChange(today: String, yesterday: String) -> String {
    let todayFloat = (today as NSString).floatValue
    let yesterdayFloat = (yesterday as NSString).floatValue
    let difference = todayFloat - yesterdayFloat
    let differenceString = String(format: "%.2f", difference)
    return String(differenceString)
}

func addCommas(numberString: String) -> String {
    var numStr = numberString
    if numStr.count == 4 {
        numStr.insert(",", at: numStr.index(numStr.startIndex, offsetBy: 1))
    } else if numStr.count == 5 {
        numStr.insert(",", at: numStr.index(numStr.startIndex, offsetBy: 2))
    } else if numStr.count == 6 {
        numStr.insert(",", at: numStr.index(numStr.startIndex, offsetBy: 3))
    } else if numStr.count == 7 {
        numStr.insert(",", at: numStr.index(numStr.startIndex, offsetBy: 4))
        numStr.insert(",", at: numStr.index(numStr.startIndex, offsetBy: 1))
    }
    return numStr
}
