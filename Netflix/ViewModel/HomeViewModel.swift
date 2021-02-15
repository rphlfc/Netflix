//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Raphael Cerqueira on 18/01/21.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var items: [Movie]?
    
    public var placeholders = Array(repeating: Movie(id: Int(UUID().uuidString), overview: nil, title: nil), count: 10)
    
    func fetchData(_ endpoint: String) {
        let url = URL(string: "\(Constants.baseURl)\(endpoint)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error fetching discover", error ?? "")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(Discover.self, from: data)
                DispatchQueue.main.async {
                    self.items = result.results
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
