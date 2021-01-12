//
//  FilterButton.swift
//  SwiftUICombineMVVMSample
//
//  Created by NohEunTae on 2021/01/12.
//

import SwiftUI

struct FilterButton: View {
    let filter: Filter
    let onTapGesture: () -> Void
    var body: some View {
        Text("\(filter.rawValue)")
            .padding(.all, 10)
            .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(lineWidth: 2))
            .multilineTextAlignment(.leading)
            .padding([.leading, .trailing], 10)
            .padding(.top, 35)
            .padding(.bottom, 10)
            .onTapGesture {
                onTapGesture()
            }
    }
    
}

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterButton(filter: .newest, onTapGesture: {})
            .previewLayout(.sizeThatFits)
    }
}
