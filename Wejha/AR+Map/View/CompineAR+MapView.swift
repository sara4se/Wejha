//
//  CompineAR+Map.swift
//  Wejha
//
//  Created by Sara Alhumidi on 01/11/1444 AH.
//

import SwiftUI

struct MapJourney: View {
    @State private var searchText :String? = ""
    @State private var tDistance: String = ""
    var body: some View {
        ZStack {
            Color.white // Set the background color to white
            
            Rectangle()
                .foregroundColor(Color.clear) // Set the background color to clear
            
        }
        .frame(width: 343, height: 132) // Set the frame size
        .background(Color.white) // Set the background color to white
        .overlay(
            GeometryReader { geo in
                Color.clear
                    .frame(width: 343, height: 132) // Set the frame size
                    .background(Color.clear)
                    .overlay(
                        Rectangle()
                            .frame(width: 343, height: 132) // Set the frame size
                            .foregroundColor(Color.clear)
                            .background(Color.clear)
                            .overlay(
                                
                                Text(tDistance)
                                    .foregroundColor(.black)
                                  )
                    )
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
        )
        .frame(width: 343, height: 132) // Set the frame size
        .position(x: 25 + 343 / 2, y: 695 + 132 / 2) // Set the position
    }
}

struct MapJourney_Previews: PreviewProvider {
    static var previews: some View {
        MapJourney()
    }
}
