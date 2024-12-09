//
//  String.swift
//  Action
//
//  Created by Mohammed Lazim on 2/17/19.
//  Copyright © 2019-2020 Omnissa, LLC.

import Foundation

extension String {

    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
}
