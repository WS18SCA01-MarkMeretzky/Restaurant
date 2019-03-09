//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Mark Meretzky on 3/7/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import UIKit;

class OrderConfirmationViewController: UIViewController {   //p. 939

    var minutes: Int!;   //p. 940
    @IBOutlet weak var timeRemainingLabel: UILabel!;   //p. 940
    
    override func viewDidLoad() {
        super.viewDidLoad();

        // Do any additional setup after loading the view.
        timeRemainingLabel.text = "Thank you for your order! Your wait time is approximately \(minutes!) minutes."; //p. 943
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
