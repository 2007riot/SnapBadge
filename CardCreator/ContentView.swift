//
//  ContentView.swift
//  CardCreator
//
//  Created by Galina Aleksandrova on 30/03/22.
//

import SwiftUI

struct ContentView: View {
    @State var showPDF = false
    @StateObject var pdfData = PDFData()
  
    var body: some View {
        VStack {
            Text ("Enter your name")
            TextField("Enter your name", text: $pdfData.name)
                .textFieldStyle(.roundedBorder)
            Button {
                showPDF.toggle()
            } label: {
                Text("Show PDF")
            }
        }
        .sheet(isPresented: $showPDF) {
            let pdfCreator = PDFCreator(title: pdfData.name, userPhoto: UIImage(named: "UserPicture")!)
            if let data = pdfCreator.createFlyer() {
                PDFPresenter(data: data)
            }
           
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
