//
//  CardView.swift
//  CardCreator
//
//  Created by Antonio Scognamiglio on 31/03/22.
//

import SwiftUI

struct CardView: View {
	
	@StateObject var card = PDFData()
	@State var showPDF = false
	
	
	var body: some View {
		
		NavigationView{
			VStack {
				HStack {
					Text("Name")
						.fontWeight(.medium)
					Spacer()
				}
				TextField("Type name ...", text: $card.name)
					.textFieldStyle(.roundedBorder)
				HStack {
					Text("Surname")
						.fontWeight(.medium)
					Spacer()
				}
				TextField("Type surname ...", text: $card.surname)
					.textFieldStyle(.roundedBorder)
				Button{
					showPDF.toggle()
				} label: {
					Text("Show PDF")
						.fontWeight(.medium)
						.font(.system(size: 18))
				}
				.frame(width: 140, height: 40)
				.foregroundColor(Color.white)
				.background(Color(uiColor: .systemBlue))
				.clipShape(RoundedRectangle(cornerRadius: 12.0))
				.padding()
				.sheet(isPresented: $showPDF) {
                    let pdfCreator = PDFCreator(title: card.name, userPhoto: UIImage(named: "UserPicture")!)
					if let data = pdfCreator.createFlyer() {
						PDFPresenter(data: data)
					}
				}
				
			}
			.padding()
			.navigationTitle("Business Card")
		}
	}
}

struct CardView_Previews: PreviewProvider {
	static var previews: some View {
		CardView()
	}
}
