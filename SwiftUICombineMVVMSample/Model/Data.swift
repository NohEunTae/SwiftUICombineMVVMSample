//
//  Data.swift
//  SwiftUICombineMVVMSample
//
//  Created by NohEunTae on 2021/01/12.
//

import Foundation

final class Data: Equatable, Identifiable {
    static func == (lhs: Data, rhs: Data) -> Bool {
        lhs.age == rhs.age && lhs.name == rhs.name && lhs.value == rhs.value
    }
    
    let value: Int
    let name: String
    let age: Int
    
    init(value: Int, name: String, age: Int) {
        self.value = value
        self.name = name
        self.age = age
    }
}
