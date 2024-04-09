//
//  CourseModel.swift
//  CourseApp
//
//  Created by karimamaaoui on 4/9/24.
//  Copyright © 2024 karimamaaoui. All rights reserved.
//

import Foundation
import SwiftUI
//course stucture representing a course with name and image
struct Course: Hashable, Codable {
    let name: String
    let image: String
}
//class course
class CourseModel: ObservableObject {
    //published property to hold course data
    @Published var courses: [Course] = []
    
    //fetch data from the api
    func fetch() {
        guard let url = URL(string: "https://iosacademy.io/api/v1/courses/index.php") else {
            return
        }
        // perform an api call to fetch data
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            // Convert fetched data to JSON
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                // Handle fetched courses
                DispatchQueue.main.async {
                    self?.courses = courses
                }
            } catch {
                print(error)
            }
        }
        task.resume() //resume the data task to start fetching data
    }
}
