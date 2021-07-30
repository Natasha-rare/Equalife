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

    func getTextFromBlocks(json: Array<JSON>)->String{
        var text:String = ""
        for block in json{
            if block["type"] == "text"{
                text += block["data"]["text"].stringValue
            }
        }
        return text
    }

    func getContentDtf(type:String, page: Int, site:String = "dtf", completion: @escaping(_ art: [Article])->()){
        var articles :[Article] = []
        AF.request("https://api.\(site).ru/v1.9/timeline/\(type)?count=8&offset\(page*8)").responseJSON{
            responseJSON in
            switch responseJSON.result{
            case .success(let value):
                let jsonAll = JSON(value)["result"]
                for i  in 0..<jsonAll.count {
                    let json = jsonAll[i]
                    let _ = json["url"].stringValue
                    let text = json["entryContent"]["html"].stringValue.html2String
                    var content: [String] = text.components(separatedBy: " \n")
                    
                    if content.count > 4 {
                        content.removeSubrange(0..<4)
                        if content[0].contains("Listen") { content.removeFirst() }  // карл, зачем?
                    }
                    
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
            case -1:
                // TODO: global news
                DispatchQueue.main.async {
                    completion([])
                }
            case 0: //Meduza_news
                AF.request("https://meduza.io/api/v3/search?chrono=news&locale=ru&page=\(page)&per_page=8").responseJSON { responseJSON in
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
            AF.request("https://meduza.io/api/v3/search?chrono=articles&locale=ru&page=\(page)&per_page=12").responseJSON
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
            getContentDtf(type: "games/recent", page: page) { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 6: //DTF_gameindustry
            getContentDtf(type: "gameindustry/recent", page: page) { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 7: //DTF_gamedev
            getContentDtf(type: "gamedev/recent", page: page) { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 8: //DTF_cinema
            getContentDtf(type: "cinema/recent", page: page) { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 9: //DTF_all
            getContentDtf(type: "default/recent", page: page) { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 10: //Tjournal_news
            getContentDtf(type: "news/recent", page: page, site: "tjournal") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 11: //Tjournal_stories
            getContentDtf(type: "stories/recent", page: page, site: "tjournal") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 12: //Tjournal_tech
            getContentDtf(type: "tech/recent", page: page, site: "tjournal") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 13: //Tjournal_dev
            getContentDtf(type: "dev/recent", page: page, site: "tjournal") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 14: //Tjournal_all
            getContentDtf(type: "default/recent", page: page, site: "tjournal") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 15: //Vc_all
            getContentDtf(type: "default/recent", page: page, site: "vc") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 16: //Vc_design
            getContentDtf(type: "design/recent", page: page, site: "vc") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 17: //Vc_tech
            getContentDtf(type: "tech/recent", page: page, site: "vc") { article in
                articles = article
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
        case 18: //Vc_dev
            getContentDtf(type: "dev/recent", page: page, site: "vc") { article in
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
