//
//  ArticleVC.swift
//  Equalife
//
//  Created by Kostya Bunsberry on 20.07.2021.
//

import UIKit


let content = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi viverra venenatis mauris vitae egestas. In vel lectus ut massa rhoncus rhoncus. Aliquam consequat venenatis augue, vitae mollis nunc sodales vitae. Nullam condimentum iaculis nisi, vel convallis sem tincidunt vitae. Sed sit amet ligula sit amet augue rutrum congue sed a ligula. Aenean pharetra lobortis mauris, ut luctus est egestas ut. Ut viverra imperdiet pellentesque. In ut tristique ante.
    Vivamus magna mi, aliquam sit amet metus non, accumsan malesuada nisi. Nunc cursus sapien in sem porta, id molestie eros aliquam. Vivamus nibh ante, placerat id massa in, semper fringilla nisi. Sed fringilla purus orci, vel placerat felis feugiat eu. Nunc suscipit diam eu feugiat auctor. Integer ut elit quis lacus maximus feugiat. Integer congue massa dolor, ut pellentesque diam condimentum eu. Phasellus blandit ultrices euismod. Duis vulputate ligula felis, at ultrices est semper eget. Morbi vel rhoncus arcu, tempor scelerisque ex. Curabitur congue quam eget tellus consectetur dignissim. Mauris venenatis enim diam, eu gravida nibh elementum sit amet. Donec pulvinar tristique mauris vel rutrum. Donec ut ipsum id justo imperdiet varius.In elit ex, bibendum in purus placerat, imperdiet bibendum felis.
    Nulla varius ultrices felis quis lobortis. Donec vel finibus neque, id dapibus nunc. Maecenas et vulputate sem. Donec faucibus, tellus ullamcorper imperdiet pellentesque, ipsum eros gravida ante, vitae efficitur mauris nibh sit amet turpis. Suspendisse ut volutpat nisl. Sed ornare nibh eros, a pretium lacus dignissim at. Nam euismod tortor quis sem lacinia maximus. Aenean vulputate, nisi ut varius viverra, sapien nisl faucibus orci, quis iaculis turpis tellus sit amet odio. Praesent pulvinar dolor interdum sagittis fermentum.
"""
let testArticle = Article(title: "TestArticle", contents: content, imagesURL: ["FlatLogo"], author: "Author", date: "22-07-2021", isSaved: false)

class ArticleViewController: UIViewController{


//    var articleImageView = UIImageView()
//    var articleTextView = UITextView()
    let screenWidth = UIScreen.screenWidth
    let screenHeight = UIScreen.screenHeight
//    var article : Article
//
//    func previewArticle(article : Article){
//        self.article = article
//    }
    @IBOutlet weak var articleTextView: UITextView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var StackView: UIStackView!
    
    @IBOutlet weak var articleDateLabel: UILabel!
    @IBOutlet weak var articleAurhorLabel: UILabel!

    let logo = UIImage(named: "LogoFlat")
    let author : String = "Author"
    let date : String = "2020-20-20"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleImageView.contentMode = .scaleAspectFit
        articleImageView.image = logo
        articleImageView.isUserInteractionEnabled = false

        articleAurhorLabel.text = author
        articleAurhorLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        articleDateLabel.text = date
        articleDateLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        
        articleTextView.layer.shadowColor = UIColor.black.cgColor
        articleTextView.layer.shadowOpacity = 1
        articleTextView.layer.shadowOffset = .zero
        articleTextView.layer.shadowRadius = 10
        articleTextView.text = testArticle.contents
        articleTextView.font = UIFont.systemFont(ofSize: 17)
        articleTextView.isEditable = false
        articleTextView.isScrollEnabled = false
        //self.StackView.addSubview(articleImageView)
        //self.StackView.addSubview(articleTextView)
    }
}


