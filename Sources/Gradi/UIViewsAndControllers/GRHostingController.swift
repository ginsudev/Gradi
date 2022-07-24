//
//  GRHostingController.swift
//  
//
//  Created by Noah Little on 20/7/2022.
//

import UIKit
import SwiftUI

class GRHostingController<Content>: UIHostingController<Content> where Content: View {
    override func _canShowWhileLocked() -> Bool {
        return true
    }
}
