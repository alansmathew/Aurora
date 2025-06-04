//
//  HomeViewModel.swift
//  Aurora
//
//  Created by Alan S Mathew on 2025-06-02.
//

import Foundation
import Combine

struct CustomError : Identifiable {
    var id : String { title }
    let title : String
    let description : String
    let isSuccess : Bool = false
    let isAgree : Bool = false
}

class HomeViewModel : ObservableObject {
    private var cancellable = Set<AnyCancellable>()
    
    @Published var isLoading : Bool = false
    @Published var hasError : CustomError?
    @Published var kpIndexData : KpIndexModel?
    @Published var kpEntries: [KpIndexEntry] = []
    
    func getKpIndexData(){
        guard !isLoading else {return}
    
        guard let url = URL(string: APIConstants.getKPIndex1 ) else {
            hasError = CustomError(title: "Invalid URL", description: "There is something wrong with the URL of your request"); return
        }
        
        isLoading = true
        hasError = nil
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        URLSession.shared.dataTaskPublisher(for: url)
            .handleEvents(receiveOutput: { output in
                if let response = output.response as? HTTPURLResponse {
                    print("📡 Status Code: \(response.statusCode)")
                }
                if let body = String(data: output.data, encoding: .utf8) {
                    print("📦 Raw Response Body: \(body)")
                }
            })
            .map{$0.data}
            .decode(type: KpIndexModel.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .sink{ completion in
                self.isLoading = false
                print("comes here")
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                    self.hasError = CustomError(title: "Error", description: error.localizedDescription)
                }
            } receiveValue: { responseData in
                self.isLoading = false
                self.kpIndexData = responseData
                print(self.kpIndexData)
                self.kpEntries = []
                self.load(from: responseData)
            }
            .store(in: &cancellable)
    }
    
    func load(from model: KpIndexModel) {
        kpEntries = zip(model.datetime, model.kp).map { date, kp in
            KpIndexEntry(date: date, kp: kp)
        }
    }
    
}
