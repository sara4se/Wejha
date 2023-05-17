//
//  MapIView.swift
//  Wejha
//
//  Created by Sara Alhumidi on 24/10/1444 AH.
//

import SwiftUI
import GoogleMaps
import UIKit




struct MapIViewUi: View {
    var body: some View {
        //24.793105, 46.746623
        MapLocationViewWrapper().edgesIgnoringSafeArea(.all)
    }
}

struct MapIViewUi_Previews: PreviewProvider {
    static var previews: some View {
        MapIViewUi()
    }
}
