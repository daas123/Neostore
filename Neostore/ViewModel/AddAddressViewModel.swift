//
//  AddAddressViewModel.swift
//  Neostore
//
//  Created by Neosoft on 05/09/23.
//

import Foundation

struct AddressFormate:Codable{
    var address: String
    var landmark : String
    var city : String
    var state : String
    var zipCode : Int
    var country : String
}
class AddAddressViewModel {
    let userDefaults = UserDefaults.standard
    var addressData: [AddressFormate] {
            get {
                if let data = UserDefaults.standard.data(forKey: "myAddress"),
                   let addresses = try? JSONDecoder().decode([AddressFormate].self, from: data) {
                    return addresses
                }
                return []
            }
            set {
                if let encodedData = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.set(encodedData, forKey: "myAddress")
                }
            }
        }
    func addAddressData(address:String,landmark:String,city:String,state:String,zipCode:Int,country:String,complition: @escaping (Bool)->Void){
        var newAddress = AddressFormate(
                    address: address,
                    landmark: landmark,
                    city: city,
                    state: state,
                    zipCode: zipCode,
                    country: country
                )
        var addresses = addressData
        addresses.append(newAddress)
                
                // Save the updated array back to UserDefaults
        self.addressData = addresses
                
        complition(true)
    }
    
    func OrderCart(address:String ,complition: @escaping (Bool)->Void){
        OrderService().orderCart(address: address){
            responce in
            switch responce{
            case .success(_):
                complition(true)
            case .failure(_):
                complition(false)
            }
        }
    }
}
