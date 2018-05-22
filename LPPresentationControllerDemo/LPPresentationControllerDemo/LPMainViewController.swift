//
//  LPMainViewController.swift
//  LPPresentationControllerDemo
//
//  Created by pengli on 2018/5/22.
//  Copyright © 2018年 pengli. All rights reserved.
//

import UIKit
import LPPresentationController

class LPMainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var loc = LPPresentationLocation.bottom
        
        switch indexPath.row {
        case 0: loc = .top
        case 1: loc = .bottom
        case 2: loc = .left
        case 3: loc = .right
        case 4: loc = .center(nil)
        default:
            break
        }
        
        let manager = LPPresentationManager(loc)
        let subVc = LPSubViewController(nibName: "LPSubViewController",
                                        bundle: nil)
        lp_present(subVc, manager: manager, completion: nil)
    }
}

