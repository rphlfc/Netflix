//
//  DetailsViewModel.swift
//  Netflix
//
//  Created by Raphael Cerqueira on 27/02/21.
//

import Foundation
import SwiftUI

class DetailsViewModel: ObservableObject {
    @Published var movie: Movie?
    @Published var similar: [Movie]?
    
    public var placeholders = Array(repeating: Movie(id: Int(UUID().uuidString), overview: nil, title: nil), count: 6)
    
    func get(_ movie: Movie) {
        let url = URL(string: "\(Constants.baseURl)/movie/\(movie.id!)?api_key=\(Constants.apiKey)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error fetching discover", error ?? "")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(Movie.self, from: data)
                DispatchQueue.main.async {
                    self.movie = result
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func similar(_ movie: Movie) {
        let url = URL(string: "\(Constants.baseURl)/movie/\(movie.id!)/similar?api_key=\(Constants.apiKey)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error fetching discover", error ?? "")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let similar = try JSONDecoder().decode(Similar.self, from: data)
                DispatchQueue.main.async {
                    self.similar = similar.results
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
