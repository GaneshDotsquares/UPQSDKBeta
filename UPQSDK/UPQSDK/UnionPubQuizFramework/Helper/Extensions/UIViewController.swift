//
//  UIViewController.swift
//  Fodder
//
//  Created by Nikhilesh on 20/07/15.
//  Copyright © 2015 Nikhilesh. All rights reserved.

import UIKit
import MessageUI
import SafariServices
import AVFoundation

//MARK:- Here is configuration of textfiled Next Or Done

extension UIViewController{
    func textFiledNextDoneSetUP(fields:[UITextField]) -> Void {
        guard let last = fields.last else {   return  }
        for i in 0 ..< fields.count - 1 {
            fields[i].returnKeyType = .next
            fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
    
    
}


extension UIViewController {
    
    /***********************************************************************************************/
    //MARK:- Check if ViewController is onscreen and not hidden.
    /***********************************************************************************************/
    public var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return self.isViewLoaded && view.window != nil
    }
    
    func presentAlertWith( title:String = "Union JACK Pub Quiz", message:String) {
        let systemVersion : NSString  = UIDevice.current.systemVersion as NSString
        if systemVersion.floatValue >= 8.0
        {
            let alert=UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let ok=UIAlertAction(title: AlertMessage.Ok.rawValue, style: .cancel, handler: nil)
            alert.addAction(ok)
            
            self.topMostController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentAlertWith(message:String,oktitle:String,okaction:@escaping (()->Void)) {
        let systemVersion : NSString  = UIDevice.current.systemVersion as NSString
        if systemVersion.floatValue >= 8.0 {
            let alert=UIAlertController(title: "Union JACK Pub Quiz", message: message, preferredStyle: .alert)
            
            let ok=UIAlertAction(title: oktitle, style: .default) { (action) in
                okaction()
            }
            
            alert.addAction(ok)
            
            self.topMostController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentAlertWith(message:String,oktitle:String,okaction:@escaping (()->Void),notitle:String,noaction:(()->Void)?) {
        let systemVersion : NSString  = UIDevice.current.systemVersion as NSString
        if systemVersion.floatValue >= 8.0 {
            let alert=UIAlertController(title: "Union JACK Pub Quiz", message: message, preferredStyle: .alert)
            
            let ok=UIAlertAction(title: oktitle, style: .default) { (action) in
                okaction()
            }
            
            let no=UIAlertAction(title: notitle, style: .default) { (action) in
                noaction?()
            }
            alert.addAction(ok)
            alert.addAction(no)
            
            self.topMostController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    func topMostController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topMostController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topMostController(base: top)
            } else if let selected = tab.selectedViewController {
                return topMostController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topMostController(base: presented)
        }
        
        return base
    }
 
    func addImageInNavigationItem( )  {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 8, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let image = #imageLiteral(resourceName: "logoHeader")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    func setBlackColorOFnavigation( ) {
         self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1098039216, green: 0.1058823529, blue: 0.1098039216, alpha: 1)
    }
    
    
    func setPurpalColorOfnavigation( ) {
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4931362271, green: 0.1012917235, blue: 0.4242249727, alpha: 1)
    }
    
    
    
    //  MARK:- Helper method to display an alert on any UIViewController subclass. Uses UIAlertController to show an alert
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message/body of the alert
    ///   - buttonTitles: (Optional)list of button titles for the alert. Default button i.e "OK" will be shown if this paramter is nil
    ///   - highlightedButtonIndex: (Optional) index of the button from buttonTitles that should be highlighted. If this parameter is nil no button will be highlighted
    ///   - completion: (Optional) completion block to be invoked when any one of the buttons is tapped. It passes the index of the tapped button as an argument
    /// - Returns: UIAlertController object (discardable).
    @discardableResult public func showAlertWithHandler(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append(AlertMessage.Ok.rawValue)
        }
        
        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                if #available(iOS 9.0, *) {
                    alertController.preferredAction = action
                }
            }
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }
    
	
    func openSettingApp() {
		guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    NSLog("Settings opened: \(success)") // NSLogs true
                })
            } else {
                // Fallback on earlier versions
                let success = UIApplication.shared.openURL(settingsUrl)
                NSLog("Open \(settingsUrl): \(success)")
            }
        }
        
    }
    
    func openAppsStoreInBrowser(_ url : String) {
         if #available(iOS 10.0, *) {
            UIApplication.shared.open(url.makeURL()!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url.makeURL()!)
        }
        
    }
}
extension UIViewController
{
	
