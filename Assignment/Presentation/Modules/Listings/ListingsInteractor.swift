//
//  ListingsInteractor.swift
//  Assignment
//
//  Created by M.Shariq Hasnain on 31/05/2024.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

protocol PresenterToInteractorListingsProtocol: AnyObject {
    var presenter:InteractorToPresenterListingsProtocol? {get set}
    func callApi(city: String)
}

class ListingsInteractor: PresenterToInteractorListingsProtocol{
    
    var presenter: InteractorToPresenterListingsProtocol?
    
    
    func callApi(city: String) {
        NetworkManager.sharedInstance.callAPi(urlString: "\(listingsURL)?q=\(city)&appid=45f9b167b9cfa7b40d118ee2b43587e6", methodType: .get) { json, error  in
            if error == nil {
                let model = List<ListingsModel>()
                for jsonData in json?["list"].arrayValue ?? [] {
                    let weather = ListingsModel(data: jsonData.rawValue as! [String : Any], city: json?["city"]["name"].stringValue ?? "")
                    model.append(weather)
                    RealmHelper.updateObject(object: weather)
                }
                self.presenter?.listingsApiSuccess(data: model)
            } else {
                self.presenter?.listingsApiError(errMsg: error?.localizedDescription ?? "")
            }
        }
        
    }
    
    
}

