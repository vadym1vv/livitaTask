//
//  ContentViewModel.swift
//  ChatApp
//
//  Created by Vadym Vasylaki on 25.12.2025.
//

import Foundation
import Combine
import CoreData

class ContentViewModel: CoreDataSettings {
    
    @Published var userEntities: [UserEntity] = []
    @Published var postEntities: [PostEntity] = []
    @Published var commentEntities: [CommentEntity] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    
    private var service: NetworkService
    private var cancellables = Set<AnyCancellable>()
    
    init(container: NSPersistentContainer = CoreDataSettings.shared.container, service: NetworkService = NetworkManager.shared) {
        self.service = service
        super.init(container: container)
        fetchAllFromLocal()
    }
    
    func fetchUsers() {
        self.isLoading = true
        service.fetch(endpoint: .users, type: [User].self)
            .sink { [weak self] in self?.handleCompletion($0) }
        receiveValue: { [weak self] returnedUsers in
            self?.saveUsersToCoreData(returnedUsers)
        }
        .store(in: &cancellables)
    }
    
    func fetchPosts(for userId: Int? = nil) {
        self.isLoading = true
        let endpoint: APIEndpoint = userId == nil ? .posts : .postsByUser(userId: userId!)
        
        service.fetch(endpoint: endpoint, type: [Post].self)
            .sink { [weak self] in self?.handleCompletion($0) }
        receiveValue: { [weak self] returnedPosts in
            self?.savePostsToCoreData(returnedPosts)
        }
        .store(in: &cancellables)
    }
    
    func fetchComments(for postId: Int) {
        self.isLoading = true
        service.fetch(endpoint: .commentsForPost(postId: postId), type: [Comment].self)
            .sink { [weak self] in self?.handleCompletion($0) }
        receiveValue: { [weak self] returnedComments in
            self?.saveCommentsToCoreData(returnedComments)
        }
        .store(in: &cancellables)
    }
    
    private func saveUsersToCoreData(_ users: [User]) {
        for user in users {
            let userEntity = userEntities.first(where: {Int($0.userId) == user.id}) ?? UserEntity(context: container.viewContext)
            userEntity.userId = Int64(user.id)
            userEntity.name = user.name
            userEntity.userEmail = user.username
            userEntity.userName = user.email
        }
        saveData()
        fetchAllFromLocal()
    }
    
    private func savePostsToCoreData(_ posts: [Post]) {
        for post in posts {
            let postEntity = postEntities.first(where: {Int($0.postId) == post.id}) ?? PostEntity(context: container.viewContext)
            postEntity.postId = Int64(post.id)
            postEntity.userId = Int64(post.userId)
            postEntity.postBody = post.body
            postEntity.postTitle = post.title
            if let userEntity = userEntities.first(where: {$0.userId == post.userId}) {
                postEntity.userEntity = userEntity
                userEntity.addToPostEntities(postEntity)
            }
        }
        saveData()
        fetchAllFromLocal()
    }
    
    private func saveCommentsToCoreData(_ comments: [Comment]) {
        for comment in comments {
            let commentEntity = commentEntities.first(where: {$0.commentId == comment.id}) ?? CommentEntity(context: container.viewContext)
            commentEntity.commentId = Int64(comment.id)
            commentEntity.commentBody = comment.body
            commentEntity.commentEmail = comment.email
            commentEntity.commentName = comment.name
            if let postEntity = postEntities.first(where: {$0.postId == comment.postId}) {
                commentEntity.postEntity = postEntity
                postEntity.addToCommentEntities(commentEntity)
            }
        }
        saveData()
        fetchAllFromLocal()
    }
    
    func fetchAllFromLocal() {
        self.userEntities = fetchEntities(UserEntity.self)
        self.postEntities = fetchEntities(PostEntity.self)
        self.commentEntities = fetchEntities(CommentEntity.self)
    }
    
    func getDefaultUser() -> UserEntity? {
        var defaultUser = UserDefaults.standard.integer(forKey: "selectedUserId")
        if (defaultUser <= 0) {
            defaultUser = 1
        }
        return userEntities.first(where: {$0.userId == defaultUser})
    }
    
    private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        self.isLoading = false
        if case .failure(let error) = completion {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func getAllCommentsFromPost(postId: Int) -> [CommentEntity] {
        return commentEntities.filter({$0.postEntity?.postId == Int64(postId)})
    }
    
    func getPostsToDisplay(userId: Int? = nil) -> [PostEntity] {
        guard let userId else {
            return postEntities
        }
        let posts = postEntities.filter({$0.userId == userId})
        return posts
    }
}
