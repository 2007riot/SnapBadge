//
//  PDFPreview.swift
//  CardCreator
//
//  Created by Diego Castro on 31/03/22.
//

import SwiftUI

struct PDFPreview: View {
    @State var PDF: PDFCreator?
    @State var showPDF = false
    @State var showingExporter = false
    
    var body: some View {
        if let data = PDF?.createBage(){
        NavigationView {
            PDFPresenter(data: data)

                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button {
                            self.showPDF = false
                            showingExporter.toggle()
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        Spacer()
                    }
                }.navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
    }
        .sheet(isPresented: $showingExporter) {
 
            if let data = PDF?.createBage() {
                ShareSheet(activityItems: [data])
            }
        }
        }
    }
}

struct PDFPreview_Previews: PreviewProvider {
    static var previews: some View {
        PDFPreview()
    }
}

