import UIKit
import CocoaLumberjackSwift
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let todoListView = TodoListView(tasks: [
            TodoItemSwiftUI(
                text: "Купить что-то",
                importance: .normal,
                deadline: nil,
                isFinished: true
            ),
            TodoItemSwiftUI(
                text: "Купить что-то",
                importance: .normal,
                deadline: nil,
                isFinished: false
            ),
            TodoItemSwiftUI(
                text: "Купить что-то",
                importance: .unimportant,
                deadline: Date(timeIntervalSince1970: 1688241600),
                isFinished: false
            ),
            TodoItemSwiftUI(
                text: "Купить что-то",
                importance: .important,
                deadline: Date(timeIntervalSince1970: 1688500800),
                isFinished: false
            ),
            TodoItemSwiftUI(
                text: "Задание",
                importance: .important,
                deadline: nil,
                isFinished: true
            ),
            TodoItemSwiftUI(
                text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы",
                importance: .normal,
                deadline: Date(timeIntervalSince1970: 1688500800),
                isFinished: false
            ),
            TodoItemSwiftUI(
                text: "Купить сыр",
                importance: .unimportant,
                deadline: nil,
                isFinished: false
            ),
            TodoItemSwiftUI(
                text: "сделать зарядку",
                importance: .important,
                isFinished: true,
                createdAt: Date(timeIntervalSince1970: 1688241600),
                changedAt: Date(timeIntervalSince1970: 1688241600)
            )
        ])
        
        let hostingController = UIHostingController(rootView: todoListView)
        
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        window?.rootViewController = hostingController  // Set SwiftUI view as root
        window?.makeKeyAndVisible()
        
        DDLog.add(DDOSLogger.sharedInstance)
        //        dynamicLogLevel = .verbose
        testLogger()
        
        if let deviceID = UIDevice.current.identifierForVendor?.uuidString {
            print(deviceID)
        } else {
            print("No device ID available")
        }
    }
    
    func sceneDidDisconnect(_: UIScene) {}
    
    func sceneDidBecomeActive(_: UIScene) {}
    
    func sceneWillResignActive(_: UIScene) {}
    
    func sceneWillEnterForeground(_: UIScene) {}
    
    func sceneDidEnterBackground(_: UIScene) {}
}

private extension SceneDelegate {
    
    func testLogger() {
            DDLogVerbose("Verbose")
            DDLogDebug("Debug")
            DDLogInfo("Info")
            DDLogWarn("Warn")
            DDLogError("Error")
        }
    
    func configureNavbarTitle() {
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 24
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.paragraphStyle: style]
    }
}
