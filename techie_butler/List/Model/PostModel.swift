//
//  PostModel.swift
//  techie_butler
//
//  Created by Ram Kumar on 27/04/24.
//

import Foundation

struct PostModel: Decodable {
    var id: Int = 0
    var userId: Int = 0
    var title: String = ""
    var body: String = ""
}
