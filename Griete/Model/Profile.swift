//
//  Profile.swift
//  Griete
//
//  Created by Harshavardhan K on 11/03/18.
//  Copyright © 2018 Harshavardhan K. All rights reserved.
//

import Foundation
import UIKit

class Profile: NSObject, NSCoding {
    
    var profilePicture: UIImage?
    var userName: String!
    
    init(name: String!) {
        self.userName = name
    }
    
    func encode(with aCoder: NSCoder) {
        //
    }
    
    required init?(coder aDecoder: NSCoder) {
        //
    }
}
