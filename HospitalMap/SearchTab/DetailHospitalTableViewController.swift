//
//  DetailHospitalTableViewController.swift
//  HospitalMap
//
//  Created by kpugame on 2018. 4. 27..
//  Copyright © 2018년 SeokJinHo. All rights reserved.
//

import UIKit

class DetailHospitalTableViewController: UITableViewController, XMLParserDelegate {
    @IBOutlet var detailTableView: UITableView!
    
    var url : String?
    
    var parser = XMLParser()
    let postsname : [String] = ["공연명","공연 내용", "공연 장소", "공연장 주소", "공연 시작일", "공연 종료일" ,"공연 시작 시간","공연 종료 시간", "요금 정보", "관람 요금", "좌석수", "공연 상세 정보"]
    var posts : [String] = ["","","","","","","","","",""]
    var element = NSString()
    
    var posts2 : NSMutableArray = []
    var elements = NSMutableDictionary()
    
    var showTitle = NSMutableString()
    var cont = NSMutableString()
    var place = NSMutableString()
    var juso = NSMutableString()
    var startDate = NSMutableString()
    var endDate = NSMutableString()
    var startTime = NSMutableString()
    var endTime = NSMutableString()
    var freeText = NSMutableString()
    var price = NSMutableString()
    var searnum = NSMutableString()
    var programtext = NSMutableString()
    
    var latitude = NSMutableString()
    var longitude = NSMutableString()
    
    
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf: (URL(string:url!))!)!
        parser.delegate = self
        parser.parse()
        detailTableView!.reloadData()
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            posts = ["","","","","","","","","","","",""]
            
            showTitle = NSMutableString()
            showTitle = ""
            cont = NSMutableString()
            cont = ""
            place = NSMutableString()
            place = ""
            juso = NSMutableString()
            juso = ""
            startDate = NSMutableString()
            startDate = ""
            endDate = NSMutableString()
            endDate = ""
            startTime = NSMutableString()
            startTime = ""
            endTime = NSMutableString()
            endTime = ""
            freeText = NSMutableString()
            freeText = ""
            price = NSMutableString()
            price = ""
            searnum = NSMutableString()
            searnum = ""
            programtext = NSMutableString()
            programtext = ""
            
            //
            latitude = NSMutableString()
            latitude = ""
            longitude = NSMutableString()
            longitude = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "title") {
            showTitle.append(string)
        }
        else if element.isEqual(to: "cont") {
            cont.append(string)
        }
        else if element.isEqual(to: "place") {
            place.append(string)
        }
        else if element.isEqual(to: "juso") {
            juso.append(string)
        }
        else if element.isEqual(to: "startDate") {
            startDate.append(string)
        }
        else if element.isEqual(to: "endDate") {
            endDate.append(string)
        }
        else if element.isEqual(to: "startTime") {
            startTime.append(string)
        }
        else if element.isEqual(to: "endTime") {
            endTime.append(string)
        }
        else if element.isEqual(to: "freeText") {
            freeText.append(string)
        }
        else if element.isEqual(to: "price") {
            price.append(string)
        }
        else if element.isEqual(to: "searnum") {
            searnum.append(string)
        }
        else if element.isEqual(to: "programtext") {
            programtext.append(string)
        }
        
        //
        else if element.isEqual(to: "latitude") {
            latitude.append(string)
        }
        else if element.isEqual(to: "longitude") {
            longitude.append(string)
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item") {
            if !showTitle.isEqual(nil) {
                posts[0] = showTitle as String
                elements.setObject(showTitle, forKey: "title" as NSCopying)
            }
            if !cont.isEqual(nil) {
                posts[1] = cont as String
            }
            if !place.isEqual(nil) {
                posts[2] = place as String
                elements.setObject(place, forKey: "place" as NSCopying)
            }
            if !juso.isEqual(nil) {
                posts[3] = juso as String
            }
            if !startDate.isEqual(nil) {
                posts[4] = startDate as String
            }
            if !endDate.isEqual(nil) {
                posts[5] = endDate as String
            }
            if !startTime.isEqual(nil) {
                posts[6] = startTime as String
            }
            if !endTime.isEqual(nil) {
                posts[7] = endTime as String
            }
            if !freeText.isEqual(nil) {
                posts[8] = freeText as String
            }
            if !price.isEqual(nil) {
                posts[9] = price as String
            }
            if !searnum.isEqual(nil) {
                posts[10] = searnum as String
            }
            if !programtext.isEqual(nil) {
                posts[11] = programtext as String
            }
            if !latitude.isEqual(nil) {
                elements.setObject(latitude, forKey: "latitude" as NSCopying)
                print("latitude : ", latitude)
            }
            if !longitude.isEqual(nil) {
                elements.setObject(longitude, forKey: "longitude" as NSCopying)
                print("longitude : ", longitude)
            }
            posts2.add(elements)
            
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalCell", for: indexPath)

        cell.textLabel?.text = postsname[indexPath.row]
        cell.detailTextLabel?.text = posts[indexPath.row]
        // Configure the cell...

        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMapView" {
            if let mapViewController = segue.destination as? MapViewController {
                mapViewController.posts = posts2
            }
        }
        
    }

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
