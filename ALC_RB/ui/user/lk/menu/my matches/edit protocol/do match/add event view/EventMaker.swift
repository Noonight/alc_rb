//
//  EventMaker.swift
//  ALC_RB
//
//  Created by ayur on 29.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class EventMaker: NSObject {
    static let SIZE = CGRect(x: 0, y: 0, width: 278, height: 70)
    static let BACKGROUND_COLOR = UIColor(white: 0, alpha: 0.1)
    
    let eventView = AddEventView(frame: SIZE)
    var onHideAddTriggered: ((LIEvent) -> ())
    var onHideDeleteTriggered: ((DeleteEvent) -> ())
    var backgroundView = UIView()
    var curMatchId: String!
    var curPlayerId: String!
    var curTime: String!
    
    init(addEventBack: @escaping (LIEvent) -> (), deleteEventBack: @escaping (DeleteEvent) -> ()) {
        self.onHideAddTriggered = addEventBack
        self.onHideDeleteTriggered = deleteEventBack
    }
    
    // MARK: WORK WORK VIEW CONTROLLER
    
    public func showWith(matchId: String, playerId: String, time: String) { // TODO modify time
        self.curMatchId = matchId
        self.curPlayerId = playerId
        self.curTime = time
        
        self.eventView.callBacks = self
        self.eventView.playerId = self.curPlayerId
        
        if let window = UIApplication.shared.keyWindow {
            backgroundView.backgroundColor = EventMaker.BACKGROUND_COLOR
            backgroundView.alpha = 0
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(hideBackgroundView))
            )
            
            window.addSubview(backgroundView)
            window.addSubview(eventView)
            
            eventView.setCenterFromParent()
            
            Print.m(backgroundView.frame)
            
            backgroundView.frame = window.frame
            
            Print.m(backgroundView.frame)
            
            eventView.alpha = 0
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.backgroundView.alpha = 1
                
                self.eventView.alpha = 1
            }, completion: nil)
        }
    }
    
    public func hideAdd(eventType: LIEvent.SystemEventType) -> LIEvent {
        self.hideBackgroundView()
        return LIEvent().with(
            id: self.curMatchId,
            eventType: eventType.rawValue,
            player: self.curPlayerId,
            time: self.curTime
        )
    }
    
    public func hideDelete(eventType: LIEvent.SystemEventType) -> DeleteEvent {
        self.hideBackgroundView()
        return DeleteEvent(
            playerId: self.curPlayerId,
            eventType: eventType
        )
    }
    
    func hide(eventType: LIEvent.SystemEventType) {
        if self.eventView.stateMinusActive == true
        {
            onHideDeleteTriggered(hideDelete(eventType: eventType))
        }
        else
        {
            onHideAddTriggered(hideAdd(eventType: eventType))
        }
    }
    
    // MARK: HELPERS
    
    @objc func hideBackgroundView() {
        UIView.animate(withDuration: 0.2)
        {
            self.backgroundView.alpha = 0
            self.eventView.alpha = 0
        }
    }
    
}

extension EventMaker: EventCallBack {
    func onGoalPressed(playerId: String) {
        hide(eventType: .goal)
    }
    
    func onSuccessPenaltyPressed(playerId: String) {
        hide(eventType: .penalty)
    }
    
    func onFailurePenaltyPressed(playerId: String) {
        hide(eventType: .penaltyFailure)
    }
    
    func onYellowCardPressed(playerId: String) {
        hide(eventType: .yellowCard)
    }
    
    func onRedCardPressed(playerId: String) {
        hide(eventType: .redCard)
    }
}

// MARK: DELETE EVENT STRUCT

extension EventMaker {
    
    struct DeleteEvent {
        var playerId: String
        var eventType: LIEvent.SystemEventType
    }

}
