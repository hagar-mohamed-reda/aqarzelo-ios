//
//  DropDownCityAndAreaTableViewVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/19/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class DropDownCityAndAreaTableViewVC: UITableViewController {
    
 var cityDataSource = [String]()
    var areaDataSource = [String]()
    var selectedData:String = ""
    var types = "city"
    
    
    var handleCheckedIndex:((String,String,Int)->())?
    //    var handleCheckedStringIndex:((String)->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
    func setupViews() {
        tableView.backgroundColor = .white
        tableView.allowsMultipleSelection = false
        tableView.register(CellCityAreaClass.self, forCellReuseIdentifier: "Cell")
        tableView.showsVerticalScrollIndicator=false
    }
}

extension DropDownCityAndAreaTableViewVC{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types == "city"  ?  cityDataSource.count : areaDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellCityAreaClass
        let ss =  types == "city"  ?  cityDataSource[indexPath.row] : areaDataSource[indexPath.row]
        
        cell.textLabel?.text = ss
        let xx:String
        if types == "city" {
             xx = userDefaults.string(forKey: UserDefaultsConstants.cityCahcedValue) ?? ""
              }else if types == "area" {
            xx = userDefaults.string(forKey: UserDefaultsConstants.areaCahcedValue) ?? ""
            
        }else {
            xx = ""
        }
        
        

        if xx == ss {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    
    override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    fileprivate func checkCched(_ indexPath: IndexPath,_ ss: [String],key:String) {
        let dd = ss[indexPath.row]
        let xx = userDefaults.string(forKey: key) ?? ""
        
        if xx==dd  {
//            userDefaults.removeObject(forKey: key)
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            userDefaults.set(dd, forKey: key)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        userDefaults.synchronize()
        handleCheckedIndex?(types,dd,indexPath.row+1)
     }
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if types == "city" {
            checkCched(indexPath, cityDataSource,key: UserDefaultsConstants.cityCahcedValue)
        }else if types == "area" {
            checkCched(indexPath, areaDataSource,key: UserDefaultsConstants.areaCahcedValue)
        }
    }
}


class CellCityAreaClass: UITableViewCell {
}

