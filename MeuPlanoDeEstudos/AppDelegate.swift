//
//  AppDelegate.swift
//  MeuPlanoDeEstudos
//
//  Created by Valmir Junior on 01/10/20.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        center.delegate = self
        center.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.center.requestAuthorization(options: [.alert, .sound, .badge]) { (isAuthorized, error) in
                    if error == nil {
                        print(isAuthorized)
                    }
                }
            default:
                break
            }
        }
        
        let confirmAction = UNNotificationAction(
            identifier: Constants.Notification.confirm,
            title: "Já estudei 👍🏽",
            options: [.foreground]
        )
        
        let cancelAction = UNNotificationAction(
            identifier: Constants.Notification.cancel,
            title: "Cancelar",
            options: []
        )
        
        let category = UNNotificationCategory(
            identifier: "Lembrete",
            actions: [confirmAction, cancelAction],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "",
            options: [.customDismissAction]
        )
        
        center.setNotificationCategories([category])
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let id = response.notification.request.identifier
//        StudyManager.shared.setPlanDone(id: id)
        
        switch response.actionIdentifier {
        case Constants.Notification.confirm:
            print("Action confirm criada")
            NotificationCenter.default.post(name: NSNotification.Name("Confirmed"), object: nil, userInfo: ["id": id])
        case Constants.Notification.cancel:
            print("Action cancel criada")
        case UNNotificationDefaultActionIdentifier:
            print("Usuário tocou na notificação")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "orange")
            window?.rootViewController?.show(vc, sender: nil)
        case UNNotificationDismissActionIdentifier:
            print("Usuário deu dismiss a notificação")
        default:
            break
        }
        
        completionHandler()
    }
}
