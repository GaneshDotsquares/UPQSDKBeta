//
//  Created by Nikhilesh on 20/07/15.
//  Copyright © 2015 Nikhilesh. All rights reserved.
//

import UIKit
 

 

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}




extension UIImageView {
    func setImage(with urlString: String?, placeholder:UIImage?=nil) {
        if let urlStr = urlString, let encodedString  = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedString) {
            print(url)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let data =  data{
                        self.image = UIImage(data: data)
                    }
                    
                }
            }
            
        }
    }
     
    
}
