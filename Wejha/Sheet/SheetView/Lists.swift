//
//  Lists.swift
//  Wejha
//
//  Created by Sara Alhumidi on 11/11/1444 AH.
//

import SwiftUI


struct GateLists: View {
    @StateObject private var viewModels = FirebaseModel()
    var body: some View{
        VStack{
            List {
                ForEach(viewModels.places) { place in
                    
                    Text(place.Name).padding(12)
                    
                }
            }.listStyle(.plain)
            Spacer()
        }
        .onAppear() {
            print("GateLists appears. and data updates.")
            self.viewModels.FireGate()}
    }
}
struct RestRoomLists: View {
    @StateObject private var viewModels = FirebaseModel()
    var body: some View{
        VStack{
            List {
                ForEach(viewModels.places) { place in
                    Text(place.Name).padding(12)
                }
            }.listStyle(.plain)
            Spacer()
        }.onAppear() {
            print("GateLists appears. and data updates.")
            self.viewModels.FireRestRoom()}
    }
}
struct AblutionLists: View {
    @StateObject private var viewModels = FirebaseModel()
    var body: some View{
        VStack{
            List {
                ForEach(viewModels.places) { place in
                    Text(place.Name).padding(12)
                }
            }.listStyle(.plain)
            Spacer()
        }
        .onAppear() {
            print("GateLists appears. and data updates.")
            self.viewModels.FireAblution()}
    }
}
struct BusStationLists: View {
    @StateObject private var viewModels = FirebaseModel()
    var body: some View{
        VStack{
            List {
                ForEach(viewModels.places) { place in
                    
                    Text(place.Name).padding(12)
                }
            }.listStyle(.plain)
            Spacer()
        }
        .onAppear() {
            print("GateLists appears. and data updates.")
            self.viewModels.FireRestRoom()}
    }
}
struct AlSafaAlmarwahList: View {
    @StateObject private var viewModels = FirebaseModel()
    var body: some View{
        VStack{
            List {
                ForEach(viewModels.places) { place in
                    
                    Text(place.Name).padding(12)
                }
            }.listStyle(.plain)
            Spacer()
        }
        .onAppear() {
            print("AlSafaAlmarwahList appears. and data updates.")
            self.viewModels.FireAlsafaAlmarwaGates()}
    }
}
struct AlSahanList: View {
    @StateObject private var viewModels = FirebaseModel()
    var body: some View{
        VStack{
            List {
                ForEach(viewModels.places) { place in
                    
                    Text(place.Name).padding(12)
                }
            }.listStyle(.plain)
            Spacer()
        }
        .onAppear() {
            print("AlSafaAlmarwahList appears. and data updates.")
            self.viewModels.FireAlSahan()}
    }
}
struct LostFoundOfficeList: View {
    @StateObject private var viewModels = FirebaseModel()
    var body: some View{
        VStack{
            List {
                ForEach(viewModels.places) { place in
                    
                    Text(place.Name).padding(12)
                }
            }.listStyle(.plain)
            Spacer()
        }
        .onAppear() {
            print("AlSafaAlmarwahList appears. and data updates.")
            self.viewModels.FireLostFoundOffice()}
    }
}
struct BusStationList: View {
    @StateObject private var viewModels = FirebaseModel()
    var body: some View{
        VStack{
            List {
                ForEach(viewModels.places) { place in
                    
                    Text(place.Name).padding(12)
                }
            }.listStyle(.plain)
            Spacer()
        }
        .onAppear() {
            print("AlSafaAlmarwahList appears. and data updates.")
            self.viewModels.FireBusStation()}
    }
}
struct VerticalTransportationsList: View {
    @ObservedObject private var locationViewModel = LocationViewModel()
    @StateObject private var viewModels = FirebaseModel()
    var body: some View{
        VStack{
            List {
                ForEach(viewModels.places) { place in
                    Button {
                        locationViewModel.selectedPlace = place.Name
                       
                    } label: {
                        let _ =  print(locationViewModel.selectedPlace ?? "it is nil ")
                        Text(place.Name).padding(12)
                    }

                }
            }.listStyle(.plain)
            Spacer()
        }
        .onAppear() {
            print("AlSafaAlmarwahList appears. and data updates.")
            self.viewModels.FireVerticalTransportations()}
    }
}
struct WheelchairPlaceList: View {
    @StateObject private var viewModels = FirebaseModel()
    var body: some View{
        VStack{
            List {
                ForEach(viewModels.places) { place in
                    
                    Text(place.Name).padding(12)
                }
            }.listStyle(.plain)
            Spacer()
        }
        .onAppear() {
            print("AlSafaAlmarwahList appears. and data updates.")
            self.viewModels.FireWheelchairPlace()}
    }
}
 


struct GateLists_Previews: PreviewProvider {
    static var previews: some View {
        AlSahanList()
    }
}
