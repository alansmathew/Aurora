//
//  MainTabScreen.swift
//  Aurora
//
//  Created by Alan S Mathew on 2025-06-04.
//

import SwiftUI

enum MainTab : CaseIterable {
    case home
    case forecast
}


struct MainTabScreen: View {
    
    @State var tabSelection : MainTab = .home
    @State private var screenIds = Array(repeating: UUID(), count: MainTab.allCases.count)
    
    var selectionHandler : Binding<MainTab> { Binding {
        self.tabSelection
    } set: {
        self.tabSelection = $0
    }
}
    
    var body: some View {
        TabView(selection: selectionHandler) {
            HomeScreen()
                .tag(MainTab.home)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            ForecastScreen()
                .tag(MainTab.forecast)
                .tabItem {
                    Image(systemName: "clock")
                    Text("Forecast")
                }
            
        }
    }
}

//#Preview {
//    MainTabScreen()
//}
