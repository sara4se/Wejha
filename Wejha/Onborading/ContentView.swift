//
//  d.swift
//  Wejha
//
//  Created by Sara Alhumidi on 13/11/1444 AH.
//

import SwiftUI
 
struct ContentView: View {
    @AppStorage("_shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    var body: some View {
        NavigationView {
            
            MapUIView()
        }
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
            OnboradingView(shouldShoOnboarding: $shouldShowOnboarding)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
