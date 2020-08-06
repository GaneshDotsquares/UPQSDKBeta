 
import UIKit
import SafariServices

public extension UIApplication {
    
    class var appDetails: String {
        get {
            if let dict = Bundle.main.infoDictionary {
                if let shortVersion = dict["CFBundleShortVersionString"] as? String,
                    let mainVersion = dict["CFBundleVersion"] as? String,
                    let appName = dict["CFBundleName"] as? String {
                    return "You're using \(appName) Version: \(mainVersion) (Build \(shortVersion))."
                }
            }
            return ""
        }
    }
    class var appName: String {
        get {
            let mainBundle = Bundle.main
            let displayName = mainBundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            let name = mainBundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
            return displayName ?? name ?? "Unknown"
        }
    }
    
    class var versionString: String {
        get {
            let mainBundle = Bundle.main
            let buildVersionString = mainBundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String
            let version = mainBundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
            return buildVersionString ?? version ?? "Unknown Version"
        }
    }
    class var shortVersionString: String {
        get {
            let mainBundle = Bundle.main
            let buildVersionString = mainBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            let version = mainBundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
            return buildVersionString ?? version ?? "Unknown Version"
        }
    }
        
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
 
      
        return viewController
    }
    
    class func isFirstLaunch(_ key: String) -> Bool {
        if !UserDefaults.standard.bool(forKey: key) {
            //NSUserDefaults.standardUserDefaults().setBool(true, forKey: key)
            //NSUserDefaults.standardUserDefaults().synchronize()
            return true
        }
        return false
        
        /*
        let defaults = UserDefaults.standard
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
         */
    }

    
    class func tryURL(urls: [String]) {

        for url in urls {
            if UIApplication.shared.canOpenURL(url.makeURL()!) {
                
                if #available(iOS 9.0, *) {
                    let safariVC = SFSafariViewController(url: url.makeURL()!)
                    self.topViewController()?.present(safariVC, animated: true, completion: nil)
                } else {
                    UIApplication.shared.openURL(url.makeURL()!)
                }
 
                return
            }
        }
    }
    
}

public extension UIWindow {
    
     var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
     static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}
