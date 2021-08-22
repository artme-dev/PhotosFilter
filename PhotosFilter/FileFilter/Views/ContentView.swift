//
//  ContentView.swift
//  PhotosFilter
//
//  Created by Артём on 21.08.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var filesNames: String = ""
    @State private var folderURL: URL?
    @State private var prefixes: [String] = []
    @State private var extensions: [String] = []
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 16, content: {
            
            ItemsArrayView(title: "Префиксы", items: $prefixes)
            ItemsArrayView(title: "Расширения", items: $extensions)
            FilePickerView(buttonTitle: "Папка", sourceFileURL: $folderURL)
            TextEditor(text: $filesNames)
            
            Button("Отфильтровать"){
                filter()
            }
        }).padding(16)
        .frame(minWidth: 400, idealWidth: 600, minHeight: 300, idealHeight: 400)
    }
    
    private static func alertWindow(text: String, description: String? = nil) {
        let popup: NSAlert = NSAlert()
        popup.messageText = text
        if let description = description{
            popup.informativeText = description
        }
        popup.alertStyle = .warning
        popup.addButton(withTitle: "OK")
        popup.runModal()
    }
    
    private func filter(){
        guard let sourceURL = folderURL else {
            ContentView.alertWindow(text: "Папка не выбрана")
            return
        }
        FileService.filter(from: sourceURL,
                           filesNames: filesNames,
                           prefixes: prefixes,
                           extensions: extensions){
            
            notFoundFiles in
            if notFoundFiles.count != 0{
                ContentView.alertWindow(text: "Невозможно найти (\(notFoundFiles.count))",
                                        description: notFoundFiles.joined(separator: "\n"))
            } else {
                ContentView.alertWindow(text: "Все файлы найдены")
            }
        }
    }
    
}
