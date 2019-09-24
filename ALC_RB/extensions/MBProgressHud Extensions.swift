//
//  MBProgressHud Extensions.swift
//  ALC_RB
//
//  Created by ayur on 27.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import MBProgressHUD

extension MBProgressHUD {
    func setToCustomView(with view: UIView, message: String?)// -> MBProgressHUD
    {
        self.customView = view
        self.mode = MBProgressHUDMode.customView
        
        if let curMessage = message {
            self.label.text = curMessage
        }
        self.detailsLabel.text = nil
        
        //return self
    }
    
    func setToFailureWith(message: String? = Constants.Texts.FAILURE, detailMessage: String?)// -> MBProgressHUD
    {
        self.setToCustomView(with: UIImageView(image: UIImage(named: "hud_cross")), message: message)
        
        if let curDetailMessage = detailMessage {
            self.detailsLabel.text = curDetailMessage
        } else {
            self.detailsLabel.text = nil
        }
        
        //return self
    }
    
    func setToSuccessWith(message: String? = Constants.Texts.SUCCESS)// -> MBProgressHUD
    {
        self.setToCustomView(with: UIImageView(image: UIImage(named: "hud_checkmark")), message: message)
        
        self.detailsLabel.text = nil
        
        //return self
    }
    
    func setDetailMessage(with detailMessage: String)
    {
        self.detailsLabel.text = detailMessage
    }
    
    func hideAfter(seconds: Int = 1)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds), execute: {
            self.hide(animated: true)
        })
    }
    
    // also hide after 1 second
    func showSuccessAfterAndHideAfter(showAfter: Int = 1, hideAfter: Int = 1, withMessage: String? = Constants.Texts.SUCCESS)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(showAfter), execute: {
            self.setToSuccessWith(message: withMessage)
            self.hideAfter(seconds: hideAfter)
        })
    }
    
    func setToButtonHUD(message: String? = Constants.Texts.REPEAT, detailMessage: String? = "", btn: @escaping () -> ()) {
        self.backgroundView.style = .solidColor
        self.backgroundView.color = UIColor(white: 0, alpha: 0.1)
        
        self.label.text = message
        self.detailsLabel.text = detailMessage
        
        self.tapAction(action: btn)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnHud))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func tapOnHud() {
        self.tapAction()
    }
    
    private func tapAction(action: (() -> ())? = nil) {
        struct __ { static var action :(() -> Void)? }
        if action != nil { __.action = action }
        else { __.action?() }
    }
}
