//
//  PagedScrollViewController.swift
//  Termproject
//
//  Created by kpugame on 2018. 6. 11..
//  Copyright © 2018년 SeokJinHo. All rights reserved.
//

import UIKit

class PagedScrollViewController: UIView, UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!

    
    @IBOutlet weak var TodayLabel: UILabel!
    var date : NSString = ""
    
    var search_utf8 = ""
    //보훈병원정보 OpenAPI 및 인증키
    //디폴트 시도코드 = 서울 (sideCd=110000)
    //ServiceKey = "sea100UMmw23Xycs33F1EQnumONR%2F9ElxBLzkilU9Yr1oT4TrCot8Y2p0jyuJP72x9rG9D8CN5yuEs6AS2sAiw%3D%3D"
    var url : String = "http:/api.gugak.go.kr/service/gugakPerformanceService/getPerformanceList?startDate=2015-01-01&endDate=2015-12-31&eventDate=2015-10-24&title=hi&place=hi&pageNo=1&numOfRows=10&ServiceKey=4VB0o7ZOlNdClfP%2FidH3cNjCCsAfg3APKmEf7Tqg4aS2uPSNn1pA2avCeTcqVVY4pV6I7252637lX8LFUtxXJQ%3D%3D"
    var sgguCd : String = "110023" //디폴트 시구코드 = 광진구
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PrintToday()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func PrintToday() {
        let now = Date()
        let date = DateFormatter()
        
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(abbreviation: "KST")
        date.dateFormat = "yyyy-MM-dd"
        
        
        TodayLabel.text = date.string(from: now)
    }

}
