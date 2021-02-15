//
//  FeaturedView.swift
//  Netflix
//
//  Created by Raphael Cerqueira on 15/02/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeaturedView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        WebImage(url: URL(string: "\(Constants.imagesBaseUrl)\(viewModel.items?[0].poster_path ?? "")"))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .redacted(reason: viewModel.items == nil ? .placeholder : .init())
            .foregroundColor(.gray)
            .overlay(
                VStack {
                    HStack {
                        ForEach(0..<4) { i in
                            Text("Exciting")
                                .foregroundColor(.white)
                            
                            if i != 3 {
                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.top)
                    
                    HStack(spacing: 50) {
                        Button(action: {}, label: {
                            VStack {
                                Image(systemName: "plus")
                                    .font(.title)
                                
                                Text("My List")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                        })
                        
                        Button(action: {}, label: {
                            HStack {
                                Image(systemName: "arrowtriangle.right.fill")
                                    .font(.title)
                                
                                Text("Play")
                                    .fontWeight(.bold)
                            }
                            .frame(width: 100, height: 45)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(5)
                        })
                        
                        Button(action: {}, label: {
                            VStack {
                                Image(systemName: "i.circle")
                                    .font(.title)
                                
                                Text("Info")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                        })
                    }
                    .padding(.vertical)
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.clear]), startPoint: .bottom, endPoint: .top))
                , alignment: .bottom)
            .onAppear {
                viewModel.fetchData("/movie/popular?api_key=\(Constants.apiKey)")
            }
    }
}

struct FeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedView()
            .background(Color.black)
    }
}
