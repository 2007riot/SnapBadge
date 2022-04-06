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

To display PDF in SwiftUI need to create a PDFCreator class. And after in the SwiftUI view, we create an instance of the class, where we pass data from the user.

 ``` swift
 var pdfCreator: PDFCreator {
        PDFCreator(name: name,
                   userPhoto: image ?? UIImage(named: "PlaceHolder2")!,
                   ocupation: occupation,
                   email: email,
                   phoneNumber: phonenumber)
    }
 ```


In the PDFCreator class, we declare all functionality that our PDF needs. The main function of PDFCreator is createBage() that returns Data type. 

```swift
func createBage() -> Data {
        // dictionary with the PDF’s metadata using predefined keys.
        let pdfMetaData = [
            kCGPDFContextCreator: name,
            kCGPDFContextAuthor: "Fatal Error() team"
        ]
        //setting metadata
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // setting the pdf doc size, remembering it use 72 points per inch
        let pageWidth = 3.5 * 72.0
        let pageHeight = 2 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        // creating a pdfRenderer with the dimensions of the rectangle and the format containing the metadata.
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        // The renderer creates a Core Graphics context that becomes the current context within the block. Drawing done on this context will appear on the PDF.
        
        let data = renderer.pdfData { (context) in
            
            context.beginPage()
            
            let name = addUserName(text: name, pageRect: pageRect, fontWeight: .bold, fontSize: 14, xPosition: 95, yPosition: 48)
            addText(text: ocupation, pageRect: pageRect, fontWeight: .regular, fontSize: 10, xPosition: 95, yPosition: 65)
            addText(text: email, pageRect: pageRect, fontWeight: .regular, fontSize: 6, xPosition: 95, yPosition: 78)
            addText(text: phoneNumber, pageRect: pageRect, fontWeight: .regular, fontSize: 6, xPosition: 95, yPosition: 86)
            addUserPhoto(pageRect: pageRect, imageTop: name + 50, xPosition: 20, yPosition: 50)
            
        }
        
        return data
    }
```
To place text and photo in PDF document we created functions

### addUserName 

Adds name and surname to PDF. It serves as a title and returns CGFloat - where exactly in PDF we placed this information. As input need to provide text, font and rectangle where this text will be placed.

```swift
func addUserName(text: String, pageRect: CGRect, fontWeight: UIFont.Weight, fontSize: CGFloat, xPosition: CGFloat, yPosition: CGFloat) -> CGFloat {
        
        let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        let color: UIColor = UIColor.blueColor
        
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        
        let attributedString = NSAttributedString(
            string: text,
            attributes: attributes
        )
        
        let stringSize = attributedString.size()
        
        let stringRect = CGRect(
            x: xPosition,
            y: yPosition,
            width: stringSize.width,
            height: stringSize.height
        )
        
        attributedString.draw(in: stringRect)
        
        return stringRect.origin.y + stringRect.size.height
    }
```

### addText

Almost the same functionality as addUserName, but it doesn't return where this texted was placed. Can use to add any text in the PDF.

```swift
func addText(text: String, pageRect: CGRect, fontWeight: UIFont.Weight, fontSize: CGFloat, xPosition: CGFloat, yPosition: CGFloat) {
        
        let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        let color: UIColor = UIColor.blueColor
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        
        let attributedString = NSAttributedString(
            string: text,
            attributes: attributes
        )
        
        let stringSize = attributedString.size()
        
        let stringRect = CGRect(
            x: xPosition,
            y: yPosition,
            width: stringSize.width,
            height: stringSize.height
        )
        
        attributedString.draw(in: stringRect)
        
    }
```

### addUserPhoto

Serves to place photo from user in the PDF. First, it resize the photo height and width to be no more 40% and 23% of the PDF. Second, it calculates aspect ratio to resize image correctly and finally place the photo in the PDF.

```swift
 func addUserPhoto (pageRect: CGRect, imageTop: CGFloat, xPosition: CGFloat, yPosition: CGFloat) {
        
        let maxHeight = pageRect.height * 0.4
        let maxWidth = pageRect.width * 0.23
        
        let aspectWidth = maxWidth / userPhoto.size.width
        let aspectHeight = maxHeight / userPhoto.size.height
        
        let aspectRatio = min(aspectWidth, aspectHeight)
        
        let scaledWidth = userPhoto.size.width * aspectRatio
        let scaledHeight = userPhoto.size.height * aspectRatio
        
        
        
        let photoRect = CGRect(x: xPosition, y: yPosition,
                               width: scaledWidth, height: scaledHeight)
        
        userPhoto.draw(in: photoRect)
    }
```



Do you wanna try it? 👇
#### https://testflight.apple.com/join/BQfjEhMT









                                                       
                                                         
                                                         
                                                         
