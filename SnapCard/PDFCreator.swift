//
//  PDFCreator.swift
//  CardCreator
//
//  Created by Galina Aleksandrova on 30/03/22.
//

import Foundation
import PDFKit
import UIKit

class PDFCreator {
    
    let name: String
    let image = UIImage(named: "backgroundImage")
    var userPhoto: UIImage
    let ocupation: String
    let email: String
    let phoneNumber: String
    
    
    init(name: String, userPhoto: UIImage, ocupation: String, email: String, phoneNumber: String) {
        self.name = name
        self.userPhoto = userPhoto
        self.ocupation = ocupation
        self.email = email
        self.phoneNumber = phoneNumber
    }
    
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
    
    
    func addImage(pageRect: CGRect, imageTop: CGFloat)  {
        
        let maxHeight = pageRect.height
        
        let maxWidth = pageRect.width
        if let imageUnwrapped = image {
            let aspectWidth = maxWidth / imageUnwrapped.size.width
            let aspectHeight = maxHeight / imageUnwrapped.size.height
            let aspectRatio = min(aspectWidth, aspectHeight)
            
            let scaledWidth = imageUnwrapped.size.width * aspectRatio
            let scaledHeight = imageUnwrapped.size.height * aspectRatio
            
            let imageX = (pageRect.width - scaledWidth) / 2.0
            let imageRect = CGRect(x: imageX, y: imageTop,
                                   width: scaledWidth, height: scaledHeight)
            
            imageUnwrapped.draw(in: imageRect)
            
        } else {
            print("No image found")
        }
        
        
    }
    func createCircle() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 60, height: 60))
        let rectangle = CGRect(x: 0, y: 0, width: 60, height: 60)
        let img = renderer.image { (context) in
            UIColor.green.setStroke()
            context.cgContext.addEllipse(in: rectangle)
            context.cgContext.drawPath(using: .stroke)
            
        }
        
        return img
    }
    
    func addImageWithoutScaling (image: UIImage, pageRect: CGRect, xPosition: CGFloat, yPosition: CGFloat) {
        let rectangle = CGRect(x: xPosition, y: yPosition,
                               width: image.size.width, height: image.size.height)
        
        image.draw(in: rectangle)
    }
    
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
}

