//
//  MyMatchesRefViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 21/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift

class MyMatchesRefViewModel {
    
    var message = PublishSubject<SingleLineMessage>()
    var refreshing: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<Error> = PublishSubject()
    var participationMatches: Variable<[Match]> = Variable<[Match]>([])
    var tableModel: PublishSubject<[MyMatchesRefTableViewCell.CellModel]> = PublishSubject()
//    var firstInit: Variable<Bool> = Variable<Bool>(true)
    
    var matchApi: MatchApi?
    
    init(matchApi: MatchApi) {
        self.matchApi = matchApi
    }
    
    func fetch(closure: @escaping () -> ())
    {
        Print.m(participationMatches.value)
        if participationMatches.value.count > 0 {
            refreshing.onNext(true)
            
//            self.dataManager?.get_forMyMatches(participationMatches: participationMatches.value, get_success: { (cellModels) in
//                Print.m("request for my matches complete with success code")
//                dump(cellModels)
//                self.tableModel.onNext(cellModels)
//                self.refreshing.onNext(false)
//                closure()
////                Print.m(cellModels)
//            }, get_failure: { (error) in
//                self.error.onNext(error)
//            })
        } else {
            self.tableModel.onNext([])
            closure()
//            self.error.onNext(Error)
        }
        
        if participationMatches.value.count > 0 {
            refreshing.onNext(true)
            matchApi?.get_myMatchesCellModels(participationMatches: participationMatches.value, resultMy: { result in
                self.refreshing.onNext(false)
                switch result {
                case .success(let cells):
                    dump(cells)
                    self.tableModel.onNext(cells)
                case .message(let message):
                    self.message.onNext(message)
                case .failure(let error):
                    self.error.onNext(error)
                }
            })
        }
    }
    
    func fetchLeagueInfo(id: String, success: @escaping ([League])->(), r_message: @escaping (SingleLineMessage) -> (), failure: @escaping (Error)->()) {
//        dataManager?.get_tournamentLeague(id: id, result: { result in
//            switch result {
//            case .success(let league):
//                success(league)
//            case .message(let message):
//                r_message(message)
//            case .failure(let error):
//                failure(error)
//            }
//        })
    }
}
