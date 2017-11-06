//
//  InformationUser.swift
//  Daily
//
//  Created by Vicente Cantu Garcia on 24/10/17.
//  Copyright © 2017 Vicente Cantu Garcia. All rights reserved.
//

import Foundation

class UserInformation{
    static var instance = UserInformation()
    private var user: String?
    private init(){
    }
    func registerUser(user: String){
        self.user = user
    }
    func userRegistered() -> String{
        return user!
    }
}
