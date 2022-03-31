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

    let title: String
    let image = UIImage(named: "backgroundImage")
    let userPhoto: UIImage
    let ocupation: String
//    let body: String
//    let image: UIImage
//    let contactInfo: String

    init(title: String, userPhoto: UIImage, ocupation: String) {
      self.title = title
        self.userPhoto = userPhoto
        self.ocupation = ocupation
//      self.body = body
//      self.image = image
//      self.contactInfo = contact
    }
    
    func createFlyer() -> Data {
      // dictionary with the PDF’s metadata using predefined keys.
      let pdfMetaData = [
        kCGPDFContextCreator: "Card Builder",
        kCGPDFContextAuthor: "Fatal Error() team",
        kCGPDFContextTitle: title
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
        // 5
        context.beginPage()
  //      // 6
  //      let attributes = [
  //        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 72)
  //      ]
  //      let text = "Ураааа!"
  //      text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        let titleBottom = addTitle(pageRect: pageRect)
//        let imageBottom = addImage(pageRect: pageRect, imageTop: titleBottom + 18.0)
        let photoLeft = addUserPhoto(pageRect: pageRect, imageTop: titleBottom + 30)
       

      }

      return data
    }
    
    func addTitle(pageRect: CGRect) -> CGFloat {
      
        let titleFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
      // 2
      let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: titleFont]
      // 3
      let attributedTitle = NSAttributedString(
        string: title,
        attributes: titleAttributes
      )
      
      let titleStringSize = attributedTitle.size()
        // create rectangle
      let titleStringRect = CGRect(
        //x: (pageRect.width - titleStringSize.width) / 2.0,
        x: 95,
        y: 48,
        width: titleStringSize.width,
        height: titleStringSize.height
      )
      // 6
      attributedTitle.draw(in: titleStringRect)
      // 7
      return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    func addImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
      
        let maxHeight = pageRect.height
      let maxWidth = pageRect.width
      // 2
        if let imageUnwrapped = image {
      let aspectWidth = maxWidth / imageUnwrapped.size.width
      let aspectHeight = maxHeight / imageUnwrapped.size.height
      let aspectRatio = min(aspectWidth, aspectHeight)
      // 3
      let scaledWidth = imageUnwrapped.size.width * aspectRatio
      let scaledHeight = imageUnwrapped.size.height * aspectRatio
      // 4
      let imageX = (pageRect.width - scaledWidth) / 2.0
      let imageRect = CGRect(x: imageX, y: imageTop,
                             width: scaledWidth, height: scaledHeight)
      // 5
      imageUnwrapped.draw(in: imageRect)
            return imageRect.origin.y + imageRect.size.height
        } else {
            print("No image found")
            return 0
        }
      
    }
    
    func addUserPhoto (pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
        //let maxHeight = pageRect.height * 0.4
        let maxHeight = CGFloat (60)
        //let maxWidth = pageRect.width * 0.23
        let maxWidth = CGFloat (60)
        
        let aspectWidth = maxWidth / userPhoto.size.width
        let aspectHeight = maxHeight / userPhoto.size.height
        
        
        let aspectRatio = min(aspectWidth, aspectHeight)
        
        let scaledWidth = userPhoto.size.width * aspectRatio
        let scaledHeight = userPhoto.size.height * aspectRatio
        
        //let photoX = (pageRect.width - scaledWidth) / 2.0
        
        
        let photoRect = CGRect(x: 16, y: 36,
                                 width: scaledWidth, height: scaledHeight)
        
        
        
        userPhoto.draw(in: photoRect)
       // userPhoto.addEllipse(self: CGContext, in: photoRect)
        
        return photoRect.origin.y + photoRect.size.height
    }
    
    func addJob (pageRect: CGRect) -> CGFloat {
        let surnameFont = UIFont.systemFont(ofSize: 10, weight: .regular)
        
        let surnameAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: surnameFont]
        
//        let surnameAttributes = NSAttributedString(
//        string: surname,
//        attributes: surnameAttributes
//        )
    }

    
}
