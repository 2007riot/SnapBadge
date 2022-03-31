//
//  CardView.swift
//  CardCreator
//
//  Created by Antonio Scognamiglio on 31/03/22.
//

import SwiftUI

struct CardView: View {
	
	//@StateObject var card = PDFData()
	@State var showPDF = false
	@State var name = ""
    @State var occupation = ""
	@State private var showSheet: Bool = false
	@State private var showImagePicker: Bool = false
	@State private var sourceType: UIImagePickerController.SourceType = .camera
	@State private var image: UIImage?
	
	
	var body: some View {
		
		NavigationView {
			ScrollView {
				if let image = image ?? UIImage(named: "UserPicture") {
					Image(uiImage: image)
						.resizable()
						.scaledToFill()
						.frame(width: 250, height: 250)
						.clipShape(Circle())
						.shadow(radius: 10)
						.overlay(Circle().stroke(Color(uiColor: .systemGray), lineWidth: 0.3))
				}
				Group{
				HStack {
					Text("Name")
						.fontWeight(.medium)
					Spacer()
				}
				TextField("Type name ...", text: $name)
					.textFieldStyle(.roundedBorder)
				
				HStack {
					Text("Occupation")
						.fontWeight(.medium)
					Spacer()
				}
				TextField("Type surname ...", text: $occupation)
					.textFieldStyle(.roundedBorder)
				}.padding(.horizontal)
				
				Button("Choose Picture") {
					self.showSheet = true
				}.padding()
					.actionSheet(isPresented: $showSheet) {
						ActionSheet(title: Text("Select Photo"), message: Text("Choose"), buttons: [
							.default(Text("Photo Library")) {
								self.showImagePicker = true
								self.sourceType = .photoLibrary
								//adesso credo che qua devo performare l'azione del machine learning e passargli l'immagine che sta qua
							},
							.default(Text("Camera")) {
								self.showImagePicker = true
								self.sourceType = .camera
								//adesso credo che qua devo performare l'azione del machine learning e passargli l'immagine che sta qua
							},
							.cancel()
						])
				}
					.foregroundColor(Color(uiColor: .systemBlue))
				
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
				.sheet(isPresented: $showPDF) {
                    let pdfCreator = PDFCreator(name: name, userPhoto: image ?? UIImage(named: "UserPicture")!, ocupation: occupation)
					if let data = pdfCreator.createFlyer() {
						PDFPresenter(data: data)
							.ignoresSafeArea(.container, edges: .bottom)
					}
				}
				
			}
						.navigationTitle("Business Card")
		}
		.fullScreenCover(isPresented: $showImagePicker) {
			ImagePicker(image: $image, isShown: $showImagePicker, sourceType: sourceType)
				.ignoresSafeArea(.container, edges: .vertical)
		}
	}
}

struct CardView_Previews: PreviewProvider {
	static var previews: some View {
		CardView()
	}
}
