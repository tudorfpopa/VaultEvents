//
//  Event.swift
//  Events
//
//  Created by Tudor Popa on 06/08/2024.
//

import Foundation

struct Event: Identifiable {
    
    // array for storing the parsed events
    static var parsedEvents: [Event] = [
        Event(title: "Test event", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", images: "testsimage", date: "12/5/2024", time: "10:50", membersOnly: true, isPM: false, location: "Humanities building", RSVPLink: "https://www.thevaultuwmadison.com/"),
        Event(title: "Second test", description: "This is a second test", images: "uwmadison", date: "11/6/2024", time: "8:07", membersOnly: false, isPM: true, location: "Engineering hall", RSVPLink: "https://www.thevaultuwmadison.com/"),
        Event(title: "Third test", description: "This is a third test", images: "testsimage", date: "10/10/2024", time: "9:46", membersOnly: true, isPM: true, location: "School of human Ecology", RSVPLink: "https://www.thevaultuwmadison.com/"),
        Event(title: "Fourth test", description: "This is a fourth test to see if the calendar alarm works", images: "testsimage", date: "8/7/2024", time: "5:47", membersOnly: true, isPM: true, location: "James Madison Park", RSVPLink: "https://www.thevaultuwmadison.com/")
    ];
    
    let id = UUID()
    let title: String
    let description: String
    let images: String
    let date: String
    let time: String
    let membersOnly: Bool
    let isPM: Bool
    let location: String
    let RSVPLink: String
    
    
    static func data() -> [Event] {
        EventParser.parseEvents()
        return parsedEvents
    }
    
}
