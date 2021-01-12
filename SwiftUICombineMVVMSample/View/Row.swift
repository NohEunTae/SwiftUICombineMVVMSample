//
//  Row.swift
//  SwiftUICombineMVVMSample
//
//  Created by NohEunTae on 2021/01/12.
//

import SwiftUI

struct Row: View {    
    let data: Data
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("name: \(data.name)")
            Spacer()
            Text("age: \(data.age) value: \(data.value)")
        }
        .frame(idealWidth: .infinity, maxHeight: 50)
    }
}

struct Row_Previews: PreviewProvider {
    static var previews: some View {
        Row(data: .init(value: 2, name: "이름", age: 31))
            .previewLayout(.sizeThatFits)
    }
}
