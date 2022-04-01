//
//  CardView.swift
//  CardCreator
//
//  Created by Antonio Scognamiglio on 31/03/22.
//

import SwiftUI

struct CardView: View {
    @State private var selection: Int? = nil
	@State private var name = ""
	@State private var occupation = ""
	@State private var showSheet: Bool = false
	@State private var showImagePicker: Bool = false
	@State private var sourceType: UIImagePickerController.SourceType = .camera
	@State private var image: UIImage?
    @State private var email = ""
    @State private var phonenumber = ""
    @State private var showAlert = false
	
    var pdfCreator: PDFCreator {
        PDFCreator(name: name,
                userPhoto: image ?? UIImage(named: "PlaceHolder2")!,
                ocupation: occupation,
                email: email,
                phoneNumber: phonenumber)
    }
	
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
				Group {
					Button("Choose Picture") {
						self.showSheet = true
					} .padding(5)
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
						.foregroundColor((Color(uiColor: .blueColor)))
                   
					HStack {
						Text("Name and Surname")
							.fontWeight(.medium)
						Spacer()
					}
                    
					TextField("Enter name and surname", text: $name)
						.textFieldStyle(.roundedBorder)
					
					HStack {
						Text("Job Title")
							.fontWeight(.medium)
						Spacer()
					}
					TextField("Enter job title", text: $occupation)
						.textFieldStyle(.roundedBorder)
					
					HStack {
						Text("Email")
							.fontWeight(.medium)
						Spacer()
					}
					TextField("Enter email", text: $email)
						.textFieldStyle(.roundedBorder)
					
					HStack {
						Text("Contact number")
							.fontWeight(.medium)
						Spacer()
					}
					TextField("Enter contact number", text: $phonenumber)
						.textFieldStyle(.roundedBorder)
				}.padding(.horizontal)
				
				
				
//                    NavigationLink {
//                        let pdfCreator = PDFCreator(name: name,
//                                                    userPhoto: image ?? UIImage(named: "PlaceHolder2")!,
//                                                    ocupation: occupation,
//                                                    email: email,
//                                                    phoneNumber: phonenumber)
//
//                        PDFPreview(PDF: pdfCreator)
//                    } label: {
//                        Button {
//                           showAlert = checkInfo()
//                        } label: {
//                            Text("Preview")
//                                .fontWeight(.medium)
//                                .font(.system(size: 18))
//                                .frame(width: 140, height: 40)
//                                .foregroundColor(Color.white)
//                                .background(Color(uiColor: .systemBlue))
//                                .clipShape(RoundedRectangle(cornerRadius: 12.0))
//                        }
                       
                            
//                    }
                
                NavigationLink(destination: PDFPreview(PDF: pdfCreator), tag: 1, selection: $selection) {
//                    Button(action: {
//                        self.selection = 1
//                        //                        self.showAlert = checkInfo()
//
//                    }) {
                        Text("Preview")
                            .fontWeight(.medium)
                            .font(.system(size: 18))
                            .frame(width: 140, height: 40)
                            .foregroundColor(.white)
                        
                            .background((Color(uiColor: .blueColor)))
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
//                    }
                }
                .disabled(checkInfo())
                .onTapGesture {
                    showAlert = checkInfo()
                }
                    
                
			}
			.navigationTitle("Business Card")
		}
        .alert("Pleaase provide all required information", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
		.fullScreenCover(isPresented: $showImagePicker) {
			ImagePicker(image: $image, isShown: $showImagePicker, sourceType: sourceType)
				.ignoresSafeArea(.container, edges: .vertical)
        
		}
	}
    
    func checkInfo() -> Bool {
        image == nil || name.isEmpty || email.isEmpty || phonenumber.isEmpty || occupation.isEmpty
    }
}

struct CardView_Previews: PreviewProvider {
	static var previews: some View {
		CardView()
	}
}
