//
//  IntermediaryModels.swift
//  Restaurant
//
//  Created by Mark Meretzky on 3/5/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import Foundation;

struct Categories: Codable {   //p. 908
    let categories: [String];
}

struct PreparationTime: Codable {
    let prepTime: Int;

    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time";
    }
}

struct Order: Codable {   //new p. 909
    var menuItems: [MenuItem];

    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems;
    }
}
