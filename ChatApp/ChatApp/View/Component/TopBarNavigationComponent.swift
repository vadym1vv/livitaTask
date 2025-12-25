//
//  TopBarNavigationComponent.swift
//  ChatApp
//
//  Created by Vadym Vasylaki on 25.12.2025.
//

import SwiftUI

struct TopBarNavigationComponent<LeadingView: View, CenterView: View, TrailingView: View>: View {
    
    var leadingView: LeadingView
    var centerView: CenterView
    var trailingView: TrailingView
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ZStack {
                    centerView
                        .padding(.horizontal, UIScreen.main.bounds.width / 7)
                    HStack {
                        leadingView
                        Spacer()
                        trailingView
                    }
                    .padding()
                }
            }
        }
    }
}

@available(iOS 15.0, *)
struct TopBarNavigationComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TopBarNavigationComponent(leadingView: Text("Leading text"), centerView: Text("lorem")
                .frame(maxWidth: .infinity), trailingView: Text("Trailing text"))
            Spacer()
        }
    }
}

