//
//  PDFPresenter.swift
//  CardCreator
//
//  Created by Galina Aleksandrova on 30/03/22.
//

import SwiftUI
import PDFKit

struct PDFPresenter: UIViewRepresentable {
    let data: Data
    
    
    func makeUIView(context: Context) -> PDFView {
        let pdfview = PDFView()
        let document = PDFDocument(data: data)
        pdfview.document = document
        pdfview.autoScales = false
        
        

        return pdfview
            }
    
    
    
    func updateUIView(_ uiView: PDFView, context: Context) {
       
        //
    }
    
    typealias UIViewType = PDFView
    
    
    
}

