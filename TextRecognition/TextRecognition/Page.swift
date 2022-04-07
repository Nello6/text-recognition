//
//  Page.swift
//  TextRecognition
//
//  Created by Aniello Ambrosio on 15/12/21.
//

import SwiftUI

struct Page: View {
    @Binding public var text : String
    var body: some View {
        
        TextEditor(text: $text)
    }
}

//struct Page_Previews: PreviewProvider {
//    static var previews: some View {
//        Page(text: $text)
//    }
//}
