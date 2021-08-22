//
//  ItemsArrayView.swift
//  PhotosFilter
//
//  Created by Артём on 22.08.2021.
//

import SwiftUI

struct ItemsArrayView: View {
    
    let title: String
    @Binding var items: [String]
    
    @State private var currentItem: String = ""
    private static let itemButtonColor = Color.accentColor.opacity(0.5)
    
    var body: some View {
        HStack(){
            TextField(title, text: $currentItem)
            Button("Добавить"){
                if(currentItem != ""){
                    items.append(currentItem)
                    currentItem = ""
                }
            }
            Button("Очистить"){
                items.removeAll()
            }
        }
        HStack {
            Text(title + ":")
            
            
            ForEach(0..<items.count, id: \.self) {
                index in
                Button(items[index]) {
                    items.remove(at: index)
                }
                .background(ItemsArrayView.itemButtonColor)
                .clipShape(Capsule())
            }
            if(items.count == 0){
                Text("Не указаны")
            }
        }
    }
}
