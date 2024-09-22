//
//  ListingsView.swift
//  Assignment
//
//  Created by M.Shariq Hasnain on 31/05/2024.
//

import UIKit
import RealmSwift

protocol PresenterToViewListingsProtocol: AnyObject {
    func listingsApiSuccess(data: List<ListingsModel>)
    func listingsApiError(errMsg: String)
}

class ListingsView: UIViewController {

    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var table: UITableView!
    var data = [ListingsModel]()
    var presenter: ViewToPresenterListingsProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    func setUp() {
        self.navigationController?.navigationBar.show()
        navigationItem.title = "Listings"
        table.register(UINib(nibName: "ListingCell", bundle: nil), forCellReuseIdentifier: "ListingCell")
        self.tfSearch.delegate = self
    }
    
    func getWeatherData(city: String) {
        presenter?.getWeatherData(city: city)
    }

}

//MARK: TABLE VIEW
extension ListingsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: "ListingCell") as? ListingCell else {return UITableViewCell()}
        cell.setupData(data: self.data[indexPath.row])
        return cell
    }
}

//MARK: Conform to presenter protocol
extension ListingsView: PresenterToViewListingsProtocol{
    
    func listingsApiSuccess(data: List<ListingsModel>) {
        self.data = data.limit(5)
        table.reloadData()
    }
    
    func listingsApiError(errMsg: String) {
        let alert = UIAlertController(title: "Alert", message: errMsg.debugDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: SearchBar Delegate
extension ListingsView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            let localData = RealmHelper.getObjects(with: ListingsModel.self)
            let obj = localData.filter({$0.city == textField.text!.capitalized.trimmingCharacters(in: .whitespaces)})
            if localData.count > 0 && obj.count > 0 {
                let model = List<ListingsModel>()
                for weather in localData {
                    model.append(weather)
                }
                self.data = model.limit(5)
                table.reloadData()
            } else {
                self.getWeatherData(city: city.capitalized)
            }
        }
    }
}
