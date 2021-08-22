//
//  FilePickerView.swift
//  PhotosFilter
//
//  Created by Артём on 22.08.2021.
//

import SwiftUI

struct FilePickerView: View {
    
    let buttonTitle: String
    @Binding var sourceFileURL: URL?
    
    var body: some View {
        HStack{
            Button(buttonTitle){
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = true
                panel.canCreateDirectories = true
                if panel.runModal() == .OK {
                    self.sourceFileURL = panel.url
                }
            }
            Text(sourceFileURL?.path ?? "Не выбрано")
        }
    }
}
