//
//  EnumModel.swift
//  ChatApp
//
//  Created by Vadym Vasylaki on 25.12.2025.
//

import Foundation
import SwiftUI

enum ColorEnum: String {
    case accentPrimary, accentSecondary, backgroundPrimary, backgroundSecondary
    
    var color: Color {
        return Color(self.rawValue)
    }
}
