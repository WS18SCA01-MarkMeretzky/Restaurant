//
//  CategoryTableViewController.swift
//  Restaurant
//
//  Created by Mark Meretzky on 3/5/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import UIKit;

class CategoryTableViewController: UITableViewController {   //p. 905
    //let menuController = MenuController();   //p. 917, deleted on p. 924
    var categories: [String] = [String]();

    override func viewDidLoad() {
        super.viewDidLoad();
        
        MenuController.shared.fetchCategories {(categories: [String]?) in   //pp. 917, 924
            if let categories: [String] = categories {
                self.updateUI(with: categories)
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
        return categories.count;   //p. 917
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //p. 918
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath);

        // Configure the cell...
        configure(cell: cell, forItemAt: indexPath);
        return cell;
    }
    
    func updateUI(with categories: [String]) {   //p. 917
        DispatchQueue.main.async {
            self.categories = categories;
            self.tableView.reloadData();
        }
    }
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {   //p. 918
        let categoryString: String = categories[indexPath.row];
        cell.textLabel?.text = categoryString.capitalized;
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {   //p. 919
        if segue.identifier == "MenuSegue" {
            // Get the new view controller using segue.destination.
            let menuTableViewController: MenuTableViewController = segue.destination as! MenuTableViewController;
            // Pass the selected object to the new view controller.
            let index: Int = tableView.indexPathForSelectedRow!.row;
            menuTableViewController.category = categories[index];
        }
    }

}
