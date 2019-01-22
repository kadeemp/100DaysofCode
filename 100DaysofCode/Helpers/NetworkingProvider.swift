//
//  NetworkingProvider.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/21/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

class NetworkingProvider {
    static func validateUsername(_ username:String, completion: @escaping (Int) -> ()) {
        Alamofire.request("https://github.com/\(username)").responseString { (response) in
            completion((response.response?.statusCode)!)
        }
    }

}
