//
//  CardView.swift
//  Events
//
//  Created by Tudor Popa on 06/08/2024.
//

import Foundation
import SwiftUI

struct CardView: View {
    let event: Event
    var body: some View {
        VStack {
            Image(event.images)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(event.title)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.vertical, 5)
                        Spacer()
                        Text(event.date)
                            .font(.subheadline)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(Color(red: 80/255, green: 80/255, blue: 80/255))
                    }
                    
                    Text(event.description)
                        .lineLimit(2)
                }
            }.padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(red: 150/255, green: 150/250, blue: 150/255, opacity: 0.2), lineWidth: 0.25)
                .shadow(radius: 0.1)
        )
        .padding([.top, .horizontal])
    }
    
}

#Preview {
    CardView(event: Event(title: "Test event", description: "This is a test, we love you. XOXO, The Vault. Goodbye :)", images: "testsimage", date: "1/1/1111", time: "5:55", membersOnly: true, isPM: true, location: "Humanities Building", RSVPLink: "https://www.thevaultuwmadison.com/"))
}
