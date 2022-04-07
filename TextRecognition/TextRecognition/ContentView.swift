//
//  ContentView.swift
//  TextRecognition
//
//  Created by Aniello Ambrosio on 09/12/21.
//

import SwiftUI
import Vision



struct ContentView: View {

    private static let empty_message : String = "There are nothing to see there \n Pease start to scan"
    @State private var showScannerSheet = false
    @State private var openCameraRoll = false
    @State private var titolo = "Camera Scan"
    @State var imageSelected = UIImage()
    @State private var imagemode = false
    @ObservedObject private var texts: ScanDatas = ScanDatas()
    
    
    var body: some View {
        NavigationView{
            VStack{
                if texts.text.count > 0{
                    List{
                        ForEach($texts.text){text in
                            NavigationLink(
                                destination:
                                    Editor(text: text).onDisappear(perform: texts.save)
                            ){
                            LabelList(text: text)
                            }
                        }.onDelete(perform: deleteItems)
                    }
                }
                else{
                    Empty_msg()
                }
            }
            .navigationTitle(titolo)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    ZStack{
                        Rectangle().cornerRadius(100)
                            .frame(width: 60, height: 35).padding(.leading, -6)
                        EditButton().foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(
                        action: {
                            self.showScannerSheet = true
                        },
                        label: {
                            ZStack{
                                Rectangle().cornerRadius(50).foregroundColor(Color(hue: 0.666, saturation: 1.0, brightness: 0.445))
                                    .padding([.leading, .bottom],12).frame(width: 210, height: 70)
                                HStack{
                                    Text("New Scan")
                                        .font(.title)
                                        .padding([ .leading, .bottom])
                                        .foregroundColor(.white)
                                    Image(systemName: "text.viewfinder")
                                        .padding(.bottom,12)
                                        .font(.title)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    ).padding(.bottom)
                    .padding(.leading,-20)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    ZStack{
                        Rectangle()
                            .cornerRadius(50)
                            .frame(width: 90, height: 40)
                            .padding(.trailing,5)
                        
                            .foregroundColor(Color(hue: 0.666, saturation: 1.0, brightness: 0.445))
                        HStack{
                            Button(
                                action: {
                                    self.imagemode=false
                                    self.titolo="Camera Scan"
                                },
                                label: {
                                    if imagemode{
                                        ZStack{
                                            Image(systemName:"camera.viewfinder")
                                                .font(.headline)
                                            .foregroundColor(.white)

                                        }
                                    }
                                    else {
                                        ZStack{
                                            Circle()
                                                .scale(1.4)
                                                .stroke(lineWidth: 4)
                                                .foregroundColor(Color(red: 0.949, green: 0.949, blue: 0.97))

                                            Image(systemName:"camera.viewfinder")
                                                .font(.headline)
                                                .foregroundColor(.white)

                                        }
                                    }
                                }
                            )
                                .padding(.trailing,10)
                            Button(
                                action: {
                                    self.imagemode=true
                                    self.titolo="Image Scan"
                                },
                                label:{
                                    if !imagemode{
                                        ZStack{
                                            Image(systemName:"doc.text.viewfinder")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    else {
                                        ZStack{
                                            Circle()
                                                .scale(1.4)
                                                .stroke(lineWidth: 4)
                                                .foregroundColor(Color(red: 0.949, green: 0.949, blue: 0.97))

                                            Image(systemName:"doc.text.viewfinder")
                                                .font(.headline)
                                                .foregroundColor(.white)

                                        }
                                    }
                                }
                            )
                                .padding(.trailing)
                        }
                    }
                    .padding(.trailing,-30)
                    
                }
            }
            .sheet(
                isPresented: $showScannerSheet,
                content: {
                    if(!imagemode){
                        self.makeScannerView()
                    }
                    else{
                        ImagePicker(selectedImage: $imageSelected, sourceType: .photoLibrary)
                            .onDisappear(perform: {recognizText()})
                    }
                }
            )
            
        }
        .foregroundColor(/*@START_MENU_TOKEN@*/Color(red: 0.0, green: 0.0, blue: 0.443)/*@END_MENU_TOKEN@*/)
    }
    
    private func makeScannerView()-> ScannerView {
        ScannerView(completion: {
            textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines){
                let newScanData = ScanData(content: outputText)
                self.texts.text.append(newScanData)
                self.texts.save()
            }
            self.showScannerSheet = false
        })
    }
    
    func deleteItems(at offsets: IndexSet){
        self.texts.text.remove(atOffsets: offsets)
        texts.save()
    }
    
    
   
    private func recognizText(){

        guard let cgImage = imageSelected.cgImage else{return }
        
        //Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        //Request
        let request = VNRecognizeTextRequest{ request, error in
            guard let observation = request.results as? [VNRecognizedTextObservation],
                  error==nil else{
                      return
                  }
            let textfromimage = observation.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: "\n ")
            let newScanData = ScanData(content: textfromimage)
            self.texts.text.append(newScanData)
            self.texts.save()
        }
        
        //process
        do{
            try handler.perform([request])
        }
        catch{
            print(error)
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
