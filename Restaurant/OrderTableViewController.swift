//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Mark Meretzky on 3/5/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController, AddToOrderDelegate {   //pp. 905, 933
    //var menuItems: [MenuItem] = [MenuItem]();   //p. 931
    var orderMinutes: Int = 0;   //never created, but used on pp. 942, 943

    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Uncomment the following line to preserve selection between presentations
        // clearsSelectionOnViewWillAppear = false;

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        navigationItem.leftBarButtonItem = editButtonItem;   //p. 938
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count;   //p. 932
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier", for: indexPath);
        
        // Configure the cell...
        configure(cell: cell, forItemAt: indexPath);   //p. 932
        return cell;
    }
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {   //p. 932
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price);
        
        MenuController.shared.fetchImage(url: menuItem.imageURL) {(image: UIImage?) in   //p. 948
            guard let image: UIImage = image else {
                return
            }
            DispatchQueue.main.async {
                if let currentIndexPath: IndexPath = self.tableView.indexPath(for: cell),
                    currentIndexPath != indexPath {
                    return;
                }
                cell.imageView?.image = image;
            }
        }
    }
    
    // Override to support conditional editing of the table view.

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true;   //p. 937
    }

    // Override to support editing the table view, p. 938.

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            MenuController.shared.order.menuItems.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .fade);
            updateBadgeNumber();
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    func updateBadgeNumber() {   //pp. 936-937
        let badgeValue: String? = MenuController.shared.order.menuItems.count > 0 ? "\(MenuController.shared.order.menuItems.count)" : nil;
        navigationController?.tabBarItem.badgeValue = badgeValue;
    }

    @IBAction func submitTapped(_ sender: UIBarButtonItem) {   //pp. 941-942
        let orderTotal: Double = MenuController.shared.order.menuItems.reduce(0.00) {(result: Double, menuItem: MenuItem) -> Double in
            return result + menuItem.price;
        }

        let formattedOrder: String = String(format: "$%.2f", orderTotal);
        let message: String = "You are about to submit your order with a total of \(formattedOrder)";

        let alert: UIAlertController = UIAlertController(title: "Confirm Order", message: message, preferredStyle: .alert);

        alert.addAction(UIAlertAction(title: "Submit", style: .default) {_ in
            self.uploadOrder();
        });

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
        present(alert, animated: true, completion: nil);
    }
    
    func uploadOrder() {   //p. 942-943
        let menuIds: [Int] = MenuController.shared.order.menuItems.map {$0.id}
        
        MenuController.shared.submitOrder(menuIds: menuIds) {(minutes: Int?) in
            DispatchQueue.main.async {
                if let minutes: Int = minutes {
                    self.orderMinutes = minutes;
                    self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil);
                }
            }
        }
    }
    
    // MARK: - Protocol AddToOrderDelegate
    
    func added(menuItem: MenuItem) {   //p. 934
        MenuController.shared.order.menuItems.append(menuItem);
        let count: Int = MenuController.shared.order.menuItems.count;
        let indexPath: IndexPath = IndexPath(row: count-1, section: 0);
        tableView.insertRows(at: [indexPath], with: .automatic);
        updateBadgeNumber();   //p. 937
    }
    
    // MARK: - Protocol UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }

    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {   //p. 943
        if segue.identifier == "ConfirmationSegue" {
            let orderConfirmationViewController: OrderConfirmationViewController = segue.destination as! OrderConfirmationViewController;
            orderConfirmationViewController.minutes = orderMinutes;
        }
    }
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {   //p. 941
        if segue.identifier == "DismissConfirmation" {   //p. 944
            MenuController.shared.order.menuItems.removeAll();
            tableView.reloadData();
            updateBadgeNumber();
        }
    }

}
