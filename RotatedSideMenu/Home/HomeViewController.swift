//
//  HomeViewController.swift
//  RotatedSideMenu
//
//  Created by Ahmed on 11/25/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK:-Declarations
    
    //MARK:-Outlets
    
    //MARK:-ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //MARK:-Functions
    
    //MARK:-Actions
    @IBAction func openMenu(_ sender: Any) {
        NotificationCenter.default.post(name: .openMenu, object: nil)
    }
}
