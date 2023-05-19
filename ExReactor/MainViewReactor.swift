//
//  MainViewReactor.swift
//  ExReactor
//
//  Created by LEE on 2023/05/03.
//

import Foundation
import ReactorKit
import Alamofire
import RxDataSources

enum MainCellType {
    case userCell
    case productCell
}

enum MainSectionItem {
    case users([MainUser.User])
    case products([MainProduct.Product])
}


struct MainSectionModel {
    var cellType:MainCellType
    var items:[MainSectionItem]
}

extension MainSectionModel : SectionModelType {
    typealias Item = MainSectionItem
    
    init(original: MainSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}



class MainViewReactor : Reactor {
    
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case firstload([MainSectionModel])
    }
    
    struct State {
        
        var listData:[MainSectionModel] = []
    }
    
    
    let initialState:State
    
    
    init() {
        self.initialState = State()
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .load:
            return Observable.combineLatest(self.getUsers(), self.getProducts()).map { users, products in
                var items:[MainSectionModel] = []
                if let userList = users.users {
                    let ss = userList.map { user in
                        return MainSectionModel(cellType: .userCell, items: [MainSectionItem.users([user])])
                    }
                    items.append(contentsOf: ss)
                }
                
                let productList = products.products
                let ss = productList.map { product in
                    return MainSectionModel(cellType: .productCell, items: [MainSectionItem.products([product])])
                }
                items.append(contentsOf: ss)
                
                return Mutation.firstload(items)
            }
        }
        
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .firstload(let data):
            newState.listData = data
        }
        return newState
    }
    
}

extension MainViewReactor {
    func getUsers() -> Observable<MainUser> {
        
        guard let url = URL(string: "https://dummyjson.com/users") else { return Observable.empty()}
        
        return Observable.create { observer -> Disposable in
            AF.request(url, method: .get).responseDecodable(of: MainUser.self) { response in
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
    
    func getProducts() -> Observable<MainProduct> {
        guard let url = URL(string:"https://dummyjson.com/products/") else { return Observable.empty()}
        return Observable.create { observer -> Disposable in
            AF.request(url, method: .get).responseDecodable(of:MainProduct.self) { response in
                switch response.result {
                case .success(let data):
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


struct MainUser: Decodable {

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

struct MainProduct: Codable {

    let total: Int
    let limit: Int

    struct Product: Codable {

        let brand: String
        let images: [String]
        let id: Int
        let thumbnail: String
        let description: String
        let title: String
        let rating: Double
        let discountPercentage: Double
        let category: String
        let price: Int
        let stock: Int
    
    }

    let products: [Product]

    let skip: Int

}
