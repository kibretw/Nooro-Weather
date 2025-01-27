//
//  Font.swift
//  Nooro Weather
//
//  Created by Kibret Woldemichael on 1/26/25.
//

import SwiftUI

public extension Font {
    static func poppins(_ size: CGFloat, weight: Font.Weight? = nil) -> Font {
        switch weight {
        case .bold:
            return Font.custom("Poppins-Bold", size: size)
        case .medium:
            return Font.custom("Poppins-Medium", size: size)
        default:
            return Font.custom("Poppins-Regular", size: size)
        }
    }
}
