//
//  HeaderViewModel.swift
//  AnimatedsHeader (iOS)
//
//  Created by Raphael Cerqueira on 12/02/21.
//

import SwiftUI

class HeaderViewModel: ObservableObject {
    // to capture start minY value for calculations
    @Published var startMinY: CGFloat = 0
    
    @Published var offset: CGFloat = 0
    
    // header view properties
    
    @Published var headerOffset: CGFloat = 0
    
    // it will be used for getting top and bottom offsets for header view
    @Published var topScrollOffset: CGFloat = 0
    @Published var bottomScrollOffset: CGFloat = 0
}
