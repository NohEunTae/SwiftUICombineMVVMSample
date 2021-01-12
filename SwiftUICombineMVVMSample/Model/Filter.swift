//
//  Filter.swift
//  SwiftUICombineMVVMSample
//
//  Created by NohEunTae on 2021/01/12.
//

import Foundation

enum Filter: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case newest, oldest, popular
}
