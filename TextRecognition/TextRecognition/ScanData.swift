//
//  ScanData.swift
//  TextRecognition
//
//  Created by Aniello Ambrosio on 09/12/21.
//

import Foundation
import SwiftUI

class ScanData: Identifiable,Codable {
    var id = UUID()
    var content : String
    init (content:String){
        self.content=content
    }
}

class ScanDatas: ObservableObject{
    @Published var text : [ScanData]
    private static let key = "SavedData"
    
    init(){
        if let data = UserDefaults.standard.data(forKey: Self.key){
            if let decoded = try? JSONDecoder().decode([ScanData].self,from: data){
                self.text = decoded
                return
            }
        }
        self.text = []
    }
    
    func save(){
        if let encoded = try? JSONEncoder().encode(text){
            UserDefaults.standard.set(encoded, forKey: Self.key)
        }
    }
    
    
    
}


