//
//  DetailsView.swift
//  Netflix
//
//  Created by Raphael Cerqueira on 27/02/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailsView: View {
    var item: Movie
    @StateObject var viewModel = DetailsViewModel()
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea(.all, edges: .all)
            
            VStack {
                HStack(spacing: 20) {
                    Button(action: { presentation.wrappedValue.dismiss() }, label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 23, weight: .bold))
                            .foregroundColor(.white)
                    })
                    
                    Spacer()
                    
                    Button(action: {}, label: {
                        Image("cast")
                            .foregroundColor(.white)
                    })
                    
                    Button(action: {}, label: {
                        Image("profile")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                    })
                }
                .padding()
                
                ZStack {
                    WebImage(url: URL(string: "\(Constants.imagesBaseUrl)\(viewModel.movie?.backdrop_path ?? "")"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                    
                    if let video = viewModel.movie?.video {
                        if video {
                            Button(action: {}, label: {
                                ZStack {
                                    Color.black.opacity(0.3)
                                    
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 29))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 60, height: 60, alignment: .center)
                                .clipShape(Circle())
                                .background(Circle().stroke(Color.red, lineWidth: 2))
                            })
                        }
                    }
                }
                .redacted(reason: viewModel.movie?.backdrop_path == nil ? .placeholder : .init())
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text(viewModel.movie?.title ?? "Loading...")
                                .font(.title)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .redacted(reason: viewModel.movie?.title == nil ? .placeholder : .init())
                            
                            HStack {
                                Text(String(viewModel.movie?.vote_average ?? 0))
                                    .foregroundColor(.green)
                                    .fontWeight(.heavy)
                                    .redacted(reason: viewModel.movie?.vote_average == nil ? .placeholder : .init())
                                
                                Text(formatDate(viewModel.movie?.release_date ?? "Loading...") ?? "Loading...")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 20)
                                    .redacted(reason: viewModel.movie?.release_date == nil ? .placeholder : .init())
                            }
                            .padding(.top)
                            
                            Button(action: {}, label: {
                                HStack {
                                    Image(systemName: "play.fill")
                                    
                                    Text("Play")
                                        .fontWeight(.bold)
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .padding(.horizontal)
                                .background(Color.white)
                                .cornerRadius(8)
                            })
                            .padding(.top)
                            
                            Button(action: {}, label: {
                                HStack {
                                    Image(systemName: "arrow.down.to.line.alt")
                                    
                                    Text("Download")
                                        .fontWeight(.bold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .padding(.horizontal)
                                .background(Color(#colorLiteral(red: 0.1532070339, green: 0.1579310298, blue: 0.1529752314, alpha: 1)))
                                .cornerRadius(8)
                            })
                            .padding(.top)
                            
                            Text(viewModel.movie?.overview ?? "Loading...")
                                .foregroundColor(.white)
                                .lineLimit(nil)
                                .padding(.top)
                                .redacted(reason: viewModel.movie?.overview == nil ? .placeholder : .init())
                            
                            HStack(spacing: 15) {
                                ActionButton(image: "plus", title: "My List", togglable: true, toggledImage: "checkmark")
                                
                                ActionButton(image: "hand.thumbsup", title: "Rate", togglable: true, toggledImage: "hand.thumbsup.fill")
                                
                                ActionButton(image: "paperplane", title: "Share")
                            }
                            .frame(height: 60)
                            .padding(.top)
                            
                            Rectangle()
                                .foregroundColor(.red)
                                .frame(width: 100, height: 8)
                                .padding(.top)
                        }
                        .padding(.horizontal)
                        
                        SimilarView(movie: item, viewModel: viewModel)
                    }
                })
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.get(item)
        }
    }
    
    func formatDate(_ value: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: value)
        if let date = date {
            let calendar = Calendar.current
            return String(calendar.component(.year, from: date))
        }
        
        return nil
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(item: Movie(), viewModel: DetailsViewModel())
    }
}

struct ActionButton: View {
    @State var isToggled = false
    var image: String
    var title: String
    var togglable = false
    var toggledImage: String?
    
    var body: some View {
        Button(action: {
            isToggled.toggle()
        }, label: {
            VStack(spacing: 15) {
                Image(systemName: togglable ? isToggled ? toggledImage! : image : image)
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.white)
                
                Text(title)
                    .foregroundColor(.gray)
            }
        })
        .frame(width: 60)
        .frame(maxHeight: .infinity)
    }
}

struct SimilarView: View {
    var movie: Movie
    @ObservedObject var viewModel: DetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("MORE LIKE THIS")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 16, alignment: .top)], spacing: 15, content: {
                ForEach(viewModel.similar ?? viewModel.placeholders) { item in
                    NavigationLink(destination: DetailsView(item: item), label: {
                        WebImage(url: URL(string: "\(Constants.imagesBaseUrl)\(item.poster_path ?? "")")!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(8)
                            .redacted(reason: item.poster_path == nil ? .placeholder : .init())
                            .foregroundColor(.gray)
                    })
                }
            })
        }
        .padding(.top)
        .onAppear(perform: {
            viewModel.similar(movie)
        })
    }
}
