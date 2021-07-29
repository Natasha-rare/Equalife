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
                    Image(article.imagesURL[0])
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


struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ArticleView(article: Article(title: "Title", contents: " Lorem ipsum shit here should be I guess", imagesURL: ["TestImage"], author: "Author", date: "2020-20-20", isSaved: false))
        }
    }
}

//    ZStack{
//        Color(#colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1))
//            .ignoresSafeArea()
//        VStack(){
//            Spacer()
//            HStack{
//                Text(self.article.author ?? "")
//                    .padding(.leading, 30)
//                    .font(.title)
//                Spacer()
//                Text(self.article.date)
//                    .padding(.trailing, 30)
//            }
//            .frame(width: screenWidth, height: screenHeight * 0.3, alignment: .bottom)
//            Rectangle()
//                .fill(Color(.white))
//                .overlay(
//                    VStack{
//                        HStack{
//                            Text(self.article.title)
//                                .font(.largeTitle)
//                                .fontWeight(.bold)
//                                .padding(.leading, 30)
//                                .padding(.top, 20)
//                            Spacer()
//                        }
//                        Text(self.article.contents)
//                            .padding(.leading, 30)
//                            .padding(.trailing, 30)
//                            .padding(.top, 15)
//                    }
//                    .frame(width: screenWidth, height: screenHeight * 0.7 , alignment: .top)
//                )
//                .frame(width: screenWidth, height: screenHeight * 0.7 , alignment: .leading)
//        }
//        .ignoresSafeArea(.all)
//    }
//}

// extension для получения размеров экрана
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
