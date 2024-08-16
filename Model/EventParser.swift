//
//  EventParser.swift
//  Events
//
//  Created by Tudor Popa on 12/08/2024.
//


import Foundation
import CoreXLSX

struct EventParser {
    
    // converts column reference to its corresponding letter string
    static func columnLetter(from reference: String) -> String {
        return String(reference.prefix { $0.isLetter })
    }
    
    // converts a date from the excel serial format to a human readable one
    static func excelSerialDateToDate(serial: Int) -> Date? {
        let baseDate = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1))!
        let date = Calendar.current.date(byAdding: .day, value: serial - 2, to: baseDate)
        return date
    }
    
    // loads excel file using the CoreXLSX library
    static func loadFile() -> XLSXFile {
        // (forResource: "events", ofType: "xlsx")
        if let filepath = Bundle.main.path(forResource: "events", ofType: "xlsx") {
            let fileURL = URL(fileURLWithPath: filepath)
            let file = try XLSXFile(filepath: fileURL.path)
            guard let file = XLSXFile(filepath: filepath) else {
                fatalError("XLSX file at \(filepath) is corrupted or does not exist")
            }
            return file
        } else {
            print("File not found.")
            fatalError("XLSX file at is corrupted or does not exist")
        }
    }
    
    // parses events from .xlsx excel file and adds them to the data array in the Events class to display in the app
    static func parseEvents() {
        
                let file = loadFile()
                guard let sharedStrings = try? file.parseSharedStrings() else {
                    debugPrint("shared string obtain failed")
                    return
                }
                                
                do {
                    for wbk in try file.parseWorkbooks() {
                        for (name, path) in try file.parseWorksheetPathsAndNames(workbook: wbk) {
                            if let worksheetName = name {
                                print("This worksheet has a name: \(worksheetName)")
                            }
                            
                            let worksheet = try file.parseWorksheet(at: path)
                            for row in worksheet.data?.rows.dropFirst() ?? [] {
                                
                                var title = ""
                                var time = ""
                                var location = ""
                                var isPM = false
                                var description = ""
                                var images = ""
                                var date = ""
                                var membersOnly = false
                                
                                for c in row.cells {
                                    let ref = "\(c.reference)"
                                    let col = columnLetter(from: ref)
                                    
                                    switch col {
                                    case "A": // title
                                        //title = c.stringValue
                                        print(c.stringValue(sharedStrings)!)
                                        title = c.stringValue(sharedStrings)!
                                    case "B": // description
                                        print(c.stringValue)
                                        description = c.stringValue(sharedStrings)!
                                    case "C": // date
                                        print(c.stringValue)
                                        let serialDate = Int(c.stringValue(sharedStrings)!)
                                        if let convertedDate = excelSerialDateToDate(serial: serialDate!) {
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateStyle = .medium
                                            //print(dateFormatter.string(from: date))
                                            date = dateFormatter.string(from: convertedDate)
                                        } else {
                                            print("Invalid date")
                                        }
                                        print(date)
                                    case "D": // time
                                        print(c.stringValue)
                                        isPM = (c.stringValue(sharedStrings)!).contains("PM")
                                        let toRemove = isPM ? "PM" : "AM"
                                        time = c.stringValue(sharedStrings)!.replacingOccurrences(of: toRemove, with: "")
                                    case "E": // location
                                        print(c.stringValue)
                                        location = c.stringValue(sharedStrings)!
                                    case "F": // images
                                        print(c.stringValue)
                                        images = c.stringValue(sharedStrings)!
                                    case "G": // members only
                                        print(c.stringValue)
                                        membersOnly = c.stringValue(sharedStrings)!.contains("yes")
                                    default:
                                        print("Extra column \(col) read. It was not handled.")
                                    }
                                }
                                
                                let toCreate = Event(title: title, description: description, images: images, date: date, time: time, membersOnly: membersOnly, isPM: isPM, location: location, RSVPLink: "https://www.thevaultuwmadison.com/")
                                Event.parsedEvents.append(toCreate)
                                print(Event.parsedEvents)
                                print(toCreate)
                            }
                        }
                    }
                } catch {
                    print("Error parsing XLSX file: \(error)")
                }
            }
}
