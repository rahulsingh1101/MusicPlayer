//
//  AppDelegate.swift
//  MusicPlayer
//
//  Created by Rahul Singh on 15/05/24.
//

import UIKit
import CoreData
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow(frame:UIScreen.main.bounds)
    private var referenceController: UIViewController?
    private var googleUser: GIDGoogleUser?
    
    fileprivate func promptDrivePermission() {
        let user = self.googleUser
        let driveScope = "https://www.googleapis.com/auth/drive.readonly"
        let grantedScopes = user?.grantedScopes
        print("debug :: grantedScopes ::\(String(describing: grantedScopes))")
        if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
            // Request additional Drive scope.
            let additionalScopes = ["https://www.googleapis.com/auth/drive.readonly"]
            guard let currentUser = GIDSignIn.sharedInstance.currentUser else {
                return
            }
            self.referenceController = self.getTopController()
            if let vc = self.referenceController {
                currentUser.addScopes(additionalScopes, presenting: vc) { signInResult, error in
                    // Check if the user granted access to the scopes you requested.
                    
                    if let error {
                        print("debug :: error ::\(error)")
                    }
                }
            }
        } else {
            // Query for music
            GoogleDriveManager.shared.fetchFilesFromDrive()
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            let access_token = user?.accessToken.tokenString
            GoogleDriveManager.shared.access_token = access_token
            if error != nil || user == nil {
                // Show the app's signed-out state.
                print("debug :: error on app launch ::\(String(describing: error))")
            } else {
                // Show the app's signed-in state.
                self.googleUser = user
                addTask(self.promptDrivePermission)
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MusicPlayer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            print("debug :: handled ::\(handled)")
            return true
        }
        
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        return false
    }
    
    private func getTopController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            // topController should now be your topmost view controller
            return topController
        }
        return nil
    }
}
