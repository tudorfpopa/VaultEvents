//
//  SplashScreen.swift
//  Events
//
//  Created by Tudor Popa on 11/08/2024.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack {
            Image(systemName: "calendar.circle.fill")
            
            Text("The Vault")
        }.font(.title)
            .fontWeight(.bold)
    }
}

#Preview {
    SplashScreen()
}
