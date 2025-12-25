//
//  DescriptionCardComponent.swift
//  ChatApp
//
//  Created by Vadym Vasylaki on 25.12.2025.
//

import SwiftUI

struct DescriptionCardComponent: View {
    
    let title: String?
    var cardBody: String? = nil
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(title ?? "-")
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundStyle(ColorEnum.accentPrimary.color)
                    if let cardBody {
                        Text(cardBody)
                            .lineLimit(2)
                            .foregroundStyle(ColorEnum.accentSecondary.color)
                            .multilineTextAlignment(.leading)
                    }
                }
                Spacer()
            }
            HorizontalDividerComponent()
        }
    }
}

#Preview {
    DescriptionCardComponent(title: "sunt aut face repellat", cardBody: "est reruasfa sf asf asf asf asf asf asf asf asf asf asf asf asf asf asf asf asf a fsas fas fas fa sfa sfasf asf asf asf asf asf asf ")
        .background(ColorEnum.backgroundSecondary.color)
}
