//
//  MenuController.swift
//  Restaurant
//
//  Created by Mark Meretzky on 3/5/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import UIKit;

class MenuController {   //p. 909
    static let shared: MenuController = MenuController();   //p. 924
    let baseURL: URL = URL(string: "http://localhost:8090/")!;

    var order: Order = Order() {   //new p. 933
        didSet {   //new p. 935
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil);
        }
    }
    
    static let orderUpdatedNotification: Notification.Name = Notification.Name("MenuController.orderUpdated"); //new p. 935
    
    func fetchCategories(completion: @escaping ([String]?) -> Void) {   //p. 909
        let categoryURL: URL = baseURL.appendingPathComponent("categories");   //p. 910
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: categoryURL) {(data: Data?, response: URLResponse?, error: Error?) in //p. 912
            if let data: Data = data,   //p. 914
                let jsonDictionary: [String: Any]? = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let categories: [String] = jsonDictionary?["categories"] as? [String] {
                completion(categories);
            } else {
                completion(nil);
            }
        }

        task.resume();
    }
    
    func fetchMenuItems(categoryName: String, completion: @escaping ([MenuItem]?) -> Void) {   //p. 910
        let initialMenuURL: URL = baseURL.appendingPathComponent("menu");
        guard var components: URLComponents = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true) else {
            fatalError("could not get URLComponents for initialMenuURL");
        }
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)];
        guard let menuURL: URL = components.url else {
            fatalError("could not create menuURL");
        }
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: menuURL) {(data: Data?, response: URLResponse?, error: Error?) in //p. 912
            let jsonDecoder = JSONDecoder();   //p. 915
            if let data: Data = data,
                let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                completion(menuItems.items);
            } else {
                completion(nil);
            }
        }

        task.resume();
    }
    
    func submitOrder(menuIds: [Int], completion: @escaping (Int?) -> Void) {   //p. 910
        let orderURL: URL = baseURL.appendingPathComponent("order");   //p. 911
        var request: URLRequest = URLRequest(url: orderURL);   //p. 912
        request.httpMethod = "POST";
        request.setValue("application/json", forHTTPHeaderField: "Content-Type");
        
        let data: [String: [Int]] = ["menuIds": menuIds];   //p. 913
        let jsonEncoder: JSONEncoder = JSONEncoder();
        let jsonData: Data? = try? jsonEncoder.encode(data);
        request.httpBody = jsonData;

        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in //p. 914
            let jsonDecoder: JSONDecoder = JSONDecoder();   //p. 915
            if let data: Data = data,
            let preparationTime: PreparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) { //p. 916
                completion(preparationTime.prepTime);
            } else {
                completion(nil);
            }
        }
        
        task.resume();
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {   //pp. 946-947
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
            if let data: Data = data,
                let image: UIImage = UIImage(data: data) {
                completion(image);
            } else {
                completion(nil);
            }
        }
        task.resume()
    }
    
}
