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
        
        let userInfo = UserDefaultsHelper.shared.getSavedData(key: Constants.userDefaultsUser)
        if let userInfo = userInfo{
            if userInfo.isDarkmode {
                darkModetoggle.setOn(true, animated: true)
            } else {
                darkModetoggle.setOn(false, animated: true)
            }
        }
    }
    
    
    @IBAction func darkModeToggleAction(_ sender: Any) {
 
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if darkModetoggle.isOn{
                let userInfo = UserDefaultsHelper.shared.getSavedData(key: Constants.userDefaultsUser)
                guard var userInfo = userInfo else {
                    return
                }
                userInfo.isDarkmode = true
                UserDefaultsHelper.shared.saveData(userInfo: userInfo, key: Constants.userDefaultsUser)
                
                windowScene.keyWindow?.overrideUserInterfaceStyle = .dark
            } else {
                
                let userInfo = UserDefaultsHelper.shared.getSavedData(key: Constants.userDefaultsUser)
                guard var userInfo = userInfo else {
                    return
                }
                userInfo.isDarkmode = false
                UserDefaultsHelper.shared.saveData(userInfo: userInfo, key: Constants.userDefaultsUser)
                windowScene.keyWindow?.overrideUserInterfaceStyle = .light
            }
        }
        
        
    }
    
}
