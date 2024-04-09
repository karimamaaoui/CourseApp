//
//  ContentView.swift
//  CourseApp
//
//  Created by karimamaaoui on 4/9/24.
//  Copyright © 2024 karimamaaoui. All rights reserved.
//

import SwiftUI

//view for display images from a url
struct URLImage: View {
    //state variable to hold image data
    @State var data: Data?
    // url string to fetch the image
    let urlString : String
    
    var body: some View {
        //check if image data is available
        if let data = data , let uiimage = UIImage(data: data) {
          //if image data is available display the image
            return AnyView( Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 130 , height: 70)
                .background(Color.gray)
            )
        }
        else {
            //if image data is not available display the video image
            return AnyView (
            Image(systemName: "video")
                .frame(width: 130 , height: 70)
                .background(Color.gray)           .aspectRatio(contentMode: .fill)
                .onAppear {
                    self.fetchData()// fetch image data when the view appears
            }
            )
        }
    }
    
    private func fetchData() {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data , _ , error in
            if let error = error {
                print("Error fetching image: \(error)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()// start the data task
    }
}


struct ContentView: View {
    //observed object to manage course data
    @ObservedObject var courseModel = CourseModel()
    
  
    var body: some View {
        NavigationView {
            List {
                //display course with its name and image
                ForEach(courseModel.courses , id: \.self) {course in HStack {
                    URLImage( urlString: course.image)
                    Text(course.name).bold()
                    }.padding(3)
                }
            }
            .navigationBarTitle("Courses") //navigation bar title
            .onAppear {
                self.courseModel.fetch() // fetch course data when the view appears
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
