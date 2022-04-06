# SnapBadge

With SnapBadge you can create your personal badge in Portable Document Format (PDF). 

<img width="300" alt="5" src="https://user-images.githubusercontent.com/73304608/161941376-f417cfcb-b21b-4286-93c8-ef1e9589369b.PNG">     <img width="300" alt="4" src="https://user-images.githubusercontent.com/73304608/161941661-98f60f02-9156-4d16-b380-ad1a045c4c91.PNG">




Also you can save it to files or share with your friends.

<img width="300" alt="3" src="https://user-images.githubusercontent.com/73304608/161940030-1c1f34d1-f4e7-4d43-8180-9ac3cffb4e82.PNG"> <img width="300" alt="2" src="https://user-images.githubusercontent.com/73304608/161943247-eebc3a8d-9a38-498c-9c6a-4baa3e627486.PNG">


## Frontend

The Frontend was written in SwiftUI. 

<img width="700" alt="0" src="https://user-images.githubusercontent.com/73304608/161945023-ae1d1b0c-c629-421f-8feb-0cf01a579a21.png">



Hence SwiftUI doesn't have PDFView yet we used UIViewRepresentable. 

```swift
struct PDFPresenter: UIViewRepresentable {
    let data: Data
    
    func makeUIView(context: Context) -> PDFView {
        let pdfview = PDFView()
        let document = PDFDocument(data: data)
        pdfview.document = document
        pdfview.autoScales = true
        
        return pdfview
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        //
    }
    
    typealias UIViewType = PDFView
}
```


To export user photo in the app we created an ImagePicker, where we creating ViewContoller object with UIViewControllerRepresentable. 

```swift
class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	@Binding var image: UIImage?
	@Binding var isShown: Bool
	
	init(image: Binding<UIImage?>, isShown: Binding<Bool>) {
		_image = image
		_isShown = isShown
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			image = uiImage
			isShown = false
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		isShown = false
	}
	
}


struct ImagePicker: UIViewControllerRepresentable {
	
	typealias UIViewControllerType = UIImagePickerController
	typealias Coordinator = ImagePickerCoordinator
	
	@Binding var image: UIImage?
	@Binding var isShown: Bool
	var sourceType: UIImagePickerController.SourceType = .camera
	
	func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
	}
	
	func makeCoordinator() -> ImagePicker.Coordinator {
		return ImagePickerCoordinator(image: $image, isShown: $isShown)
	}
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
		
		let picker = UIImagePickerController()
		picker.sourceType = sourceType
		picker.delegate = context.coordinator
		return picker
		
	}
	
}
```

## PDFKit

 



Do you wanna try it? 👇
#### https://testflight.apple.com/join/BQfjEhMT









                                                       
                                                         
                                                         
                                                         
