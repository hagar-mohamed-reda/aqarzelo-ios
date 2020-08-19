//
//  DropDownAllTableViewVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/19/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit


class DropDownAllTableViewVC: UITableViewController {
    
    var cityDataSource = [String]()
    var areaDataSource = [String]()
    var categoryDataSource = [String]()
    var typeDataSource = [String]()
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
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        tableView.showsVerticalScrollIndicator=false
    }
}

extension DropDownAllTableViewVC{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types == "city"  ?  cityDataSource.count : types == "area" ? areaDataSource.count : types == "cat" ? categoryDataSource.count : typeDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellClass
        let ss =  types == "city"  ?  cityDataSource[indexPath.row] : types == "area" ? areaDataSource[indexPath.row] : types == "cat" ? categoryDataSource[indexPath.row] : typeDataSource[indexPath.row]
        
        cell.textLabel?.text = ss
        let xx:String
        if types == "city" {
             xx = userDefaults.string(forKey: UserDefaultsConstants.cityCahcedValue) ?? ""
              }else if types == "area" {
            xx = userDefaults.string(forKey: UserDefaultsConstants.areaCahcedValue) ?? ""
              }else if types == "cat" {
            xx = userDefaults.string(forKey: UserDefaultsConstants.categoryCahcedValue) ?? ""
              }else if types == "type" {
            xx = userDefaults.string(forKey: UserDefaultsConstants.typeCahcedValue) ?? ""
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
        }else if types == "cat" {
            checkCched(indexPath, categoryDataSource,key: UserDefaultsConstants.categoryCahcedValue)
        }else if types == "type" {
            checkCched(indexPath, typeDataSource,key: UserDefaultsConstants.typeCahcedValue)
        }
    }
}


class CellClass: UITableViewCell {
}
