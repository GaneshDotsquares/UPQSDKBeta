//
//  CGFloat.swift
 
//
//  Created by Krishan Kumar on 16/10/18.
//  Copyright © 2018 Krishan Kumar. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
	static func random() -> CGFloat {
		return CGFloat(arc4random()) / CGFloat(UInt32.max)
	}
}
