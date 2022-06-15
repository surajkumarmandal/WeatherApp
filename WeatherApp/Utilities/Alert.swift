//
//  Alert.swift
//  WeatherApp
//
//  Created by Suraj Kumar Mandal on 15/06/22.
//

import Foundation
import UIKit

struct Alert {
    
    static func showAlertWithAction(vc:UIViewController,
                                    title: String,
                                    message: String,
                                    alertStyle:UIAlertController.Style,
                                    actionTitles:[String],
                                    actionStyles:[UIAlertAction.Style],
                                    actions: [((UIAlertAction) -> Void)]){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated(){
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.addAction(action)
        }
        DispatchQueue.main.async {
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
    //Show common internet failure alert
    static func showInternetFailureAlert(on vc:UIViewController){
        showAlertWithAction(vc: vc, title: Constant.internetAlertTitle, message: Constant.internetAlertMessage, alertStyle: .alert, actionTitles: ["Cancel", "Open Setting"], actionStyles: [.cancel, .default], actions: [
            {_ in
                print("cancel click")
            },
            {_ in
                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        ])
    }
    
}
