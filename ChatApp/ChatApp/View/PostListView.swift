//
//  PostView.swift
//  ChatApp
//
//  Created by Vadym Vasylaki on 25.12.2025.
//

import SwiftUI

struct PostListView: View {
    
    @StateObject private var contentViewModel: ContentViewModel = ContentViewModel()
   
    var postsToDisplay: [PostEntity] {
        let userDefaultId = UserDefaults.standard.integer(forKey: "selectedUserId")
        if (userDefaultId > 0) {
            return contentViewModel.getPostsToDisplay(userId: userDefaultId)
        } else {
           return contentViewModel.getPostsToDisplay()
        }
        
    }
 
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TopBarNavigationComponent(
                    leadingView:
                        EmptyView(),
                    centerView:
                        Text(contentViewModel.getDefaultUser()?.name ?? "")
                        .padding()
                        .font(.headline)
                        .foregroundStyle(ColorEnum.accentPrimary.color),
                    trailingView:
                        NavigationLink {
                            UserListView(contentViewModel: contentViewModel)
                        } label: {
                            Image("userIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                )
                
                VStack {
                    VStack {
                        ScrollView(showsIndicators: false) {
                            ForEach(postsToDisplay, id: \.self) { post in
                                NavigationLink {
                                    SinglePostView(contentViewModel: contentViewModel, postId: Int(post.postId))
                                } label: {
                                    DescriptionCardComponent(title: post.postTitle, cardBody: post.postBody)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ColorEnum.backgroundSecondary.color)
            }
            .background(ColorEnum.backgroundPrimary.color)
            .onAppear {
                let userDefaultId = UserDefaults.standard.integer(forKey: "selectedUserId")
                if (userDefaultId > 0) {
                    contentViewModel.fetchPosts(for: userDefaultId)
                } else {
                    contentViewModel.fetchPosts()
                }
                
                contentViewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    NavigationView {
        PostListView()
    }
}
