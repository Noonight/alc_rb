//
//  TournamentsTableViewController.swift
//  ALC_RB
//
//  Created by user on 27.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class TournamentsTableViewController: BaseStateTableViewController {
    private enum Variables {
        static let errorAlertTitle = "Ошибка!"
        static let errorAlertOk = "Ок"
        static let errorAlertRefresh = "Перезагрузка"
    }
    
    //MARK: - Properties
    
    let tournamentFinished = "Finished"
    
    var tournaments = Tournaments()
    
    let presenter = TournamentsPresenter()
    
    let segueId = "TournamentsDetailSegue"
    
    let cellId = "cell_tournament"
    
    var firstLoad = true
    
//    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        //        tournaments.leagues = [
        //            League(status: "Завершено", matches: [
        //                   "match one",
        //                   "match two"
        //                ], id: "some id", tourney: "Турнир", name: "Имя", beginDate: "10.10.2010", endDate: "10.12.2012", maxTeams: 32, teams: [], transferBegin: "some date transfer", transferEnd: "some date transfer", playersMin: 16, playersMax: 64, playersCapacity: 92, yellowCardsToDisqual: 3, ageAllowedMin: 6, ageAllowedMax: 3)
        //        ]
        
        initPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstLoad {
            presenter.getTournaments(refreshing: firstLoad)
        } else {
            presenter.getTournaments(refreshing: firstLoad)
        }
//        presenter.getTournaments()
        
    }
    
    private func initView() {
        
        tableView.tableFooterView = UIView()
//        prepareActivityIndicator()
    }
    
//    func prepareActivityIndicator() {
//        activityIndicator.hidesWhenStopped = true
//    }
    
    func updateUI() {
        tableView.reloadData()
    }
}

extension TournamentsTableViewController: TournamentsView {
    
//    func showLoading() {
//        tableView.backgroundView = activityIndicator
//        tableView.separatorStyle = .none
//        activityIndicator.startAnimating()
//    }
//
//    func hideLoading() {
//        activityIndicator.stopAnimating()
//        tableView.separatorStyle = .singleLine
//        tableView.backgroundView = nil
//    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
    }
    
    func onGetTournamentSuccess(tournament: Tournaments) {
        self.tournaments = tournament
        if firstLoad {
            firstLoad = !firstLoad
        }
        updateUI()
    }
    
    func onGetTournamentFailure(error: Error) {
//        showAlert(title: Variables.errorAlertTitle, message: error.localizedDescription, actions:
//            [
//                UIAlertAction(title: Variables.errorAlertOk, style: .default, handler: nil),
//                UIAlertAction(title: Variables.errorAlertRefresh, style: .default, handler: { (action) in
//                    self.presenter.getTournaments()
//                })
//            ]
//        )
        showRefreshAlert(message: error.localizedDescription) {
            self.firstLoad = true
            self.presenter.getTournaments(refreshing: self.firstLoad)
        }
        Print.m(error.localizedDescription)
    }
}

extension TournamentsTableViewController {
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournaments.leagues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TournamentTableViewCell
        let model = tournaments.leagues[indexPath.row]
        
        configureCell(cell, model)
        
        return cell
    }
    
    func configureCell(_ cell: TournamentTableViewCell, _ model: League) {
        cell.title?.text = model.tourney + ". " + model.name
        cell.date?.text = "\(model.beginDate.UTCToLocal(from: .leagueDate, to: .local)) - \(model.endDate.UTCToLocal(from: .leagueDate, to: .local))"
        //cell.date?.text = "10.03.2018 - 10.04.2018"
        //cell.commandNum?.text = "Количество команд: \(tournaments.leagues[indexPath.row].maxTeams)"
        cell.commandNum?.text = String(model.maxTeams)
        cell.img?.image = #imageLiteral(resourceName: "ic_con")
        if (model.status == tournamentFinished) {
            cell.img?.image = UIImage(named: "ic_fin")
            //cell.status.text = "Завершен"
            cell.status.isHidden = false
        } else {
            //cell.status.text = ""
            cell.status.isHidden = true
        }
    }
}

extension TournamentsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TournamentsTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueId,
            let destination = segue.destination as? LeagueDetailViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            //destination.league = tournaments.leagues[cellIndex]
            destination.leagueDetailModel = LeagueDetailModel(tournaments.leagues[cellIndex])
        }
    }
}

