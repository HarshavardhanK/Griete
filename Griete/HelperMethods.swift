//
//  HelperMethods.swift
//  Griete
//
//  Created by Harshavardhan K on 07/04/18.
//  Copyright © 2018 Harshavardhan K. All rights reserved.
//

import Foundation
import UIKit

func cleanEmailAddress(email: String) -> String {
    
    let emailArr = Array(email)
    let indexOfAt = emailArr.index(of: "@")
    let indexOfPeriod = emailArr.index(of: ".")
    
    let firstPart = emailArr[0..<indexOfAt!]
    let secondPart = emailArr[indexOfAt!+1..<indexOfPeriod!]
    
    print(String(firstPart) + String(secondPart))
    
    return String(firstPart) + String(secondPart)
}

func getCurrentTime() -> Int {
    
    var currentTime: Int = 0
    
    let date = Date()
    let calendar = Calendar.current
    
    var hour = String(calendar.component(.hour, from: date))
    var minutes = String(calendar.component(.minute, from: date))
    var seconds = String(calendar.component(.second, from: date))
    
    var day = String(calendar.component(.day, from: date))
    var month = String(calendar.component(.month, from: date))
    let year = String(calendar.component(.year, from: date))
    
    minutes = cleanDate(time: minutes)
    hour = cleanDate(time: hour)
    seconds = cleanDate(time: seconds)
    
    day = cleanDate(time: day)
    month = cleanDate(time: month)
    
    let thisDay = day + month + year
    
    currentTime = Int(thisDay + hour + minutes + seconds)!
    
    return currentTime
    
}

func cleanDate(time: String) -> String {
    
    var cleanTime: String = ""
    
    if Int(time)! / 10 < 1 {
        cleanTime = "0" + String(time)
        
    } else {
        return time
    }
    
    return cleanTime
    
}

func parseTimeStamp(timeStamp: String) -> Int {
    
    var timeString: String
    
    let arr = Array(timeStamp)
    
    let breakPointIndex = arr.index(of: ":")
    var secondBreakPoint = -1
    
    var minutes = ""
    
    if arr.count > 5 {
        
        secondBreakPoint = secondOccurence(timeStamp: arr)
        minutes = String(arr[breakPointIndex! + 1...secondBreakPoint-1])
        
        print(secondBreakPoint)
        
    } else {
        minutes = String(arr[breakPointIndex! + 1...arr.count - 1])
        
    }
    
    let hours = String(arr[0...breakPointIndex! - 1])
    
    if secondBreakPoint != -1 {
        let seconds = String(arr[secondBreakPoint+1...arr.count-1])
        timeString = hours + minutes + seconds
        
    } else {
        timeString = hours + minutes
        
    }
    
    let time = Int(timeString)
    
    return time!
}

func secondOccurence(timeStamp: Array<Character>) -> Int {
    
    var count = 0
    
    for c in 0..<timeStamp.count {
        if timeStamp[c] == ":" {
            count += 1
        }
        
        if count == 2 {
            return c
        }
    }
    
    return -1
}



extension UITableView {
    
    func scrollToBottom(animated: Bool = true) {
        
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        
        if (rows > 0) {
            
            self.scrollToRow(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: true)
        }
    }
}

extension Character {
    
    var asciiValue: Int {
        
        get {
            
            let s = String(self).unicodeScalars
            return Int(s[s.startIndex].value)
        }
        
    }
}
