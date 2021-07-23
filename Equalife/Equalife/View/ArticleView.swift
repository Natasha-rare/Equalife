//
//  ContentView.swift
//  Test
//
//  Created by Егор Тарасов on 22.07.2021.
//

import SwiftUI

struct ContentView: View {
    
    let article : Article
    let screenWidth = UIScreen.screenWidth
    let screenHeight = UIScreen.screenHeight
    
    init(article : Article) {
        self.article = article
    }
    
    // Это тестовый текст для проверки отображения
    let someText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sit amet nisi diam. Ut nec quam aliquam, volutpat massa a, commodo ex. Mauris sed arcu mi. Integer vitae lorem enim. Maecenas sit amet scelerisque sapien, vitae vulputate odio. Aliquam pretium tellus et mauris consequat condimentum. Nullam non metus eu sem suscipit imperdiet. Etiam tempus nisi augue, tincidunt aliquam sapien lacinia eu. Aliquam placerat tortor et velit tempus pulvinar. Phasellus tempus elit sem, nec suscipit dui pulvinar scelerisque. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nullam vitae tempus sem. Integer elementum sagittis eleifend. Donec efficitur nunc mi, vitae blandit neque hendrerit sit amet. Nunc luctus risus et tristique volutpat. Ut iaculis tincidunt quam, non ullamcorper eros. "
    
    var body: some View {
        ZStack{
            Color(#colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1))
                .ignoresSafeArea()
            VStack(){
                Spacer()
                HStack{
                    Text(self.article.author ?? "")
                        .padding(.leading, 30)
                        .font(.title)
                    Spacer()
                    Text(self.article.date)
                        .padding(.trailing, 30)
                }
                .frame(width: screenWidth, height: screenHeight * 0.3, alignment: .bottom)
                Rectangle()
                    .fill(Color(.white))
                    .overlay(
                        VStack{
                            HStack{
                                Text(self.article.title)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding(.leading, 30)
                                    .padding(.top, 20)
                                Spacer()
                            }
                            Text(someText)
                                .padding(.leading, 30)
                                .padding(.trailing, 30)
                                .padding(.top, 15)
                        }
                        .frame(width: screenWidth, height: screenHeight * 0.7 , alignment: .top)
                    )
                    .frame(width: screenWidth, height: screenHeight * 0.7 , alignment: .leading)
            }
            .ignoresSafeArea(.all)
        }
    }
}



// extension для получения размеров экрана
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