	func presentAlertWith(message:String,oktitle:String,okaction:@escaping (()->Void),notitle:String,noaction:@escaping (()->Void))
	{
		let systemVersion : NSString  = UIDevice.current.systemVersion as NSString
		if systemVersion.floatValue >= 8.0
		{
			let alert=UIAlertController(title: nil, message: message, preferredStyle: .alert)
			
			let ok=UIAlertAction(title: oktitle, style: .default) { (action) in
				okaction()
			}
			
			let no=UIAlertAction(title: notitle, style: .destructive) { (action) in
				noaction()
			}
			alert.addAction(no)
			alert.addAction(ok)
			
			
			self.topMostController()?.present(alert, animated: true, completion: nil)
		}
	}
	func presentAlertWithTextField(message:String,oktitle:String,okaction:@escaping ((_ input:String)->Void),notitle:String,noaction:@escaping (()->Void))
	{
		let systemVersion : NSString  = UIDevice.current.systemVersion as NSString
		if systemVersion.floatValue >= 8.0
		{
			let alert=UIAlertController(title: nil, message: message, preferredStyle: .alert)
			
			alert.addTextField(configurationHandler: { (txtField) in
				txtField.placeholder = message
			})
			
			let ok=UIAlertAction(title: oktitle, style: .default) { (action) in
				
				okaction(alert.textFields![0].text!)
			}
			
			let no=UIAlertAction(title: notitle, style: .default) { (action) in
				noaction()
			}
			alert.addAction(no)
			alert.addAction(ok)
			
			
			self.topMostController()?.present(alert, animated: true, completion: nil)
		}
	}
	func presentAlertWithTextField(message:String,tfText:String,oktitle:String,okaction:@escaping ((_ input:String)->Void),notitle:String,noaction:@escaping (()->Void))
	{
		let systemVersion : NSString  = UIDevice.current.systemVersion as NSString
		if systemVersion.floatValue >= 8.0
		{
			let alert=UIAlertController(title: nil, message: message, preferredStyle: .alert)
			
			alert.addTextField(configurationHandler: { (txtField) in
				txtField.placeholder = tfText
 			})
			
			let ok=UIAlertAction(title: oktitle, style: .destructive) { (action) in
				
				okaction(alert.textFields![0].text!)
			}
			
			let no=UIAlertAction(title: notitle, style: .cancel) { (action) in
				noaction()
			}
			alert.addAction(no)
			alert.addAction(ok)
			
			
			self.topMostController()?.present(alert, animated: true, completion: nil)
		}
	}
	func presentAlertWithActionSheet(message:String,firstActionTitle:String,firstAction:@escaping (()->Void),secondActionTitle:String,secondAction:@escaping (()->Void),cancelTitle:String,cancelAction:@escaping (()->Void))
	{
		let systemVersion : NSString  = UIDevice.current.systemVersion as NSString
		if systemVersion.floatValue >= 8.0
		{
			let alert=UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
			
			let ok=UIAlertAction(title: firstActionTitle, style: .default) { (action) in
				firstAction()
			}
			
			let no=UIAlertAction(title: secondActionTitle, style: .default) { (action) in
				secondAction()
			}
			
			let cancel=UIAlertAction(title: cancelTitle, style: .destructive) { (action) in
				cancelAction()
			}
			
			alert.addAction(ok)
			alert.addAction(no)
			alert.addAction(cancel)
			
			self.topMostController()?.present(alert, animated: true, completion: nil)
		}
	}
	func presentAlertWithActionSheet(message:String,firstActionTitle:String,firstAction:@escaping (()->Void),secondActionTitle:String,secondAction:@escaping (()->Void),thirdActionTitle:String,thirdAction:@escaping (()->Void),cancelTitle:String,cancelAction:@escaping (()->Void))
	{
		let systemVersion : NSString  = UIDevice.current.systemVersion as NSString
		if systemVersion.floatValue >= 8.0
		{
			let alert=UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
			
			let ok=UIAlertAction(title: firstActionTitle, style: .default) { (action) in
				firstAction()
			}
			
			let no=UIAlertAction(title: secondActionTitle, style: .default) { (action) in
				secondAction()
			}
			let third=UIAlertAction(title: thirdActionTitle, style: .default) { (action) in
				thirdAction()
			}
			let cancel=UIAlertAction(title: cancelTitle, style: .destructive) { (action) in
				cancelAction()
			}
			
			alert.addAction(ok)
			alert.addAction(no)
			alert.addAction(third)
			alert.addAction(cancel)
			
			self.topMostController()?.present(alert, animated: true, completion: nil)
		}
	}
}



