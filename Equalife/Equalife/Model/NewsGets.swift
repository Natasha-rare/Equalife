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

func getContent(url:String, completion: @escaping(_ articles: [Article])->()){
    var articles: [Article] = []
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
            var article = Article(title: title, contents: content, imagesURL: images, author: "", date: date, isSaved: false)
            articles.append(article)
        case let .failure(error):
            print(error)
        }
        completion(articles)
    }
}

func getTextFromBlocks(json: Array<JSON>)->String{
    var text:String = ""
    for block in json{
        if block["type"] == "text"{
            text += block["data"]["text"].stringValue
        }
    }
    return text
}

func getContentDtf(type:String, site:String = "dtf", completion: @escaping(_ art: [Article])->()){
    var art:[Article] = []
    AF.request("https://api.\(site).ru/v1.9/timeline/\(type)").responseJSON{
        responseJSON in
        switch responseJSON.result{
        case .success(let value):
            let jsonAll = JSON(value)["result"]
            print("leeen", jsonAll.count)
            for i  in 0...jsonAll.count - 1 {
            var json = jsonAll[i]
            var title = json["title"].stringValue
            var url = json["url"].stringValue
            var date:String = json["dateRFC"].stringValue
                var images = [json["cover"]["url"].stringValue]
            var text = json["entryContent"]["html"].stringValue.html2String
            var content:[String] = text.components(separatedBy: " \n")
            content.removeSubrange(0..<4)
            if content[0].contains("Listen"){content.removeFirst()}
            var author = json["author"]["name"].stringValue
            var article = Article(title: title, contents: content.joined(separator: ""), imagesURL: images, author: author, date: date, isSaved: false)
            art.append(article) // output works
            }
        case let .failure(error):
            print(error)
        }
        completion(art)
    }
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
                    getContent(url: key){articleRes in articles = articleRes}
//                    print(articles)
                }
            case let .failure(error):
                print(error)
            }
        }
    case 1: //Meduza_stories
        AF.request("https://meduza.io/api/v3/search?chrono=articles&locale=ru&page=0&per_page=24").responseJSON
        {responseJSON in
        switch responseJSON.result {
        case .success(let value):
            let json = JSON(value)
            for (key, value) in json["documents"]{
                getContent(url: key){articleRes in articles = articleRes}
            }
        case let .failure(error):
            print(error)
        }
    }
    case 5://DTF_games
        getContentDtf(type: "games")
            {article in articles = article} // Надо передавать данные в какой-нибудь класс?..
    case 6: //DTF_gameindustry
        getContentDtf(type: "gameindustry"){
            article in articles = article
            print(articles)
        }
    case 7: //DTF_gamedev
        getContentDtf(type: "gamedev"){
            article in articles = article
        }
    case 8: //DTF_cinema
        getContentDtf(type: "cinema"){
            article in articles = article
        }
    case 9: //DTF_all
        getContentDtf(type: "default/recent"){
            article in articles = article
        }
    case 10: //Tjournal_news
        getContentDtf(type: "news", site: "tjournal")
            {article in articles = article} // Надо передавать данные в какой-нибудь класс?..
    case 11: //Tjournal_stories
        getContentDtf(type: "stories", site: "tjournal"){
            article in articles = article
            print(articles)
        }
    case 12: //Tjournal_tech
        getContentDtf(type: "tech", site: "tjournal"){
            article in articles = article
        }
    case 13: //Tjournal_dev
        getContentDtf(type: "dev", site: "tjournal"){
            article in articles = article
        }
    case 14: //Tjournal_all
        getContentDtf(type: "default/recent", site: "tjournal"){
            article in articles = article
        }
    case 15: //Vc_all
        getContentDtf(type: "default/recent", site: "vc"){
            article in articles = article
        }
    case 16: //Vc_design
        getContentDtf(type: "design", site: "vc"){
            article in articles = article
        }
    case 17: //Vc_tech
        getContentDtf(type: "tech", site: "vc"){
            article in articles = article
            print("asdfd", articles)
        }
    case 18: //Vc_dev
        getContentDtf(type: "dev", site: "vc"){
            article in articles = article
        }
    default:
        print("Error")
    }
    print("aaa", articles)
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

//extension String {
//    func condenseWhitespace() -> String {
//        return self.components(separatedBy: .whitespacesAndNewlines)
//            .filter { !$0.isEmpty }
//            .joined(separator: " ")
//    }
//
//}
