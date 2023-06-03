//
//  CameraAccess .swift
//  Wejha
//
//  Created by Sara Alhumidi on 14/11/1444 AH.
//

import SwiftUI

struct CameraAccess: View {
    @State var switchToMap : Bool = false
    @State var cantOpenCamera : Bool = false
    var body: some View {
        ZStack{
            Color(.black)
            VStack{
                Image("camera").resizable().frame(width: 80,height: 80)
                Text(LocalizedStringResource(stringLiteral: "Text61")).foregroundColor(.white).padding(.all,10)
                Text(LocalizedStringResource(stringLiteral:("Text62"))).foregroundColor(.gray)
                Text(LocalizedStringResource(stringLiteral:"Text63")).foregroundColor(.gray)
                Button {
                    switchToMap.toggle()
                } label: {
                    Text(LocalizedStringResource(stringLiteral:"Text64")).foregroundColor(.blue)
                }.padding(.all,10)
            }.padding(.bottom,123).padding([.leading,.trailing],10)
        }.edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $switchToMap, content: {
                MapUIView()
            })
            .fullScreenCover(isPresented: $cantOpenCamera, content: {
                CameraAccess()
            })
     
    }
}

struct CameraAccess_Previews: PreviewProvider {
    static var previews: some View {
        CameraAccess().environment(\.locale, .init(identifier: "ar"))
        CameraAccess().environment(\.locale, .init(identifier: "en"))
    }
}
