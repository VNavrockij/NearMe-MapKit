//
//  String+Extension.swift
//  NearMe
//
//  Created by Vitalii Navrotskyi on 18.04.2024.
//

import Foundation

extension String {
    var formatPhoneForCall: String {
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
