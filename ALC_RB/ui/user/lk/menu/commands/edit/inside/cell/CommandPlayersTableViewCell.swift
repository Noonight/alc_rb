//
//  CommandPlayersTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Alamofire

class CommandPlayersTableViewCell: UITableViewCell {

    struct CellModel {
//        var player: Person?
        var person: Person?
        var playerImagePath: String?
        var number: Int = 0
        
        init(playerImagePath: String, person: Person) {
            self.playerImagePath = playerImagePath
            self.person = person
        }
        
        init() {
            person = Person()
            playerImagePath = ""
        }
    }
    
    var cellModel: CellModel? {
        didSet {
            updateCell()
        }
    }
    
    private var playerNumberTextDidEndProtocol: OnCommandPlayerEditNumberCompleteProtocol?
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerNumberTextField: UITextField!
    @IBOutlet weak var playerCommandNumLabel: UILabel!
//    @IBOutlet weak var playerDeleteBtn: UIButton!
    
    func setPlayerNumberTextDidEnd(didEndProtocol: OnCommandPlayerEditNumberCompleteProtocol) {
        self.playerNumberTextDidEndProtocol = didEndProtocol
    }
    
    private func updateCell() {
        playerImage.af_setImage(withURL: ApiRoute.getImageURL(image: (cellModel?.playerImagePath)!))
        playerImage.image = playerImage.image?.af_imageRoundedIntoCircle()
//        playerImage.image = cellModel?.playerImage?.af_imageRoundedIntoCircle()
        playerNameLabel.text = cellModel?.person?.getFullName()
//        playerNumberTextField.text = cellModel?.player?.number
        let strNumber: String = String(cellModel!.number)
        playerCommandNumLabel.text = strNumber
    }
    // DEPRECATED: SHEET EHERE
    @IBAction func onPlayerNumberTextEditComplete(_ sender: UITextField) {
//        cellModel?.player?.number = sender.text ?? "-1"// Something went wrong
        playerNumberTextDidEndProtocol?.onEditNumberComplete(model: cellModel!)
    }
    
}
