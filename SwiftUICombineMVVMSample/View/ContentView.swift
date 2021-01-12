//
//  ContentView.swift
//  SwiftUICombineMVVMSample
//
//  Created by NohEunTae on 2021/01/12.
//

import SwiftUI

struct ContentView: View {    
    @ObservedObject private var viewModel: ViewModel = ViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            filterView
            contentView
            footerView
        }
        .onAppear(perform: { viewModel.bind() })
    }
}

private extension ContentView {
    
    var filterView: some View {
        HStack {
            ForEach(Filter.allCases) { filter in
                FilterButton(filter: filter) {
                    viewModel.filter.send(filter)
                }
            }
        }
    }
    
    var contentView: some View {
        List(viewModel.items) { item in
            Row(data: item)
                .onAppear(perform: {
                    if viewModel.items.last == item {
                        viewModel.updatePageIfNeeded(item: item)
                    }
                })
        }
    }
    
    var footerView: some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            purchaseButton
            likeButton
            Spacer()
        }
    }
    
    var purchaseButton: some View {
        Button("구매", action: { self.viewModel.purchaseTap.send(()) })
            .foregroundColor(.black)
            .padding([.top, .bottom], 10)
            .frame(maxWidth: .infinity)
            .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(lineWidth: 2))
            .alert(isPresented: $viewModel.showingPurchageAlert, content: {
                Alert(
                    title: Text("구매하기"),
                    message: Text("성공"),
                    dismissButton: Alert.Button.default(Text("확인"))
                )
            })
    }
    
    var likeButton: some View {
        Button(action: { self.viewModel.likeTap.send(()) }) {
            viewModel.like ? Text("❤️") : Text("💔")
        }
        .padding(.all, 10)
        .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(lineWidth: 2))
        .alert(isPresented: $viewModel.showingLikeAlert, content: {
            Alert(
                title: Text("좋아요 변경 \(String(viewModel.like))"),
                message: Text("성공"),
                dismissButton: Alert.Button.default(Text("확인"))
            )
        })
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
