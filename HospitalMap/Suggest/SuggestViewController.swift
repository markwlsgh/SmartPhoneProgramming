//
//  SuggestViewController.swift
//  Termproject
//
//  Created by kpugame on 2018. 6. 11..
//  Copyright © 2018년 SeokJinHo. All rights reserved.
//

//
//  PagedScrollViewController.swift
//  Termproject
//
//  Created by kpugame on 2018. 6. 11..
//  Copyright © 2018년 SeokJinHo. All rights reserved.
//

import UIKit

class SuggestViewController: UIViewController, UIScrollViewDelegate, XMLParserDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollView2: UIScrollView!
    @IBOutlet var scrollView3: UIScrollView!
    @IBOutlet var scrollView4: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var TodayLabel: UILabel!
    
    //for Parsing
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    //parsing data value
    var posterimg = NSMutableString()
    var showTitle = NSMutableString()
    var numOfRows = NSMutableString()
    var pageNo = NSMutableString()
    var totalCount = NSMutableString()
    
    
    var hospitalname = ""
    var hospitalname_utf8 = ""
    
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    var date : NSString = ""
    
    var search_utf8 = ""
    //보훈병원정보 OpenAPI 및 인증키
    //디폴트 시도코드 = 서울 (sideCd=110000)
    //ServiceKey = "sea100UMmw23Xycs33F1EQnumONR%2F9ElxBLzkilU9Yr1oT4TrCot8Y2p0jyuJP72x9rG9D8CN5yuEs6AS2sAiw%3D%3D"
    var url : String = "http:/api.gugak.go.kr/service/gugakPerformanceService/getPerformanceList?startDate=2015-01-01&endDate=2015-12-31&eventDate=2015-10-24&title=hi&place=hi&pageNo=1&numOfRows=4&ServiceKey=4VB0o7ZOlNdClfP%2FidH3cNjCCsAfg3APKmEf7Tqg4aS2uPSNn1pA2avCeTcqVVY4pV6I7252637lX8LFUtxXJQ%3D%3D"
    var sgguCd : String = "110023" //디폴트 시구코드 = 광진구
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PrintToday()
        beginParsing()
        
        let pageCount = Int(totalCount as String)! / 4
        
        let pageScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pageScrollViewSize.width * CGFloat(pageCount), height : pageScrollViewSize.height )
        
        loadVisiblePages()
    }
    
    func loadVisiblePages() {
        let pageWidth = scrollView.frame.width * 2
        let page = Int(totalCount as String)! / 4
    }
    
    func loadPage(_ page: Int) {
        if page < 0 || page >= pageImages.count {
            return
        }
        
        
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
    
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf:(URL(string:"http:/api.gugak.go.kr/service/gugakPerformanceService/getPerformanceList?startDate=2015-01-01&endDate=2015-12-31&eventDate=2015-10-24&title=hi&place=hi&pageNo=1&numOfRows=10&ServiceKey=4VB0o7ZOlNdClfP%2FidH3cNjCCsAfg3APKmEf7Tqg4aS2uPSNn1pA2avCeTcqVVY4pV6I7252637lX8LFUtxXJQ%3D%3D"))!)!
        parser.delegate = self
        parser.parse()
        //tbData!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
    
            posterimg = NSMutableString()
            posterimg = ""
            showTitle = NSMutableString()
            showTitle = ""
            numOfRows = NSMutableString()
            numOfRows = ""
            pageNo = NSMutableString()
            pageNo = ""
            totalCount = NSMutableString()
            totalCount = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element.isEqual(to: "title") {
            showTitle.append(string)
        }
        else if element.isEqual(to: "posterimg"){
            posterimg.append(string)
        }
        else if element.isEqual(to: "numOfRows"){
            numOfRows.append(string)
        }
        else if element.isEqual(to: "pageNo"){
            pageNo.append(string)
        }
        else if element.isEqual(to: "totalCount") {
            totalCount.append(string)
        }

    }

    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item") {
            if !showTitle.isEqual(nil) {
                elements.setObject(showTitle, forKey: "title" as NSCopying)
            }
            if !posterimg.isEqual(nil) {
                elements.setObject(posterimg, forKey: "posterimg" as NSCopying)
            }
            if !numOfRows.isEqual(nil) {
                elements.setObject(numOfRows, forKey: "numOfRows" as NSCopying)
            }
            if !pageNo.isEqual(nil) {
                elements.setObject(pageNo, forKey: "pageNo" as NSCopying)
            }
            if !totalCount.isEqual(nil) {
                elements.setObject(totalCount, forKey: "totalCount" as NSCopying)
            }
            posts.add(elements)
        }
    }
    
}
