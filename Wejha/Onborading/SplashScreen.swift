//
//  SplashScreen.swift
//  Wejha
//
//  Created by Sara Alhumidi on 14/11/1444 AH.
//

import SwiftUI
struct SplashScreen: View {
    @State private var isAnimationComplete = false
    @State private var isActive = false
    @AppStorage("_shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 0.173, green: 0.247, blue: 0.251, alpha: 1).cgColor)
            
            Image("LogoIcon")
                .resizable()
                .frame(width: 182, height: 183.22)
                .scaleEffect(isAnimationComplete ? 2.0 : 1.0)
                .opacity(isAnimationComplete ? 0.0 : 1.0)
                .animation(.easeInOut(duration: 0.5))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            isAnimationComplete = true
                            isActive = true
                        }
                    }
                }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $isActive) {
            if shouldShowOnboarding {
                OnboradingView(shouldShoOnboarding: $shouldShowOnboarding)
            } else {
                // If onboarding is not required, navigate to your desired view here
                // For example: ContentView()
                MapUIView()
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
