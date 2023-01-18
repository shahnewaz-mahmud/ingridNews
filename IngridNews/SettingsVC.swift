//
//  SettingsVC.swift
//  IngridNews
//
//  Created by BJIT on 1/18/23.
//

import UIKit

class SettingsVC: UIViewController {
    
    
    @IBOutlet weak var tabBarBackground: UIView!
    
    @IBOutlet weak var headerBackground: UIView!
    
    @IBOutlet weak var darkModetoggle: UISwitch!
    
    @IBOutlet var pageBackground: UIView!
    
    @IBOutlet weak var darkModeText: UILabel!
    
    @IBOutlet weak var darkModeIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarBackground.layer.cornerRadius = 25
        headerBackground.clipsToBounds = true
        headerBackground.layer.cornerRadius = 40
        headerBackground.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        headerBackground.dropShadow()
    }
    
    
    @IBAction func darkModeToggleAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.windows.first
        
        if darkModetoggle.isOn{
           print("on")
            
            let userInfo = UserDefaultsHelper.shared.getSavedData(key: Constants.userDefaultsUser)
            guard var userInfo = userInfo else {
                return
            }
            userInfo.isDarkmode = true
            UserDefaultsHelper.shared.saveData(userInfo: userInfo, key: Constants.userDefaultsUser)
            
            appDelegate?.overrideUserInterfaceStyle = .dark
            
        }
        else
        {
           print("Off")
            
            let userInfo = UserDefaultsHelper.shared.getSavedData(key: Constants.userDefaultsUser)
            guard var userInfo = userInfo else {
                return
            }
            userInfo.isDarkmode = false
            UserDefaultsHelper.shared.saveData(userInfo: userInfo, key: Constants.userDefaultsUser)
            
            appDelegate?.overrideUserInterfaceStyle = .light

            
        }
    }
    
}
