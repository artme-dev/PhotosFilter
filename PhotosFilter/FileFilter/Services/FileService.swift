//
//  FileService.swift
//  PhotosFilter
//
//  Created by Артём on 21.08.2021.
//

import Foundation

class FileService{
    static func filter(from sourceURL: URL,
                       filesNames inputFileNames: String,
                       prefixes: [String],
                       extensions: [String],
                       unfoundFilesHandler: @escaping ([String])->()){
        
        let parsedFilesNames = parse(filesNames: inputFileNames)
        var isFound: [Bool] = Array.init(repeating: false, count: parsedFilesNames.count)
        var foundFilesURLs: [URL] = []
        
    
        searchCombinations(at: sourceURL,
                           filesNames: parsedFilesNames,
                           prefixes: prefixes,
                           extensions: extensions) {
            fileIndex, fileURL in
            foundFilesURLs.append(fileURL)
            isFound[fileIndex] = true
        }
        
        do{
            for fileURL in foundFilesURLs{
                try (fileURL as NSURL).setResourceValue(LabelColor.blue.rawValue, forKey: .labelNumberKey)
            }
        } catch {
            print("Add file label error: \(error)")
        }
        
        var unfoundFilesNames: [String] = []
        for (fileIndex, isFound) in isFound.enumerated(){
            if !isFound{
                unfoundFilesNames.append(parsedFilesNames[fileIndex])
            }
        }
        unfoundFilesHandler(unfoundFilesNames)
    }
    
    private static func parse(filesNames: String) -> [String]{
        let preparedString = filesNames
            .replacingOccurrences(of: ",", with: " ")
            .replacingOccurrences(of: "\n", with: " ")
        let components = preparedString.components(separatedBy: " ").filter { !$0.isEmpty }
        return components
    }
    
    private static func search(at sourceURL: URL,
                               filesNames: [String],
                               foundItemHandler: (Int, URL)->()){
        
        let manager = FileManager.default
        
        for (index, fileName) in filesNames.enumerated(){
            var fileUrl = sourceURL
            fileUrl.appendPathComponent(fileName)
            
            let isExist = manager.fileExists(atPath: fileUrl.path)
            if isExist {
                foundItemHandler(index, fileUrl)
            }
        }
    }
    
    private static func searchCombinations(at sourceURL: URL,
                                           filesNames : [String],
                                           prefixes: [String],
                                           extensions: [String],
                                           foundItemHandler: (Int, URL)->()){
        
        let extensionsWithEmptyStr = extensions + [""]
        let prefixesWithEmptyStr = prefixes + [""]
        
        for ext in extensionsWithEmptyStr{
            for pref in prefixesWithEmptyStr{
                let combinedNames = filesNames.map { pref + $0 + ext }
                
                search(at: sourceURL, filesNames: combinedNames) {
                    fileIndex, fileURL in
                    foundItemHandler(fileIndex, fileURL)
                }
            }
        }
    }
}
