//
//  Extensions.swift
//  NETFLIX
//
//  Created by Mesut Aygün on 25.12.2022.
//

import Foundation



extension String {
    func capitalizedFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
