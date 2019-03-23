//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Mark Meretzky on 3/5/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import UIKit;

protocol AddToOrderDelegate {   //p. 933
    func added(menuItem: MenuItem)
}

class MenuItemDetailViewController: UIViewController {   //p. 906
    var menuItem: MenuItem!;   //p. 923
    var delegate: AddToOrderDelegate?;   //p. 934

    @IBOutlet weak var titleLabel: UILabel!;   //p. 929
    @IBOutlet weak var imageView: UIImageView!;
    @IBOutlet weak var priceLabel: UILabel!;
    @IBOutlet weak var descriptionLabel: UILabel!;
    @IBOutlet weak var addToOrderButton: UIButton!;
    
    override func viewDidLoad() {
        super.viewDidLoad();

        // Do any additional setup after loading the view.
        addToOrderButton.layer.cornerRadius = 5.0;
        updateUI();      //p. 930
        setupDelegate(); //p. 935
    }
    
    func setupDelegate() {   //p. 935-936
        if let navController: UINavigationController = tabBarController?.viewControllers?.last as? UINavigationController,
            let orderTableViewController: OrderTableViewController = navController.viewControllers.first as? OrderTableViewController {
            delegate = orderTableViewController;
        }
    }
    
    @IBAction func addToOrderButtonTapped(_ sender: UIButton) {   //p. 930
        UIView.animate(withDuration: 0.3) {   //p. 931
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 3.0, y: 3.0);
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
        }

        //delegate?.added(menuItem: menuItem);   //p. 935
        MenuController.shared.order.menuItems.append(menuItem);  //new p. 934
    }
    
    func updateUI() {   //p. 930
        titleLabel.text = menuItem.name;
        priceLabel.text = String(format: "$%.2f", menuItem.price);
        descriptionLabel.text = menuItem.description;
        //addToOrderButton.layer.cornerRadius = 5.0;
        
        MenuController.shared.fetchImage(url: menuItem.imageURL) {(image: UIImage?) in   //pp. 949
            guard let image: UIImage = image else {
                return;
            }
            DispatchQueue.main.async {
                self.imageView.image = image;
            }
        }
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
