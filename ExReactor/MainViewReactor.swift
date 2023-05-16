//
//  MainViewReactor.swift
//  ExReactor
//
//  Created by LEE on 2023/05/03.
//

import Foundation
import ReactorKit
import Alamofire

class MainViewReactor : Reactor {
    
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case firstload(MainData)
    }
    
    struct State {
        var listData:[MainData.User] = []
    }
    
    
    let initialState:State
    
    
    init() {
        self.initialState = State()
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .load:
            return self.load().map(Mutation.firstload)
        }
        
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .firstload(let data):
            if let newUsers = data.users {
                newState.listData.append(contentsOf: newUsers)
            }
        }
        return newState
    }
    
}

extension MainViewReactor {
    func load() -> Observable<MainData> {
        
        guard let url = URL(string: "https://dummyjson.com/users") else { return Observable.empty()}
        
        return Observable.create { observer -> Disposable in
            AF.request(url, method: .get).responseDecodable(of: MainData.self) { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    observer.onNext(data)
                    break
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                    break
                }
            }
            
            return Disposables.create()
            
        }
 

    }
}


struct MainData: Decodable {

    let total: Int?
    let limit: Int?
    let users: [User]?
    struct User: Codable {
 
        let bloodGroup: String?
        let birthDate: String?
        let age: Int?
        let id: Int?
        let image: String?
        let password: String?
        let phone: String?
        let eyeColor: String?
        let lastName: String?
        let userAgent: String?
        let email: String?
        let ssn: String?
        let ip: String?
        let gender: String?
        let ein: String?
        let macAddress: String?
        let username: String?
        let university: String?
        let maidenName: String?
        let firstName: String?
        let domain: String?
    
    }



}
