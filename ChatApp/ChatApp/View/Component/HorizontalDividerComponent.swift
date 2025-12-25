//
//  HorizontalDividerComponent.swift
//  ChatApp
//
//  Created by Vadym Vasylaki on 25.12.2025.
//

import SwiftUI

struct HorizontalDividerComponent: View {
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 2)
            .foregroundStyle(ColorEnum.backgroundPrimary.color)
    }
}

#Preview {
    HorizontalDividerComponent()
}
