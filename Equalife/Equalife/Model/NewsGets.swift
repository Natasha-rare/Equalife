//
//  NewsGets.swift
//  Equalife
//
//  Created by Kostya Bunsberry on 20.07.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIService {

    func getImagesArray(imgJson: JSON)->[String]{
        var imagesURL: [String] = []
        for (k, v) in imgJson{
            if k.contains("url"){
                imagesURL.append("https://meduza.io/\(v)")
            }
        }
        return imagesURL
    }
    
//    func getImagesDtf(text:String) -> [String]{
//        var imagesUrl:[String] = []
//        var src:String = ""
//
//        return imagesUrl
//    }

    func getContent(url:String, completion: @escaping (Article)->()) {
        var article: Article? = nil
        AF.request("https://meduza.io/api/v3/\(url)").responseJSON { responseJSON in
            switch responseJSON.result{
            case .success(let value):
                let json = JSON(value)["root"]
//                let url = json["url"].stringValue
                let images = self.getImagesArray(imgJson: json["image"])
                article = Article(title: json["title"].stringValue,
                                         contents: json["content"]["body"].stringValue.html2String,
                                         imagesURL: images,
                                         author: "",
                                         date: json["pub_date"].stringValue,
                                         isSaved: false)
                if let articleRes = article {
                    completion(articleRes)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getWorldNews(completion: @escaping(_ art: [Article])->()){
        var articles:[Article] = []
        AF.request("https://newsapi.org/v2/top-headlines?language=ru&apiKey=209637fc7d0549bdb08f9f490015c8c4").responseJSON { responseJSON in
            switch responseJSON.result {
            case .success(let value):
                var jsonAll = JSON(value)["articles"]
                for i in 0..<jsonAll.count{
                    let json = jsonAll[i]
                    var a = Article(title: json["title"].stringValue,
                                    contents: json["description"].stringValue,
                                    imagesURL: [json["urlToImage"].stringValue],
                                    author: json["author"].stringValue,
                                    date: json["publishedAt"].stringValue, isSaved: false)
                    articles.append(a)
                }
                completion(articles)
            case let .failure(error):
                print(error)
                
            }
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
        var articles :[Article] = []
        AF.request("https://api.\(site).ru/v1.9/timeline/\(type)").responseJSON{
            responseJSON in
            switch responseJSON.result{
            case .success(let value):
                let jsonAll = JSON(value)["result"]
                for i  in 0..<jsonAll.count {
                    let json = jsonAll[i]
                    let _ = json["url"].stringValue
                    let text = json["entryContent"]["html"].stringValue.html2String
                    var content:[String] = text.components(separatedBy: " \n")
                    content.removeSubrange(0..<4)
                    if content[0].contains("Listen") { content.removeFirst() }
                    let a = Article(title: json["title"].stringValue,
                                   contents: content.joined(separator: ""),
                                   imagesURL: [json["cover"]["url"].stringValue],
                                   author: json["author"]["name"].stringValue,
                                   date: json["dateRFC"].stringValue,
                                   isSaved: false)
                    
                    articles.append(a) // output works
                    if articles.count == jsonAll.count {
                        completion(articles)
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    // Здесь будут все GET запросы
    func GetNews(id :Int, page: Int, completion: @escaping ([Article])->()){
        var articles: [Article] = []
        switch id{
        case -1: //global
            getWorldNews(){ allArticles in
                articles = allArticles
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 0: //Meduza_news
                AF.request("https://meduza.io/api/v3/search?chrono=news&locale=ru&page=\(page)&per_page=24").responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success(let value):
                        let json = JSON(value)
                        
                        for (key, _) in json["documents"] {
                            self.getContent(url: key){ articleRes in
                                articles.append(articleRes)
                                
                                if articles.count == 24 {
                                    DispatchQueue.main.async {
                                        completion(articles)
                                    }
                                }
                            }
                        }
                    case let .failure(error):
                        print(error)
                    }
                }
        case 1: //Meduza_stories
            AF.request("https://meduza.io/api/v3/search?chrono=articles&locale=ru&page=\(page)&per_page=24").responseJSON
            {responseJSON in
            switch responseJSON.result {
            case .success(let value):
                let json = JSON(value)
                for (key, _) in json["documents"] {
                    self.getContent(url: key){ articleRes in
                        articles.append(articleRes)
                        
                        if articles.count == 24 {
                            DispatchQueue.main.async {
                                completion(articles)
                            }
                        }
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
        case 5://DTF_games
            getContentDtf(type: "games/recent") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 6: //DTF_gameindustry
            getContentDtf(type: "gameindustry") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 7: //DTF_gamedev
            getContentDtf(type: "gamedev") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 8: //DTF_cinema
            getContentDtf(type: "cinema") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 9: //DTF_all
            getContentDtf(type: "default/recent") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 10: //Tjournal_news
            getContentDtf(type: "news", site: "tjournal") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 11: //Tjournal_stories
            getContentDtf(type: "stories", site: "tjournal") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 12: //Tjournal_tech
            getContentDtf(type: "tech", site: "tjournal") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 13: //Tjournal_dev
            getContentDtf(type: "dev", site: "tjournal") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 14: //Tjournal_all
            getContentDtf(type: "default/recent", site: "tjournal") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 15: //Vc_all
            getContentDtf(type: "default/recent", site: "vc") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 16: //Vc_design
            getContentDtf(type: "design", site: "vc") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 17: //Vc_tech
            getContentDtf(type: "tech", site: "vc") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 18: //Vc_dev
            getContentDtf(type: "dev", site: "vc") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 19: //Vc_finance
            getContentDtf(type: "finance", site: "vc") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 20: //Vc_media
            getContentDtf(type: "media", site: "vc") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 21: //Vc_education
            getContentDtf(type: "education", site: "vc") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 22: //Vc_yandex.zen
            getContentDtf(type: "yandex.zen", site: "vc") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 23: //Tjournal_yandex.zen
            getContentDtf(type: "yandex.zen", site: "tjournal") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 24: //Tjournal_games
            getContentDtf(type: "games", site: "tjournal") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 25: //DTF_news
            getContentDtf(type: "news", site: "dtf") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 26: //DTF_design
            getContentDtf(type: "design", site: "dtf") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        default:
            print("Error")
        }
    }
        
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
