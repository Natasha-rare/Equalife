//
//  SpeedQuizes.swift
//  Equalife
//
//  Created by Наталья Автухович on 03.08.2021.
//

import Foundation

// структура упражнения для скорочтения
struct SpeedQuiz{
    var title: String = ""
    var description:String = ""
    var image: String = ""
    
    init(title: String, description: String, image:String){
        self.title = title
        self.description = description
        self.image = image
    }
}

//массив уроков
let lessons = [SpeedQuiz(title: "Таблица Шульте", description: "Зафиксируй свой взгляд на единице, стоящей строго в центре. Не отрывая от нее глаз, попытайся найти с помощью периферийного зрения по очереди остальные числа от 2 до 25. ", image: "https://cdn.maximonline.ru/4e/0d/0d/4e0d0dc3b3eb343c2fa9d87eb0350887/660x689_0xac120005_18588464441529032528.jpg"),
               SpeedQuiz(title: "Клиновидные таблицы", description: "Сконцентрируйтесь сначала на центральном столбце. Затем медленно спускайтесь взглядом вниз, при этом проговаривая вслух боковые числа. Цель данной таблицы цифр для скорочтения — дойти до конца и увидеть одновременно числа и справа, и слева от центрального столбца.", image: "https://assets-global.website-files.com/599873abab717100012c91ea/5f02f3819f73dd0ccd63e331_ZfTxj1E56sGaBMjJw5G6Q5lc5NiBBZN0mg9XdpsvdgfYW361RYGvEfC8nv8UiNhloMR55uIV61-h1adjrlN3DubJofSw6O0A0UPADdY1ytRymPMtG1YQnPQ2Rc2n99Vmz3VgJT6-.jpeg"),
               SpeedQuiz(title: "Лабиринт", description: "Попробуйте одним только взглядом найти выход из этой ловушки.", image: "https://assets-global.website-files.com/599873abab717100012c91ea/5f02f381b92bcb0a6bf56713_Ra0tsPwHS5EZaTKf1uIi0IIuiEBmsmBTjP8Gq8UVgVQDcNKC70egKC6_0ZYYreh7vAm0M1fGMHneLA4Weya-dTCZZcTZH0s_dfgs5Uj_hkSgE1iCdYwsVScONM5FsJtv_owv9QIN.jpeg"),
        SpeedQuiz(title: "Решётка", description: "Прочитайте предложенный ниже текст", image: "https://assets-global.website-files.com/599873abab717100012c91ea/5f02f4330dde3c49a5e9f5aa_014.jpg"),
SpeedQuiz(title: "Струп-тест", description: "Называйте вслух при чтении следующего цветного текста цвета слов. Именно цвета, а не то, что написано.", image: "https://avatars.mds.yandex.net/get-zen_doc/1590748/pub_5e27e5e7d4f07a00aeff2b9f_5e27e67998fe7900ade9eee2/scale_1200")]
