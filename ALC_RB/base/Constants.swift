//
//  Constants.swift
//  ALC_RB
//
//  Created by ayur on 27.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Constants {
    struct Texts {
        static let LOADING              = "Загрузка..."
        static let COMPLETED            = "Завершена"
        static let SUCCESS              = "Успех"
        static let FAILURE              = "Ошибка!"
        static let CANCEL               = "Отмена"
        static let CONFIGURE            = "Настройка..."
        static let REPEAT               = "Повторить..."
        static let SERVER_FAILURE       = "Серверная ошибка!"
        static let UNDEFINED_FAILURE    = "Неизвестная ошибка!"
        static let NOTHING              = "Ничего нет"
        static let TAP_FOR_REPEAT       = "Нажмите чтобы перезагрузить..."
    }
//    struct Images {
//        static let Q_INFO       = UIImage(named: "ic_info")
//        static let PROTOCOL     = UIImage(named: "ic_document")
//    }
    struct Sizes {
        static let NAV_BAR_ICON_SIZE = CGSize(width: 22, height: 22)
    }
    struct Values {
        static let LIMIT        = 30
        static let LIMIT_ALL    = 10000
    }
}
