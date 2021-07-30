//
//  ContentView.swift
//  Test
//
//  Created by Егор Тарасов on 22.07.2021.
//

import SwiftUI
import Kingfisher

struct ArticleView: View {
    
    let article : Article
    let screenWidth = UIScreen.screenWidth
    let screenHeight = UIScreen.screenHeight
    
    
    var body: some View {
            ScrollView(.vertical, showsIndicators: false, content: {
                GeometryReader{ geometry in
                ZStack{
                    VStack{
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach((0...article.imagesURL.count - 1), id: \.self) { imageIndex in
                                        KFImage(URL(string: article.imagesURL[imageIndex])!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.3)
                                    }
                                }
                            }
                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.3, alignment: .center)
                            .overlay(
                                ZStack(){
                                    LinearGradient(gradient:
                                                        Gradient(
                                                            colors: [
                                                                    Color(UIColor.black.withAlphaComponent(1)),
                                                                    Color(UIColor.black.withAlphaComponent(0.2)),
                                                                    Color(UIColor.white.withAlphaComponent(0.0))
                                                            ]),
                                                       startPoint: .bottom,
                                                       endPoint: .center
                                        )
                                    VStack{
                                        Spacer()
                                        HStack{
                                            Text(article.author ??  " " )
                                                .foregroundColor(.white)
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .padding([.leading, .trailing], 5)
                                                
                                                
                                            Spacer()
                                            Text("Top View \(geometry.frame(in: .global).midY)")
                                                .foregroundColor(.white)
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .padding([.leading, .trailing], 5)
                                                
                                        }
                                    }
                                }
                                
                            )
                        VStack{
                            HStack{
                                Text(article.title)
                                    .foregroundColor(Color(.black))
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .padding(.leading, 20)
                                    
                                Spacer()
                            }
                            Text(article.contents)
                                .foregroundColor(Color(.black))
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                .padding([.leading, .trailing] , 20)
                        }
                    }
                }
                }
                
            })
            .ignoresSafeArea()
    }
}

struct BackButton : View{
    var body : some View{
        Button(action: {
            
        }, label: {
            Image(systemName: "arrowshape.turn.up.left.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.black)
                .frame(width: UIScreen.screenWidth * 0.08, height: UIScreen.screenHeight * 0.08)
        })
    }
    
}

struct CustomNavigationView : View{
    
    var body: some View{
        HStack{
            Text("Назад")
            Spacer()
        }
    }
}


// extension для получения размеров экрана
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
