//
//  ViewController.swift
//  RotatedSideMenu
//
//  Created by Ahmed on 11/25/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    //MARK:-Declarations
    var menuStatus = MenuStatus.closed
    var tapGestureRecognizer: UITapGestureRecognizer?
    var panGestureRecognizer: UIPanGestureRecognizer?
    //MARK:-Outlets
    @IBOutlet weak var tableView: TableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var trailingContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingContainerConstraint: NSLayoutConstraint!
    
    //MARK:-ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    //MARK:-Functions
    private func configuration(){
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: SideMenuCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SideMenuCell.identifier)
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(openMenuNotification(_:)), name: .openMenu, object: nil)
    }
    
    private func toggleMenu(){
        switch menuStatus{
        case .opened:
            closeMenu()
            removeDismissGesture()
            menuStatus = .closed
        case .closed:
            openMenu()
            addGestureToDismiss()
            menuStatus = .opened
        }
    }
    private func openMenu(){
        let value = view.frame.width - 150
        leadingContainerConstraint.constant = value
        trailingContainerConstraint.constant = -value
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.containerView.layer.cornerRadius = 40
            self.containerView.layer.masksToBounds = true
            self.rotate(angle: -10)
        }
    }
    private func closeMenu(){
        leadingContainerConstraint.constant = 0
        trailingContainerConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.containerView.layer.cornerRadius = 0
            self.setContainerToOriginalPosition()
        }) { (_) in
        }
    }
    private func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = containerView.transform.rotated(by: radians);
        containerView.transform = rotation
    }
    private func setContainerToOriginalPosition() {
        containerView.transform = .identity
    }
    
    @objc private func openMenuNotification(_ notification: NSNotification){
        toggleMenu()
    }
    //MARK:-Actions
    
}
//MARK:-Enum
enum MenuStatus {
    case opened
    case closed
}
//MARK:-Extensions
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as! SideMenuCell
        return cell
    }
}
extension SideMenuViewController: UIGestureRecognizerDelegate{
    
    func addGestureToDismiss(){
        self.containerView.isUserInteractionEnabled = false
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        tapGestureRecognizer?.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer!)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dismissMenu))
        panGestureRecognizer?.delegate = self
        view.addGestureRecognizer(panGestureRecognizer!)
    }
    
    func removeDismissGesture(){
        self.containerView.isUserInteractionEnabled = true
        if let gesture = tapGestureRecognizer{
            view.removeGestureRecognizer(gesture)
            tapGestureRecognizer = nil
        }
        
        if let gesture = panGestureRecognizer{
            view.removeGestureRecognizer(gesture)
            panGestureRecognizer = nil
        }
    }
    
    @objc private func dismissMenu(){
        toggleMenu()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view, !view.isDescendant(of: tableView) else { return false}
        return true
    }
}