public extension UIViewController {
	
    func setTransparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage =  UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func removeLeftNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        //self.slideMenuController()?.removeLeftGestures()
    }
    

    
    private func mapButton() -> UIBarButtonItem {
        
        let mapButton = UIButton(type: .custom)
        mapButton.frame = CGRect(x: 0, y: 0, width: 22, height: 17)
        mapButton.tintColor = UIColor.white
        //mapButton.setImage(AssetsImages.kMap, for: .normal)
        mapButton.addTarget(self, action: #selector(self.didTapMapItem(_:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: mapButton)
    }
	
    
    func viewSpace() -> UIBarButtonItem {
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: 19))
        return UIBarButtonItem(customView: leftView)
    }
    
    func fixedSpace(width: CGFloat? = 18) -> UIBarButtonItem {
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = width! //18.0 // Set 26px of fixed space between the two UIBarButtonItems
        
        return fixedSpace
    }
    private func fixedSpaceButton() -> UIBarButtonItem {
        
        /// set the second navigation More button's
        let moreButton = UIButton(type: .custom)
        moreButton.frame = CGRect(x: 0, y: 0, width: 50, height: 52)
        return UIBarButtonItem(customView: moreButton)
    }
    
    // MARK: Actions
    @objc func didTapDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapBackToRoot(_ sender: UIButton) {
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    //Add Delegate and funtion as registerListionerForMapButton() - add delegate as mapTapDelegate = self
    @objc func didTapMapItem(_ sender: UIButton) {
        
    }
    
     //Add Delegate and funtion as registerListionerForCartButton() - add delegate as cartTapDelegate = self
    @objc func didTapCart(_ sender: UIButton) {
        
    }
    
    func setTopNavigationBarTransparency() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage =  UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    

    func navigateController(vc:UIViewController){
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setAttributedNavigationTitle(string: NSAttributedString) {
        let titleLabel = UILabel()//frame: CGRect(x: 0, y: 0, width: 200, height: 40)
        titleLabel.frame = self.navigationController!.navigationBar.frame
        titleLabel.textAlignment = .center
        
        titleLabel.attributedText = string
        //titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    
	
}




// MARK: Get Previous ViewController

extension UIViewController {
    
    func getPreviousViewController() -> UIViewController? {
        guard let _ = self.navigationController else {
            return nil
        }
        guard let viewControllers = self.navigationController?.viewControllers else {
            return nil
        }
        guard viewControllers.count >= 2 else {
            return nil
        }
        return viewControllers[viewControllers.count - 2]
    }
}


extension UIViewController {
    
    func whatsup(share message:String, completionHandler:((_ finish:Bool)->Void)? = nil) {
        
        let urlWhats = "whatsapp://send?text=\(message)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            
            guard let url =  urlString.makeURL() else  {
                if completionHandler != nil {
                    completionHandler!(false)
                }
                return
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, completionHandler: { (completed) in
                    if completionHandler != nil {
                        completionHandler!(completed)
                    }else {
						self.presentAlertWith(message: "Please install watsapp")
                    }
                })
            } else if UIApplication.shared.openURL(url) {
                completionHandler!(true)
            }else {
                
                completionHandler!(false)
            }
        }
    }
    
    func getRequiredAttributesText(redText : String, fullText : String) -> NSMutableAttributedString  {
        
        let strNumber: NSString = fullText as NSString // you must set your
        let range = (strNumber).range(of: redText)
        let attribute = NSMutableAttributedString.init(string: strNumber as String)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        
        return attribute
    }
	func attributeStringInWhiteColor(title:String) -> NSAttributedString {
			let myAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.underlineColor : UIColor.white , NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font : UIFont.init(name: "OpenSans-Bold", size: 14) as Any] as [NSAttributedString.Key : Any]
			return NSAttributedString(string:title , attributes: myAttribute)
	 }
    
}

extension UIViewController {
    
    func removeChild() {
        self.children.forEach {
            $0.didMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
} 
 
extension UIViewController
{
    
    func showPermissionAlert(message:String)
    {
        let systemVersion : NSString  = UIDevice.current.systemVersion as NSString
        if systemVersion.floatValue >= 8.0
        {
            let alert=UIAlertController(title: "Oops", message:message, preferredStyle: .alert)
            
            let yes=UIAlertAction(title: "Yes", style: .default) { (action) in
                self.openSettingApp()
            }
            
            let no=UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            alert.addAction(no)
            alert.addAction(yes)
            
            
            DispatchQueue.main.async {
                UnionPubQuiz.rootController?.topMostController()?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
