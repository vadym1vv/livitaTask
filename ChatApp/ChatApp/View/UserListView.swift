//
//  UserListView.swift
//  ChatApp
//
//  Created by Vadym Vasylaki on 25.12.2025.
//

import SwiftUI

struct UserListView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var contentViewModel: ContentViewModel
    
    var body: some View {
        VStack {
            TopBarNavigationComponent(
                leadingView:
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(ColorEnum.accentPrimary.color)
                    }),
                centerView:
                    Text("\(contentViewModel.getDefaultUser()?.name ?? "")")
                    .font(.headline)
                    .foregroundStyle(ColorEnum.accentPrimary.color),
                trailingView:
                    EmptyView()
            )
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(contentViewModel.userEntities, id: \.self) { user in
                        Button {
                            if (Int(user.userId) != UserDefaults.standard.integer(forKey: "selectedUserId")) {
                                UserDefaults.standard.set(user.userId, forKey: "selectedUserId")
                            } else {
                                UserDefaults.standard.set(0, forKey: "selectedUserId")
                            }
                            dismiss()
                        } label: {
                            DescriptionCardComponent(title: "\(user.name ?? "") \(user.userName ?? "")")
                        }
                        
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .background(ColorEnum.backgroundPrimary.color)
        .onAppear {
            contentViewModel.fetchUsers()
        }
    }
}

#Preview {
    UserListView(contentViewModel: ContentViewModel())
}
