//
//  Empty_msg.swift
//  TextRecognition
//
//  Created by Aniello Ambrosio on 10/12/21.
//

import SwiftUI

struct Empty_msg: View {
    var body: some View {
        VStack{
            Image("NotScanYet").resizable().scaledToFit().frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/10)
            Text("There are nothing to see there\nPease start to scan").font(.title).multilineTextAlignment(.center)
                .foregroundColor(Color(hue: 0.666, saturation: 1.0, brightness: 0.445))
            
        }
    }
}

struct Empty_msg_Previews: PreviewProvider {
    static var previews: some View {
        Empty_msg()
    }
}
