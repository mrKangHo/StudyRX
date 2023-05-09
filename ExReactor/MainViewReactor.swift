//
//  MainViewReactor.swift
//  ExReactor
//
//  Created by LEE on 2023/05/03.
//

import Foundation
import ReactorKit

class MainViewReactor : Reactor {
    
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case firstload
    }
    
    struct State {
        var listData:[String] = []
    }
    
    
    let initialState:State
    
    
    init() {
        self.initialState = State()
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .load:
            return Observable.just(.firstload)
        }
        
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .firstload:
            newState.listData.append("처음")
        }
        return newState
    }
    
    
    
    
    
    
}
