//
//  LabelList.swift
//  TextRecognition
//
//  Created by Aniello Ambrosio on 16/12/21.
//

import SwiftUI

struct LabelList: View {
    @Binding var text : ScanData
    var body: some View {
        Text(text.content).lineLimit(1)
    }
}

