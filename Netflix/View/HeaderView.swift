//
//  HeaderView.swift
//  Netflix
//
//  Created by Raphael Cerqueira on 15/02/21.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Image("netflix")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                
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
            
            HStack(spacing: 40) {
                Button(action: {}, label: {
                    Text("TV Shows")
                })
                
                Button(action: {}, label: {
                    Text("Movies")
                })
                
                Button(action: {}, label: {
                    Text("Categories")
                    
                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 16, height: 8)
                })
            }
            .foregroundColor(.white)
            .padding()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.9), Color.black.opacity(0.8), Color.clear]), startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all, edges: .top))
        .frame(width: UIScreen.main.bounds.width, height: 120)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
