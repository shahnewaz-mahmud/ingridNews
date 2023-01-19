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
    
    @IBOutlet weak var thmeAbtn: UIButton!
    @IBOutlet weak var themeBBtn: UIButton!
    @IBOutlet weak var themeCBtn: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarBackground.layer.cornerRadius = 25
        headerBackground.clipsToBounds = true
        headerBackground.layer.cornerRadius = 40
        headerBackground.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        headerBackground.dropShadow()
        
        
        //Update the theme CheckBox according to saved UserDefaults when the page opens
        let userInfo = UserDefaultsHelper.shared.getSavedData(key: Constants.userDefaultsUser)
        if let userInfo = userInfo{
            if userInfo.isDarkmode {
                darkModetoggle.setOn(true, animated: true)
            } else {
                darkModetoggle.setOn(false, animated: true)
            }
            if userInfo.theme == "A" {
                thmeAbtn.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
                
            } else if (userInfo.theme == "B") {
                themeBBtn.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
            } else {
                themeCBtn.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Refresh the news Collection view when this view is disappeard according to theme selection
        NotificationCenter.default.post(name: Constants.refreshNewsListNotificationName, object: nil)
    }


    @IBAction func darkModeToggleAction(_ sender: Any) {
        
        //Initiate the dark Scene and save to userDefaults accoring to toggle button
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
    
    
    //MARK: Theme checkboxes actions
    //It selects one theme and uncheck the other checkbox and save the theme name in userdefaults
    
    @IBAction func themeABtnAction(_ sender: Any) {
        thmeAbtn.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
        themeBBtn.setImage(UIImage(systemName: "rectangle"), for: .normal)
        themeCBtn.setImage(UIImage(systemName: "rectangle"), for: .normal)
        
        let userInfo = UserDefaultsHelper.shared.getSavedData(key: Constants.userDefaultsUser)
        guard var userInfo = userInfo else {
            return
        }
        userInfo.theme = "A"
        UserDefaultsHelper.shared.saveData(userInfo: userInfo, key: Constants.userDefaultsUser)
        NotificationCenter.default.post(name: Constants.refreshNewsListNotificationName, object: nil)
    }
    
    @IBAction func themeBBtnAction(_ sender: Any) {
       
        themeBBtn.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
        thmeAbtn.setImage(UIImage(systemName: "rectangle"), for: .normal)
        themeCBtn.setImage(UIImage(systemName: "rectangle"), for: .normal)
        
        let userInfo = UserDefaultsHelper.shared.getSavedData(key: Constants.userDefaultsUser)
        guard var userInfo = userInfo else {
            return
        }
        userInfo.theme = "B"
        UserDefaultsHelper.shared.saveData(userInfo: userInfo, key: Constants.userDefaultsUser)
        NotificationCenter.default.post(name: Constants.refreshNewsListNotificationName, object: nil)
       
    }
    
    
    @IBAction func themeCBtnAction(_ sender: Any) {
      
        themeCBtn.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
        thmeAbtn.setImage(UIImage(systemName: "rectangle"), for: .normal)
        themeBBtn.setImage(UIImage(systemName: "rectangle"), for: .normal)
        
        let userInfo = UserDefaultsHelper.shared.getSavedData(key: Constants.userDefaultsUser)
        guard var userInfo = userInfo else {
            return
        }
        userInfo.theme = "C"
        UserDefaultsHelper.shared.saveData(userInfo: userInfo, key: Constants.userDefaultsUser)
        NotificationCenter.default.post(name: Constants.refreshNewsListNotificationName, object: nil)
     
    }
    
}
