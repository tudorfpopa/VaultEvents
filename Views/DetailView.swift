//
//  DetailView.swift
//  Events
//
//  Created by Tudor Popa on 06/08/2024.
//

import SwiftUI
import EventKit
import Foundation

// identifier for the different types of alerts to display after trying to add an event to the calendar
struct ActiveIdentifier: Identifiable {
    enum Choice {
        case eventAdded, noPermissions, otherError
    }
    
    var id: Choice
}


struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var alertID: ActiveIdentifier?
    let event: Event
    
    let store = EKEventStore()
    
    
    var body: some View {
        
        VStack {
            Image(event.images)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(event.title)
                                .font(.title)
                                .padding(.horizontal)
                                .fontWeight(.bold)
                            Spacer()
                            VStack {
                                Text("\(event.date) at \(event.time) \(event.isPM ? "PM" : "AM")")
                                    .fontWeight(.bold)
                                    .font(.subheadline)
                                .foregroundStyle(Color(red: 70/255, green: 70/255, blue: 70/255))
                                
                                HStack {
                                    //Image(systemName: "mappin.circle")
                                    Text(event.location)
                                }.foregroundStyle(Color(red: 70/255, green: 70/255, blue: 70/255))
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                        HStack {
                            if event.membersOnly {
                                HStack {
                                    Image(systemName: "lock")
                                        .padding([.leading], 7)
                                    Text("For the Vault members only")
                                        .fontWeight(.bold)
                                        .font(.subheadline)
                                        .padding([.bottom, .trailing, .top], 7)
                                }
                                .background(Color.red.opacity(0.4))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding([.top], 1)
                                .padding([.leading], 10)
                            } else {
                                HStack {
                                    Image(systemName: "lock.open")
                                        .padding([.leading], 7)
                                    Text("Open to non-members")
                                        .fontWeight(.bold)
                                        .font(.subheadline)
                                        .padding([.bottom, .trailing, .top], 7)
                                }
                                .background(Color.green.opacity(0.4))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding([.top], 1)
                                .padding([.leading], 10)
                            }
                            Spacer()
                            Button {
                                // TODO: action for RSVP button
                            } label: {
                                HStack {
                                    Image(systemName: "text.badge.checkmark")
                                    Text("RSVP here")
                                        .fontWeight(.bold)
                                        .font(.subheadline)
                                }
                                .padding(7)
                                .background(Color.black)
                                .foregroundStyle(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                            }
                        }
                        Text(event.description)
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward.circle.fill")
                        .tint(.black)
                }
                .font(.title)
            }
            ToolbarItem(placement: .principal) {
                Text("Event details")
                    .fontWeight(.bold)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    createCalendarEvent(event: event)
                } label: {
                    Image(systemName: "calendar.badge.plus")
                        .tint(.black)
                }
                .font(.title)
                
                
            }
            
        }.alert(item: $alertID) { alert in
            switch alert.id {
                case .eventAdded:
                    return Alert(title: Text("Event successfully added to calendar."))
                case .noPermissions:
                    return Alert(title: Text("Error"), message: Text("The application needs calendar access."),
                                 primaryButton: .default(Text("Go to Settings"), action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }),
                                 secondaryButton: .default(Text("Cancel"))
                    )
                case .otherError:
                    return Alert(title: Text("Error"), message: Text("An unknown error has occured."))
            }
            
        }
        
        
    }
    
    // saves the corresponding event to the calendar
    func createCalendarEvent(event: Event) {
        store.requestWriteOnlyAccessToEvents { granted, error in
            if granted {
                let calEvent = EKEvent(eventStore: store)
                calEvent.title = event.title
                let dateComponentsParse = event.date.split(separator: "/")
                guard dateComponentsParse.count == 3,
                      let month = Int(dateComponentsParse[0]),
                      let day = Int(dateComponentsParse[1]),
                      let year = Int(dateComponentsParse[2]) else {
                    print("Invalid date format")
                    return
                }
                // assuming the time is always in "hh:mm" format
                let timeComponents = event.time.split(separator: ":")
                guard timeComponents.count == 2,
                      let hour = Int(timeComponents[0]),
                      let minute = Int(timeComponents[1]) else {
                    print("Invalid time format")
                    return
                }
                let startHour = event.isPM ? hour + 12 : hour
                let startDateComponents = DateComponents(year: year, month: month, day: day, hour: startHour, minute: minute)
                let startDate = Calendar.current.date(from: startDateComponents)!
                calEvent.startDate = startDate
                calEvent.endDate = Calendar.current.date(byAdding: .hour, value: 2, to: startDate)!
                
                //add location
                calEvent.location = event.location
                
                // add the description of the event to the notes in the calendar
                calEvent.notes = event.description
                
                // add alarm one hour before
                let eventAlarm = EKAlarm(relativeOffset: -60*60)
                calEvent.addAlarm(eventAlarm)
                
                // store the event
                calEvent.calendar = store.defaultCalendarForNewEvents
                
                // now try to save the event, with error handling
                do {
                    try store.save(calEvent, span: .thisEvent)
                    print("Event added to calendar")
                    self.alertID = ActiveIdentifier(id: .eventAdded)
                } catch {
                    print("Error saving event: \(error)")
                    self.alertID = ActiveIdentifier(id: .noPermissions)
                }
            } else {
                if let error = error {
                    print("Access to calendar denied: \(error)")
                    self.alertID = ActiveIdentifier(id: .noPermissions)
                } else {
                    print("Access to calendar denied with no error")
                    self.alertID = ActiveIdentifier(id: .noPermissions)
                }
            }
        }
    }
}

#Preview {
    DetailView(event: Event(title: "Test event", description: "This is a test.", images: "testsimage", date: "1/1/1111", time: "5:55", membersOnly: true, isPM: true, location: "Humanities Building"))
}
