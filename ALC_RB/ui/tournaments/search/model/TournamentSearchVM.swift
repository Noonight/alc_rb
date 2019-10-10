//
//  TournamentSearchVM.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 06/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TournamentSearchVM {
    
    private let localTourneys = LocalTourneys()
    private let userDefaultsHelper = UserDefaultsHelper()
    
    private var regions: [RegionMy] = []
    private var choosedRegion: RegionMy?
    private var searchingQuery: String?
    
    private var tourneyMIs: [TourneyModelItem] = []
    private var filteredTourneysMIs: [TourneyModelItem] = []
    
    private var previousTourneys: Int = 0 {
        didSet {
            Print.m(self.previousTourneys)
        }
    }
    private var previousFilteredTourneys: Int = 0
    
    var isSearching: Bool {
        get {
            if self.searchingQuery == nil && self.choosedRegion == nil
            {
                return false
            }
            return true
        }
    }
    var isInfinite: Bool {
        get {
//            if self.isSearching
//            {
//                Print.m("\(filteredTourneysMIs.count) >= \(previousFilteredTourneys)")
//                if filteredTourneysMIs.count >= previousFilteredTourneys
//                {
//                    return true
//                }
//                else
//                {
//                    return false
//                }
//            }
//            else
//            {
//                Print.m("\(tourneyMIs.count) >= \(previousTourneys)")
//                if tourneyMIs.count >= previousTourneys
//                {
//                    return true
//                }
//                else
//                {
//                    return false
//                }
//            }
            return false
        }
    }
    
    // MARK: PREPARE
    
    func prepareRegions() -> [RegionMy] {
        return self.regions
    }
    // ------
    func prepareSearchingQuery() -> String? {
        return self.searchingQuery
    }
    
    func prepareChoosedRegion() -> RegionMy? {
        return self.choosedRegion
    }
    // ------
    func prepareTourneyMIs() -> [TourneyModelItem] {
        if self.isSearching == true
        {
            return self.getSelectedTourneysAndNot(tourneys: self.filteredTourneysMIs.map({ tourneyMI -> Tourney in
                return tourneyMI.getTourney()
            }))
//            return self.filteredTourneysMIs
        }
//        return self.tourneyMIs
        return self.getSelectedTourneysAndNot(tourneys: self.tourneyMIs.map({ tourneyMI -> Tourney in
            return tourneyMI.getTourney()
        }))
    }
    // ------
    func prepareChoosedTourneys() -> [Tourney] {
        if self.isSearching == true
        {
            let tourneys = filteredTourneysMIs.filter { tourneyMI -> Bool in
                return tourneyMI.isSelected == true
            }
            return tourneys.map { tourneyMI -> Tourney in
                return tourneyMI.getTourney()
            }
        }
        let tourneys = tourneyMIs.filter { tourneyMI -> Bool in
            return tourneyMI.isSelected == true
        }
        return tourneys.map { tourneyMI -> Tourney in
            return tourneyMI.getTourney()
        }
    }
    // ------
    func prepareOffset() -> Int {
        return 0
//        if self.isSearching == true
//        {
//            return self.previousFilteredTourneys
//        }
//        return self.previousTourneys
    }
    
    // MARK: UPDATE
    
    func updateRegions(newRegions: [RegionMy]) {
        self.regions = newRegions
    }
    // ------
    func updateSearchingQuery(newQuery: String?) {
        self.searchingQuery = newQuery
    }
    
    func updateChoosenRegion(newRegion: RegionMy?) {
        self.choosedRegion = newRegion
    }
    // ------
    func updateTourneys(tourneys: [Tourney]) {
        if self.isSearching == true
        {
            if self.isInfinite == true
            {
                self.filteredTourneysMIs.append(contentsOf: self.getSelectedTourneysAndNot(tourneys: tourneys))
                self.previousFilteredTourneys = self.filteredTourneysMIs.count
                return
            }
            else
            {
                self.filteredTourneysMIs = self.getSelectedTourneysAndNot(tourneys: tourneys)
                return
            }
        }
        else
        {
            if self.isInfinite == true
            {
                self.tourneyMIs.append(contentsOf: self.getSelectedTourneysAndNot(tourneys: tourneys))
                self.previousTourneys = self.tourneyMIs.count
                return
            }
            else
            {
                self.tourneyMIs = getSelectedTourneysAndNot(tourneys: tourneys)
                dump(self.tourneyMIs)
                return
            }
        }
        
    }
}

// MARK: HELPERS

extension TournamentSearchVM {
    
    func setLocalTourney(tourney: TourneyModelItem) {
        Print.m("tourney is \(tourney.isSelected)")
        if tourney.isSelected
        {
            localTourneys.appendTourney(tourney.getTourney())
        }
        else
        {
            localTourneys.removeTourney(tourney.getTourney())
        }
        Print.m("local tourneys are \(localTourneys.getLocalTourneys())")
    }
    
//    func setLocalTourneys() {
//        if isSearching == true
//        {
//            self.localTourneys.helperUpdateItems(items: self.filteredTourneysMIs)
//        }
//        else
//        {
//            self.localTourneys.helperUpdateItems(items: self.tourneyMIs)
//        }
//    }
    
    func getParticipationTourneys() -> [Participation] {
        return userDefaultsHelper.getAuthorizedUser()?.person.participation ?? []
    }
    
    func getSelectedTourneysAndNot(tourneys: [Tourney]) -> [TourneyModelItem] {
        let alreadyChoosedTourneys = self.localTourneys.getLocalTourneys()
        
        var resultArray: [TourneyModelItem] = []
        
        if alreadyChoosedTourneys.count == 0
        {
            
            for i in 0..<tourneys.count
            {
                
                for j in 0..<alreadyChoosedTourneys.count
                {
                    if tourneys[i].id == alreadyChoosedTourneys[j].id
                    {
                        let tourneyModelItem = TourneyModelItem(item: tourneys[i])
                        tourneyModelItem.isSelected = true
                        if !resultArray.contains(where: { tourneyItem -> Bool in
                            return tourneyItem.getTourney().id == tourneyModelItem.getTourney().id
                        })
                        {
                            resultArray.append(tourneyModelItem)

                        }
                    }
                    else
                    {
                        if !resultArray.contains(where: { tourneyItem -> Bool in
                            return tourneyItem.getTourney().id == tourneys[i].id
                        })
                        {
                            resultArray.append(TourneyModelItem(item: tourneys[i]))
                        }
                    }
                }
            }
        }
        else
        {
            resultArray = tourneys.map({ tourney -> TourneyModelItem in
                return TourneyModelItem(item: tourney)
            })
        }
        
        return resultArray
    }
    
    func findRegionByName(name: String) -> RegionMy? {
        return self.regions.filter { region -> Bool in
            return region.name == name
        }.first
    }
    
}
