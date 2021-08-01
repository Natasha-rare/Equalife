//
//  ContentView.swift
//  Test
//
//  Created by Егор Тарасов on 22.07.2021.
//

import SwiftUI
import Kingfisher

struct ArticleView: View {
    
    @State var scroll : CGFloat = 0.0
    
    let article : Article
    let screenWidth = UIScreen.screenWidth
    let screenHeight = UIScreen.screenHeight
    
    var alreadyChanged = false
    
    var body: some View {
            ScrollView(.vertical, showsIndicators: false, content: {
                ZStack{
                    VStack{
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 60) {
                                    if article.imagesURL.count == 0 {
                                        Image("imagePlaceholder")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.35)
                                    } else {
                                        ForEach((0..<article.imagesURL.count), id: \.self) { imageIndex in
                                            KFImage(URL(string: article.imagesURL[imageIndex]))
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.35)
                                        }
                                    }
                                }.padding(10)
                            }
                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.35, alignment: .center)
                        VStack{
                            Rectangle()
                                .fill(Color(UIColor.systemBackground))
                                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 60)
                            
                            Text(article.title)
                                .foregroundColor(Color(UIColor.label))
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding([.leading, .trailing], 10)
                                .lineLimit(nil)
                                .frame(width: UIScreen.screenWidth)
                            
                            Rectangle()
                                .fill(Color(UIColor.systemBackground))
                                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 60)
                            
                            Text(article.contents)
                                .foregroundColor(Color(UIColor.label))
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                .padding([.leading, .trailing], 10)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(width: UIScreen.screenWidth)
                            
                            Rectangle()
                                .fill(Color(UIColor.systemBackground))
                                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 10)
                                
                        }
                    }
                }
            })
            .ignoresSafeArea()
    }
}

// extension для получения размеров экрана
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
