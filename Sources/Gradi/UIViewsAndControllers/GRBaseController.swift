//
//  GRBaseController.swift
//  
//
//  Created by Noah Little on 20/7/2022.
//

import UIKit

class GRBaseController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = Settings.cornerRadius
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(child.view)
        //Constraints
        child.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        child.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        child.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        child.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        self.addChild(child)
    }
    
    override func _canShowWhileLocked() -> Bool {
        return true
    }
}
