//
//  NewsGets.swift
//  Equalife
//
//  Created by Kostya Bunsberry on 20.07.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

func getImagesArray(imgJson: JSON)->[String]{
    var imagesURL: [String] = []
    for (k, v) in imgJson{
        if k.contains("url"){
            imagesURL.append("https://meduza.io/\(v)")
        }
    }
    return imagesURL
}

func getContent(url:String) -> Article{
    var article: Article = Article()
    AF.request("https://meduza.io/api/v3/\(url)").responseJSON{
        responseJSON in
        switch responseJSON.result{
        case .success(let value):
            let json = JSON(value)["root"]
            var text = json["content"]["body"].stringValue
            var content = text.html2String
            var title = json["title"].stringValue
            var url = json["url"].stringValue
            var date:String = json["pub_date"].stringValue
            var images = getImagesArray(imgJson: json["image"])
            article = Article(title: title, contents: content, imagesURL: images, author: "", date: date, isSaved: false)
        case let .failure(error):
            print(error)
        }
    }
    return article
}


// Здесь будут все GET запросы
func GetNews(id :Int) ->[Article]{
    var articles: [Article] = []
    switch id{
        case 0: //Meduza_news
            AF.request("https://meduza.io/api/v3/search?chrono=news&locale=ru&page=0&per_page=24").responseJSON
            {responseJSON in
            switch responseJSON.result {
            case .success(let value):
                let json = JSON(value)
                for (key, value) in json["documents"]{
                    articles.append(getContent(url: key)) //empty cause function doesn't works
                    print(articles)
                }
            case let .failure(error):
                print(error)
            }
        }
    case 1: //Meduza_stories
        break
        //
    default:
        print("Error")
    }
    return articles
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
