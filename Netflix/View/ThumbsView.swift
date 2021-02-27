//
//  TVShowsView.swift
//  Netflix
//
//  Created by Raphael Cerqueira on 15/02/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ThumbsView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var title: String
    var endpoint: String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false, content: {
                HStack(spacing: 15) {
                    ForEach(viewModel.items ?? viewModel.placeholders) { item in
                        NavigationLink(destination: DetailsView(item: item), label: {
                            WebImage(url: URL(string: "\(Constants.imagesBaseUrl)\(item.poster_path ?? "")")!)
                                .resizable()
                                .frame(width: 160)
                                .cornerRadius(8)
                                .redacted(reason: item.poster_path == nil ? .placeholder : .init())
                                .foregroundColor(.gray)
                        })
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            })
            .frame(height: 220)
        }
        .onAppear {
            viewModel.fetchData(endpoint)
        }
    }
}

struct TVShowsView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbsView(viewModel: HomeViewModel(), title: "TV Shows", endpoint: "/discover/tv?api_key=\(Constants.apiKey)&language=pt-BR&sort_by=popularity.desc&include_adult=false&include_video=false&page=1")
            .background(Color.black)
    }
}
