//
//  SinglePostView.swift
//  ChatApp
//
//  Created by Vadym Vasylaki on 25.12.2025.
//

import SwiftUI

struct SinglePostView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var contentViewModel: ContentViewModel
    
    let postId: Int
    
    var postComments: [CommentEntity] {
        return contentViewModel.getAllCommentsFromPost(postId: postId)
    }
    
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
                    Text("Comments (\(postComments.count))")
                    .font(.headline)
                    .foregroundStyle(ColorEnum.accentPrimary.color),
                trailingView:
                    EmptyView()
            )
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(postComments, id: \.self) { postComment in
                        DescriptionCardComponent(title: postComment.commentEmail, cardBody: postComment.commentBody)
                        
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .background(ColorEnum.backgroundPrimary.color)
        .onAppear {
            contentViewModel.fetchComments(for: postId)
        }
    }
}

#Preview {
    SinglePostView(contentViewModel: ContentViewModel(), postId: 1)
}
