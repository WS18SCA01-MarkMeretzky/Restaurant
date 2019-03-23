//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by Mark Meretzky on 3/5/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {   //p. 905
    //let menuController = MenuController();   //p. 920, deleted on p. 924
    var menuItems: [MenuItem] = [MenuItem]();
    var category: String!;   //p. 919

    override func viewDidLoad() {
        super.viewDidLoad();
        
        title = category.capitalized;   //p. 921

        MenuController.shared.fetchMenuItems(categoryName: category) {(menuItems: [MenuItem]?) in //p. 924
            if let menuItems = menuItems {
                self.updateUI(with: menuItems)
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // clearsSelectionOnViewWillAppear = false;

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // navigationItem.rightBarButtonItem = editButtonItem;
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count;   //pp. 921-922
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)

        // Configure the cell...
        configure(cell: cell, forItemAt: indexPath);   //p. 922
        return cell;
    }
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {   //p. 922
        let menuItem: MenuItem = menuItems[indexPath.row];
        cell.textLabel?.text = menuItem.name;
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price);

        MenuController.shared.fetchImage(url: menuItem.imageURL) {(image: UIImage?) in   //pp. 947-948
            guard let image: UIImage = image else {
                return;
            }
            DispatchQueue.main.async {
                if let currentIndexPath: IndexPath = self.tableView.indexPath(for: cell),
                    currentIndexPath != indexPath {
                    return;
                }
                cell.imageView?.image = image;
                cell.setNeedsLayout();   //new p. 949
            }
        }
    }
    
    func updateUI(with menuItems: [MenuItem]) {   //p. 921
        DispatchQueue.main.async {
            self.menuItems = menuItems;
            self.tableView.reloadData();
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true;
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    
    // MARK: - Protocol UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {   //p. 923
        if segue.identifier == "MenuDetailSegue" {
            // Get the new view controller using segue.destination.
            let menuItemDetailViewController: MenuItemDetailViewController = segue.destination as! MenuItemDetailViewController;
            // Pass the selected object to the new view controller.
            let index: Int = tableView.indexPathForSelectedRow!.row;
            menuItemDetailViewController.menuItem = menuItems[index];
        }
    }

}
