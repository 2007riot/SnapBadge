//
//  CardView.swift
//  CardCreator
//
//  Created by Antonio Scognamiglio on 31/03/22.
//

import SwiftUI

struct CardView: View {
	
	@State var name = ""
	@State var occupation = ""
	@State private var showSheet: Bool = false
	@State private var showImagePicker: Bool = false
	@State private var sourceType: UIImagePickerController.SourceType = .camera
	@State private var image: UIImage?
    @State private var email = ""
    @State private var phonenumber = ""
	
	
    @State var pdfData: Data?
    
	var body: some View {
		
		NavigationView {
			ScrollView {
				if let image = image ?? UIImage(named: "PlaceHolder2") {
					Image(uiImage: image)
						.resizable()
						.scaledToFill()
						.frame(width: 250, height: 250)
						.clipShape(Circle())
						.shadow(radius: 10)
						.overlay(Circle().stroke(Color(uiColor: .systemGray), lineWidth: 0.3))
						.onTapGesture {
							self.showSheet = true
						}
				}
				Group{
					Button("Choose Picture") {
						self.showSheet = true
					}.padding(5)
						.actionSheet(isPresented: $showSheet) {
							ActionSheet(title: Text("Select Photo"), message: Text("Choose"), buttons: [
								.default(Text("Photo Library")) {
									self.showImagePicker = true
									self.sourceType = .photoLibrary
								},
								.default(Text("Camera")) {
									self.showImagePicker = true
									self.sourceType = .camera
									
								},
								.cancel()
							])
						}
						.foregroundColor(Color(uiColor: .systemBlue))
					HStack {
						Text("Name and Surname")
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
					TextField("Type occupation ...", text: $occupation)
						.textFieldStyle(.roundedBorder)
					
					HStack {
						Text("Email")
							.fontWeight(.medium)
						Spacer()
					}
					TextField("Type email ...", text: $email)
						.textFieldStyle(.roundedBorder)
					
					HStack {
						Text("Phonenumber")
							.fontWeight(.medium)
						Spacer()
					}
					TextField("Type number ...", text: $phonenumber)
						.textFieldStyle(.roundedBorder)
				}.padding(.horizontal)
				
				
				
                    NavigationLink {
                        let pdfCreator = PDFCreator(name: name,
                                                    userPhoto: image ?? UIImage(named: "PlaceHolder2")!,
                                                    ocupation: occupation,
                                                    email: email,
                                                    phoneNumber: phonenumber)
                        
                        PDFPreview(PDF: pdfCreator)
                    } label: {
                        Text("See PDF")
                            .fontWeight(.medium)
                            .font(.system(size: 18))
                    }
                
	
				.frame(width: 140, height: 40)
				.foregroundColor(Color.white)
				.background(Color(uiColor: .systemBlue))
				.clipShape(RoundedRectangle(cornerRadius: 12.0))
				
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
