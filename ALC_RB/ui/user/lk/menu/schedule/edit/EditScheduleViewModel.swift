//
//  EditScheduleViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
//import RxCocoa

class EditScheduleViewModel {
    struct SlidersData {
        var defaultValues: [Referee]
        // DEPRECATED: [Person]
        var allReferees: [Person]
        
        init(defaultValues: [Referee], allReferees: [Person]) {
            self.defaultValues = defaultValues
            self.allReferees = allReferees
        }
        
        init() {
            defaultValues = []
            allReferees = []
        }
        
//        func setReferee(oldRefId: String, newRefId: String) {
//            defaultValues.swapAt(defaultValues.firstIndex(where: { (ref) -> Bool in
//                return re == oldRefId
//            }), defaultValues.append(Referee()))
//        }
    }
    
    var refreshing: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<Error> = PublishSubject()
    var message = PublishSubject<SingleLineMessage>()
//    var activeMatch: PublishSubject<ActiveMatch> = PublishSubject()
//    var referees: PublishSubject<[Person]> = PublishSubject()
    
    var comingCellModel: Variable<ScheduleRefCell.CellModel> = Variable<ScheduleRefTableViewCell.CellModel>(ScheduleRefTableViewCell.CellModel())
    var comingReferees: Variable<[Person]> = Variable<[Person]>([])
    
    var sliderData: PublishSubject<SlidersData> = PublishSubject()
    
    var editedMatch = Variable<Match?>(nil)
    
    private let matchApi: MatchApi
    private let personApi: PersonApi
    private let leagueApi: LeagueApi
    
    var cache: EditMatchReferees?
    
    init(matchApi: MatchApi, personApi: PersonApi, leagueApi: LeagueApi) {
        self.matchApi = matchApi
        self.personApi = personApi
        self.leagueApi = leagueApi
    }
    
    func fetchReferees() {
        self.refreshing.onNext(true)
        personApi.get_person { result in
            switch result {
            case .success(let persons):
                self.comingReferees.value = persons
//                self.comingReferees.value = [Person](persons: persons, count: persons.count)
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
                self.error.onNext(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
            self.refreshing.onNext(false)
        }
    }
    
    func fetchLeague(id: String, resultMy: @escaping (ResultMy<[League], RequestError>) -> ()) {
        leagueApi.get_league(id: id, resultMy: resultMy)
    }
    
//    func fetchLeagueInfo(id: String, success: @escaping (League)->(), r_message: @escaping (SingleLineMessage) -> (), failure: @escaping (Error)->()) {
////        dataManager.get_tournamentLeague(id: id, get_success: { leagueInfo in
////            success(leagueInfo)
////        }, get_error: { error in
////            failure(error)
//////            Print.m(error)
////        })
//        dataManager.get_tournamentLeague(id: id) { result in
//            switch result {
//            case .success(let league):
//                success(league)
//            case .message(let message):
//                r_message(message)
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
    
    func editMatchReferees(token: String, editMatchReferees: EditMatchReferees, success: @escaping (Match)->(), message_single: @escaping (SingleLineMessage)->(), failure: @escaping (Error)->()) {
        self.cache = editMatchReferees
//        dataManager.post_matchSetReferee(token: token, editMatchReferees: editMatchReferees, response_success: { soloMatch in
//                success(soloMatch)
//            }, response_message: { message in
//                message_single(message)
//            }) { error in
//                failure(error)
//            }
        self.refreshing.onNext(true)
        matchApi.post_matchSetReferee(token: token, editMatchReferees: editMatchReferees) { result in
            self.refreshing.onNext(false)
            switch result {
            case .success(let match):
                self.editedMatch.value = match
            case .message(let message):
                Print.m(message.message)
                self.message.onNext(message)
            case .failure(let error):
                Print.m(error)
                self.error.onNext(error)
            }
        }
    }
    
//    func acceptMatch(token: String, protocolID: String, success: @escaping (SingleLineMessage) -> (), failure: @escaping (Error) -> ()) {
//        dataManager.post_acceptProtocol(token: token, id: protocolID, success: { message in
//            success(message)
//        }) { error in
//            failure(error)
//        }
//    }
    
}
