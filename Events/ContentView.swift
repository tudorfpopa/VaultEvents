//
//  ContentView.swift
//  Events
//
//  Created by Tudor Popa on 06/08/2024.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var isLoading = true
    let events = Event.data()
    var body: some View {
        
        ZStack {
            
            if (isLoading==true) {
                SplashScreen()
                    .transition(.opacity)
                    .animation(.easeOut(duration: 1.5))
            } else {
                NavigationStack {
                    List {
                        ForEach(events) { event in
                            ZStack {
                                CardView(event: event)
                                NavigationLink(destination: DetailView(event: event)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            
                        }
                        .listRowSeparator(.hidden)
                        
                        
                    }
                    .navigationTitle("Vault Events")
                    .scrollContentBackground(.hidden)
                    .listStyle(.inset)
                }.environment(\.colorScheme, .light)
            }
            
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                //EventParser.parseEvents()
                withAnimation {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
