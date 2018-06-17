//
//  SuggestTableViewController.swift
//  Termproject
//
//  Created by kpugame on 2018. 6. 12..
//  Copyright © 2018년 SeokJinHo. All rights reserved.
//

import UIKit

class SuggestTableViewController: UIViewController, XMLParserDelegate, UITableViewDataSource {

    
    var audioController: AudioController
    required init?(coder aDecoder: NSCoder) {
        audioController = AudioController()
        audioController.preloadAudioEffects(audioFileNames: AudioEffectFiles)
        
        super.init(coder: aDecoder)
    }
    
    
    @IBOutlet weak var TodayLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var pageNum = 1
    
    @IBAction func prevButtonAction(_ sender: Any) {
        if (pageNum > 1) { pageNum -= 1
            beginParsing()
        }
        
        let startX: CGFloat = 300
        let startY: CGFloat = 0
        let endY: CGFloat = 10
        
        let stars = StardustView(frame: CGRect(x: startX, y:startY, width: 10, height: 10))
        self.view.addSubview(stars)
        self.view.sendSubview(toBack: stars)
        
        UIView.animate(withDuration: 3.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            stars.center = CGPoint(x: startX, y: endY)},
                       completion: {(value:Bool)in stars.removeFromSuperview() })
        
        audioController.playerEffect(name: SoundDing)
        
    }
    @IBAction func nextButtonAction(_ sender: Any) {
        if (pageNum < Int(totalCount as String)!) { pageNum += 1
            beginParsing()
        }
        
        let startX: CGFloat = 300
        let startY: CGFloat = 0
        let endY: CGFloat = 10
        
        let stars = StardustView(frame: CGRect(x: startX, y:startY, width: 10, height: 10))
        self.view.addSubview(stars)
        self.view.sendSubview(toBack: stars)
        
        UIView.animate(withDuration: 3.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            stars.center = CGPoint(x: startX, y: endY)},
                       completion: {(value:Bool)in stars.removeFromSuperview() })
        
        audioController.playerEffect(name: SoundDing)
        
    }
    
    @IBOutlet weak var tbData: UITableView!
    
    //for Parsing
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    //parsing data value
    var posterimg = NSMutableString()
    var showTitle = NSMutableString()
    var totalCount = NSMutableString()
    
    
    var hospitalname = ""
    var hospitalname_utf8 = ""
    
    var date : NSString = ""
    
    var search_utf8 = ""
    //보훈병원정보 OpenAPI 및 인증키
    //디폴트 시도코드 = 서울 (sideCd=110000)
    //ServiceKey = "sea100UMmw23Xycs33F1EQnumONR%2F9ElxBLzkilU9Yr1oT4TrCot8Y2p0jyuJP72x9rG9D8CN5yuEs6AS2sAiw%3D%3D"
    var url : String = "http:/api.gugak.go.kr/service/gugakPerformanceService/getPerformanceList?ServiceKey=4VB0o7ZOlNdClfP%2FidH3cNjCCsAfg3APKmEf7Tqg4aS2uPSNn1pA2avCeTcqVVY4pV6I7252637lX8LFUtxXJQ%3D%3D"
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PrintToday()
        beginParsing()
        
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
    @IBAction func doneToPickerViewController(segue:UIStoryboardSegue)
    {
    }
    
    func beginParsing()
    {
        let now = Date()
        let date = DateFormatter()
        
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(abbreviation: "KST")
        date.dateFormat = "yyyy-MM-dd"
        
        var Day = date.string(from: now)
        hospitalname = "동요"
        hospitalname_utf8 = hospitalname.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        posts = []
        parser = XMLParser(contentsOf:(URL(string:url +  "&pageNo=\(pageNum)&numOfRows=4" + "&eventday=\(Day)&title=\(hospitalname_utf8)&startdate=2018-03-01&enddate=2018-12-31"))!)!
        parser.delegate = self
        parser.parse()
        tbData!.reloadData()
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
            if !totalCount.isEqual(nil) {
                elements.setObject(totalCount, forKey: "totalCount" as NSCopying)
            }
            posts.add(elements)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "title") as!
            NSString as String
        
        if let url = URL(string: (posts.object(at: indexPath.row) as AnyObject).value(forKey: "posterimg") as!
            NSString as String)
        {
            if let data = try? Data(contentsOf: url)
            {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        
        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToHospitalDetail" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tbData.indexPath(for: cell)
                hospitalname = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "title") as!
                    NSString as String
                
                hospitalname_utf8 = hospitalname.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                if let detailHospitalTableViewController = segue.destination as?
                    DetailHospitalTableViewController {
                    detailHospitalTableViewController.url = "http:/api.gugak.go.kr/service/gugakPerformanceService/getPerformanceList?pageNo=1&numOfRows=10&&title=" + hospitalname_utf8 + "&ServiceKey=4VB0o7ZOlNdClfP%2FidH3cNjCCsAfg3APKmEf7Tqg4aS2uPSNn1pA2avCeTcqVVY4pV6I7252637lX8LFUtxXJQ%3D%3D"
                }
            }
    }
    
    }
    
    

}
