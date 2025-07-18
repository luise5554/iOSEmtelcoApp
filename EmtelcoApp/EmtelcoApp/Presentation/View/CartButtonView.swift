//
//  CartButtonView.swift
//  EmtelcoApp
//
//  Created by Luis on 18/07/25.
//

import SwiftUI

struct CartButtonView: View {
    var count: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "cart")
                .font(.title2)
            
            if count > 0 {
                Text("\(count)")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color.red)
                    .clipShape(Circle())
                    .offset(x: 8, y: -8)
            }
        }
    }
}
