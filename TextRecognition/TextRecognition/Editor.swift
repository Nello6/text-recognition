//
//  Editor.swift
//  TextRecognition
//
//  Created by Aniello Ambrosio on 16/12/21.
//

import SwiftUI

struct Editor: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var text : ScanData
    
    var body: some View {
        TextEditor(text: $text.content).foregroundColor(.black).toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action:{
                    self.presentationMode.wrappedValue.dismiss()
    
                },
                       label:{
                    Text("Save")
                })
                
            }
        }
    }
}
