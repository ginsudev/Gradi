//
//  GRMediaBaseView.swift
//  
//
//  Created by Noah Little on 20/7/2022.
//

import GradiC

final class GRMediaBaseView: UIView, PLPlatter {
    var hasShadow: Bool = false
    
    var isBackgroundBlurred: Bool = false
    
    var customContentView: UIView? {
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        
        let baseController = GRBaseController()
        addSubview(baseController.view)
        //Constraints
        baseController.view.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        baseController.view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        baseController.view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        baseController.view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func contentSize(for arg1: CGSize) -> CGSize {
        return arg1
    }
    
    func sizeThatFitsContent(with arg1: CGSize) -> CGSize {
        return arg1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
