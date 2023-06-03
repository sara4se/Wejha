//
//  sd.swift
//  Wejha
//
//  Created by Sara Alhumidi on 13/11/1444 AH.
//

import Foundation
import SwiftUI

struct OnboradingView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @Binding var shouldShoOnboarding: Bool
//    @State private var currentStep = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                
                Image("Group47")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
        
                VStack{
                    HStack{
                        Spacer()
                        Button(action: {
                            //                        shouldShoOnboarding.toggle()
                        }, label: {
                            Text("Skip")
                                .fontWeight(.semibold)
                                .kerning(1.2)
                        }).padding(.trailing)
                        Spacer()
                            .padding(.trailing)
                        
                        
                    }.padding()
                        .foregroundColor(.black)
                    Spacer()
                    
                    
                    
                    TabView {
                        PageView(
                            title: "Latest Technologies",
                            subtitle: "Open the camera and enjoy using AR map to reach your destination",
                            imageName: "Icon",
                            //ImageName2: "Group",
                            showsDismisButton: false,
                            shouldShoOnboarding: $shouldShoOnboarding
                        )
                        
                        PageView(
                            title: "Various Services",
                            subtitle: "Find out about the services offered at the Holy Mosque to facilitate your visit",
                            imageName: "Icon(1)",
                            //ImageName2: "Group",
                            showsDismisButton: false,
                            shouldShoOnboarding: $shouldShoOnboarding
                        )
                        
                        
                        PageView(
                            title: "Quick Access",
                            subtitle: "Explore the nearest places around you",
                            imageName: "Icon(2)",
                            //ImageName2: "Group",
                            showsDismisButton: true,
                            shouldShoOnboarding: $shouldShoOnboarding
                        )
                        
                    }
                    .tabViewStyle(PageTabViewStyle())
                }
            }
        }
    }
}

struct PageView: View {
    let title: String
    let subtitle: String
    let imageName: String
//    let ImageName2: String
    let showsDismisButton: Bool
    @Binding var shouldShoOnboarding: Bool
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .padding()
            Text(title)
                .font(.system(size: 32))
                .multilineTextAlignment(.center)
                .padding()
            
            Text(subtitle)
                .font(.system(size: 24))
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding()
            
            
            if showsDismisButton{
                Button(action: {
                    shouldShoOnboarding.toggle()
                }, label: {
                    Text("Get Started")
                        .bold()
                        .foregroundColor(Color.white)
                        .frame(width: 281, height: 41)
                        .background(Color("Green"))
                        .cornerRadius(6)
                })
            }
            
        }
    }
}
