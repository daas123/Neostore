//
//  SideMenuViewmodel.swift
//  Neostore
//
//  Created by Neosoft on 02/09/23.
//  cart   table.furniture  chair.fill  sofa.fill   bed.double

import Foundation

protocol ReloadSidemenuDetails{
    func reloadSideMenu()
}
class SideMenuViewmodel{
     static var menuDemoData = FetchAccount()
    var sideMenuTableImages = ["","table.furniture","chair.fill","sofa.fill","bed.double","person.fill","mappin.and.ellipse","note.text","arrow.uturn.left.circle"]
    func fetchAccountDetails(complition : @escaping (Bool)->Void){
        FetchAccountWEbService().getAccountdata(){
            responce in
            switch responce{
            case .success(let data):
                SideMenuViewmodel.menuDemoData = data
                complition(true)
            case .failure(let error):
                print(error.localizedDescription)
                complition(false)
            }
    
        }
    }
    func editAccountDetails(first_name: String, last_name: String, email: String, dob: String, phone_no: String,profile_pic:String,complition : @escaping (Bool)->Void){
        FetchAccountWEbService().editAccountdata(first_name: first_name, last_name: last_name, email: email, dob: dob, phone_no:phone_no, profile_pic: profile_pic){
            responce in
            switch responce{
            case .success(let data):
                SideMenuViewmodel.menuDemoData = data
                complition(true)
            case .failure(let error):
                print(error.localizedDescription)
                complition(false)
            }
    
        }
    }

}


