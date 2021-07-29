//
//  ContentView.swift
//  Test
//
//  Created by Егор Тарасов on 22.07.2021.
//

import SwiftUI

struct ArticleView: View {
    
    let article : Article
    let screenWidth = UIScreen.screenWidth
    let screenHeight = UIScreen.screenHeight
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            ZStack{
                VStack{
                    Spacer()
                }
                VStack{
                    Image(systemName: "LogoFlat")
                        .resizable()
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.3, alignment: .center)
                        .overlay(
                            VStack{
                                Spacer()
                                HStack{
                                    Text(article.author ??  " " )
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.leading, 20)
                                        
                                    Spacer()
                                    Text(article.date)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.trailing, 20)
                                }
                            }
                        )
                    Divider()
                    HStack{
                        Text(article.title)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    Text(article.contents)
                        .multilineTextAlignment(.leading)
                        .padding([.leading, .trailing] , 20)
                }
            }
        })
    }
}


// extension для получения размеров экрана
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
