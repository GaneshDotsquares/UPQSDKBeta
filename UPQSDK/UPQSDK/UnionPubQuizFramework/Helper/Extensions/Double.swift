//
//  Double.swift
 
//
//  Created by Ganesh on 15/04/19.
//  Copyright © 2019 Dotsquares. All rights reserved.
//

import Foundation
extension Double {
    func toInt() -> Int? {
        guard (self <= Double(Int.max).nextDown) && (self >= Double(Int.min).nextUp) else {
            return nil
        }
        
        return Int(self)
    }
}
