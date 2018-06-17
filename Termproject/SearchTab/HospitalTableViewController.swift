//
//  HospitalTableViewController.swift
//  HospitalMap
//
//  Created by kpugame on 2018. 4. 23..
//  Copyright © 2018년 SeokJinHo. All rights reserved.
//

import UIKit
import MapKit
class HospitalTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet var tbData: UITableView!
    
    
    var url : String?
    
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var yadmNm = NSMutableString()
    var addr = NSMutableString()
    
    var pageNum = 1
    var totalCount = NSMutableString()
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func prevButtonAction(_ sender: Any) {
        if (pageNum > 1) { pageNum -= 1
            beginParsing()
        }
    }
    @IBAction func nextButtonAction(_ sender: Any) {
        if (pageNum < Int(totalCount as String)!) { pageNum += 1
            beginParsing()
        }
    }
    var hospitalname = ""
    var hospitalname_utf8 = ""
    
    var imageurl = NSMutableString()
    
    
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf:(URL(string:url! +  "&pageNo=\(pageNum)&numOfRows=10"))!)!
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
            yadmNm = NSMutableString()
            yadmNm = ""
            addr = NSMutableString()
            addr = ""
            imageurl = NSMutableString()
            imageurl = ""
            totalCount = NSMutableString()
            totalCount = ""
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {

        if element.isEqual(to: "title") {
            yadmNm.append(string)
        }
        else if element.isEqual(to: "place"){
            addr.append(string)
        }
        else if element.isEqual(to: "posterimg") {
            imageurl.append(string)
        }
        else if element.isEqual(to: "totalCount") {
            totalCount.append(string)
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item") {
            if !yadmNm.isEqual(nil) {
                elements.setObject(yadmNm, forKey: "title" as NSCopying)
            }
            if !addr.isEqual(nil) {
                elements.setObject(addr, forKey: "place" as NSCopying)
            }
            if !imageurl.isEqual(nil) {
                elements.setObject(imageurl, forKey: "posterimg" as NSCopying)
            }
            if !totalCount.isEqual(nil) {
                elements.setObject(totalCount, forKey: "totalCount" as NSCopying)
            }
            posts.add(elements)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "title") as!
            NSString as String
        
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "place") as!
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
        if segue.identifier == "segueToMapView" {
            if let mapViewController = segue.destination as? MapViewController {
                mapViewController.posts = posts
            }
        }
        
        if segue.identifier == "segueToHospitalDetail" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
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
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
