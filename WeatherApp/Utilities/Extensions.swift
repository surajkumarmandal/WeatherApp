//
//  Extensions.swift
//  WeatherApp
//
//  Created by Suraj Kumar Mandal on 15/06/22.
//

import Foundation
import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
