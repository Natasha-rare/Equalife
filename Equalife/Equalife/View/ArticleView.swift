//
//  ContentView.swift
//  Test
//
//  Created by Егор Тарасов on 22.07.2021.
//

import SwiftUI
import Kingfisher

protocol ScrollDelegate {
    func didScroll()
}

struct ArticleView: View {
    
    @State var scroll : CGFloat = 0.0
    
    let article : Article
    let screenWidth = UIScreen.screenWidth
    let screenHeight = UIScreen.screenHeight
    
    var delegate: ScrollDelegate?
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
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.35)
                                    } else {
                                        ForEach((0..<article.imagesURL.count), id: \.self) { imageIndex in
                                            KFImage(URL(string: article.imagesURL[imageIndex])!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.35)
                                        }
                                    }
                                }.padding(10)
                            }
                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.35, alignment: .center)
                            .overlay(
                                ZStack(){
                                    LinearGradient(gradient:
                                                        Gradient(
                                                            colors: [
                                                                    Color(UIColor.black.withAlphaComponent(0.8)),
                                                                    Color(UIColor.black.withAlphaComponent(0.2)),
                                                                    Color(UIColor.white.withAlphaComponent(0.0))
                                                            ]),
                                                       startPoint: .bottom,
                                                       endPoint: .center
                                        )
                                    VStack{
                                        Spacer()
                                        HStack{
                                            Text(article.author ??  "Author" )
                                                .foregroundColor(Color(UIColor.label))
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .padding([.leading, .trailing], 5)
                                        }
                                    }
                                }
                                
                            )
                        VStack{
                            Text(article.title)
                                .foregroundColor(Color(.black))
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
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !alreadyChanged {
                            print("delegate is called")
                            delegate?.didScroll()
                        }
                    }
            )
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
