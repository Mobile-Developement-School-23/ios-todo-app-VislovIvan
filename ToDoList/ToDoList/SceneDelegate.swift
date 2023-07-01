import UIKit
import CocoaLumberjackSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController(rootViewController: HomeViewController())
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        configureNavbarTitle()
        window?.makeKeyAndVisible()
        
        DDLog.add(DDOSLogger.sharedInstance)
        dynamicLogLevel = .info
        testLogger()
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
