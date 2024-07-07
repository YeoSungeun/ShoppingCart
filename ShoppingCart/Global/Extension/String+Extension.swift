//
//  String+Extension.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/18/24.
//

import UIKit

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding:String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    static func htmlToAtt(htmlStr: String) -> NSMutableAttributedString? {

        guard let data = htmlStr.data(using: .utf8) else {
            return nil
        }
        
        guard let att = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil) else {
            return nil
        }
        
        return att
    }
}
