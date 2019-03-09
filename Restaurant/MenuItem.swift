//
//  MenuItem.swift
//  Restaurant
//
//  Created by Mark Meretzky on 3/5/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import Foundation;

struct MenuItem: Codable {   //p. 907
    var id: Int;
    var name: String;
    var description: String;
    var price: Double;
    var category: String;
    var imageURL: URL;

    enum CodingKeys: String, CodingKey {
        case id;
        case name;
        case description;
        case price;
        case category;
        case imageURL = "image_url";
    }
}

struct MenuItems: Codable {   //p. 908
    let items: [MenuItem];
}
