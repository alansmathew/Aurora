//
//  HomeScreen.swift
//  Aurora
//
//  Created by Alan S Mathew on 2025-06-02.
//

import SwiftUI
import Charts

struct HomeScreen: View {
    @StateObject private var ViewModel : HomeViewModel = HomeViewModel()
    
    var body: some View {
        ZStack{
            if ViewModel.isLoading {
                ProgressView()
                    .tint(.blue)
            }
            
            VStack {
                Chart {
                    ForEach(ViewModel.kpEntries) { entry in
                        LineMark(
                            x: .value("Time", entry.date),
                            y: .value("Kp Index", entry.kp)
                        )
                        .foregroundStyle(.blue)
                        .interpolationMethod(.catmullRom)
                    }
                    
                    RuleMark(y: .value("Kp = 5", 5))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                        .foregroundStyle(.red)
                        .annotation(position: .top, alignment: .leading) {
                            Text("Aurora Threshold (Kp = 5)")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                }
                .chartYScale(domain: 0...9)
                .frame(height: 300)
                .padding()
            
                Spacer()
                
                Button{
                    ViewModel.getKpIndexData()
                } label:{
                    HStack{
                        Spacer()
                        Text("Get KP index")
                            .padding()
                            .foregroundStyle(Color.white)
                        Spacer()
                    }
                }
                .background(Color.blue.gradient)
                .cornerRadius(8)
                .padding()
            }
            .alert(item: $ViewModel.hasError) { data in
                Alert(title: Text(data.title), message: Text(data.description), dismissButton: .default(Text("Got it")))
            }
        }
    }
}

#Preview {
    HomeScreen()
}
