//
//  ContentView.swift
//  MapCard
//
//  Created by Rawan on 14/11/1444 AH.
//
import SwiftUI

struct MapCardView: View {
    @Binding var tDistance: String
    @Binding var time: String
    @State var End : Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
                .shadow(radius: 1)
            VStack {
                Text("King Fahad Gate")
                    .fontWeight(.bold)
                    .padding(.trailing,50)
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 18,height:18)
                    Text(time)
                        .foregroundColor(Color.gray)
                }
                .padding(.trailing,100)
                HStack {
                    Image("pins")
                        .resizable()
                        .frame(width: 18,height:20)
                        
                    Text(tDistance)
                        .foregroundColor(Color.gray)
                }
                .padding(.trailing,100)
        
              }
            .padding(.trailing,120)
            HStack{
                Button(action: {
                    End.toggle()
                }, label: {
                    if(!End){
                        Text("Start")
                            .bold()
                            .foregroundColor(Color.white)
                            .frame(width: 98, height: 41)
                            .background(Color("Color"))
                        .cornerRadius(16)}
                    if(End){
                        Text("End")
                            .bold()
                            .foregroundColor(Color.white)
                            .frame(width: 98, height: 41)
                            .background(Color("Red"))
                            .cornerRadius(16)
                    }
                })
            }
            .padding(.leading,230)
            .padding(.bottom,-180)
            
            
        }
        .frame(width: 343, height: 132)
        .onTapGesture {
    
        }
    }
}

struct MapCardView_Previews: PreviewProvider {
    static var previews: some View {
        MapCardView(tDistance: .constant(""), time: .constant(""))
    }
}
