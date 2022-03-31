//
//  CardView.swift
//  CardCreator
//
//  Created by Antonio Scognamiglio on 31/03/22.
//

import SwiftUI

struct CardView: View {
	
	@State var showPDF = false
	@State var name = ""
	@State var occupation = ""
	@State private var showSheet: Bool = false
	@State private var showImagePicker: Bool = false
	@State private var sourceType: UIImagePickerController.SourceType = .camera
	@State private var image: UIImage?
    @State private var email = ""
    @State private var phonenumber = ""
	
	
	@State var showingExporter = false
	
    @State var pdfData: Data?
    
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
				
				Button("Choose Picture") {
					self.showSheet = true
				}.padding()
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
				
				Button {
//                    let pdfCreator = PDFCreator(name: name,
//                                                userPhoto: image ?? UIImage(named: "UserPicture")!,
//                                                ocupation: occupation,
//                                                email: email,
//                                                phoneNumber: phonenumber)
//                    pdfData = pdfCreator.createFlyer()
                    showPDF = true
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
                    let pdfCreator = PDFCreator(name: name,
                                                userPhoto: image ?? UIImage(named: "UserPicture")!,
                                                ocupation: occupation,
                                                email: email,
                                                phoneNumber: phonenumber)
                    
                    if let data = pdfCreator.createFlyer() {
						NavigationView {
							PDFPresenter(data: data)
								.ignoresSafeArea(.container, edges: .bottom)
							
								.toolbar {
									ToolbarItem(placement: .bottomBar) {
										Spacer()
									}
									ToolbarItem(placement: .bottomBar) {
										Button {
											self.showPDF = false
											
											showingExporter.toggle()
										} label: {
											Image(systemName: "square.and.arrow.up")
										}
									}
									ToolbarItem(placement: .navigationBarLeading) {
										Button {
											self.showPDF = false
											
										} label: {
											Image(systemName: "arrow.backward")
										}
									}
						}
						
					}
                        .onAppear { print(data) }
                    }
				}
				.sheet(isPresented: $showingExporter) {
					let pdfCreator = PDFCreator(name: name, userPhoto: image ?? UIImage(named: "UserPicture")!, ocupation: occupation, email: email, phoneNumber: phonenumber)
					if let data = pdfCreator.createFlyer() {
						ShareSheet(activityItems: [data])
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
