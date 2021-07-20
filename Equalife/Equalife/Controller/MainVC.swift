//
//  MainVC.swift
//  Equalife
//
//  Created by Kostya Bunsberry on 20.07.2021.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = ""
        let logo = UIImageView(image: UIImage(named: "LogoFlat"))
        logo.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logo
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
