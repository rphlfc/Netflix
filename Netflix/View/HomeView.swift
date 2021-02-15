//
//  HomeView.swift
//  Netflix
//
//  Created by Raphael Cerqueira on 15/02/21.
//

import SwiftUI

struct HomeView: View {
    @StateObject var headerData = HeaderViewModel()
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea(.all, edges: .all)
            
            HeaderView()
                .zIndex(1)
                .offset(y: headerData.headerOffset)
            
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack {
                    FeaturedView()
                    
                    ThumbsView(title: "TV Shows", endpoint: "/discover/tv?api_key=\(Constants.apiKey)")
                        .padding(.top)
                    
                    ThumbsView(title: "Trending Now", endpoint: "/trending/all/day?api_key=\(Constants.apiKey)")
                        .padding(.top)
                    
                    Spacer()
                }
                // for a follow along video implementation check
                // https://www.youtube.com/watch?v=FIwEltBimrM
                .overlay(
                    // geometry reader for getting offset values
                    GeometryReader { proxy -> Color in
                        let minY = proxy.frame(in: .global).minY
                        
                        DispatchQueue.main.async {
                            // storing initial minY value
                            if headerData.startMinY == 0 {
                                headerData.startMinY = minY
                            }
                            
                            // getting exact offset value by subtracting current from start
                            let offset = headerData.startMinY - minY
                            
                            // getting scroll direction
                            if offset > headerData.offset {
                                // if top hiding header view
                                
                                // same clearing bottom offset
                                headerData.bottomScrollOffset = 0
                                
                                if headerData.topScrollOffset == 0 {
                                    // storing initially to subtract the maxOffset
                                    headerData.topScrollOffset = offset
                                }
                                
                                let progress = (headerData.topScrollOffset + getMaxOffset()) - offset
                                
                                // all conditions were going to use ternary operator
                                // because if we use if else while swiping fast it ignores some condictions
                                
                                let offsetCondition = (headerData.topScrollOffset + getMaxOffset()) >= getMaxOffset() && getMaxOffset() - progress <= getMaxOffset()
                                
                                let headerOffset = offsetCondition ? -(getMaxOffset() - progress) : -getMaxOffset()
                                
                                headerData.headerOffset = headerOffset
                            }
                            
                            if offset < headerData.offset {
                                // if bottom revealing header view
                                // clearing topscrollvalue and setting bottom
                                
                                headerData.topScrollOffset = 0
                                
                                if headerData.bottomScrollOffset == 0 {
                                    headerData.bottomScrollOffset = offset
                                }
                                
                                // moving if little bit of screen is swiped down
                                // for eg 40 offset
                                
                                withAnimation(.easeOut(duration: 0.25)) {
                                    let headerOffset = headerData.headerOffset
                                    
                                    headerData.headerOffset = headerData.bottomScrollOffset >= offset + 40 ? 0 : (headerOffset != -getMaxOffset() ? 0 : headerOffset)
                                }
                            }
                            
                            headerData.offset = offset
                        }
                        
                        return Color.clear
                    }
                    .frame(height: 0)
                    
                    ,alignment: .top
                )
            })
            .ignoresSafeArea(.all, edges: .top)
        }
    }
    
    // getting maxtop offset including
    func getMaxOffset() -> CGFloat {
        return headerData.startMinY + (edges?.top ?? 0) + 120
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// edges
var edges = UIApplication.shared.windows.first?.safeAreaInsets

// rect
var rect = UIScreen.main.bounds
