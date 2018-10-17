//
//  ViewController.swift
//  Busan_Air Dict
//
//  Created by D7702_10 on 2018. 10. 17..
//  Copyright © 2018년 ksh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var myTableView: UITableView!
    
    // 딕셔너리의 배열 저장 : item
    var item:[[String:String]] = []
    
    // 딕셔너리 : item [key:value]
    var items:[String:String] = [:]
    
    var myPm10 = ""
    var myPm25 = ""
    var mySite = ""
    var myPm10Cai = ""
    var myPm25Cai = ""
    
    var currentElement = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        myParse()
    }
    
    @objc func myParse() {
        let skey = "wfNLEMEWY2HXXpx%2F2lvyAbIzGTzle8wzryRev8T%2BI9XfMG%2B7HflQ%2B4nhEhE%2Flbc6LvLREJotOzrTLx%2F%2Btg58KA%3D%3D"
        
        let strURL = "http://opendata.busan.go.kr/openapi/service/AirQualityInfoService/getAirQualityInfoClassifiedByStation?ServiceKey=\(skey)&Date_hour=2018091520&numOfRows=21"
        
        if URL(string: strURL) != nil {
            if let myParser = XMLParser(contentsOf: URL(string: strURL)!) {
                myParser.delegate = self
                
                if myParser.parse() {
                    print("파싱 성공")
                    print("PM10")
                } else {
                    print("파싱 실패")
                }
            } else {
                print("URL 오류 발생!")
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        //print(elementName)
    }
    
    // 2. tag 다음에 문자열을 만나면 실행
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        // 공백제거
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        // 공백체크 후 데이터 뽑기
        if !data.isEmpty {
            items[currentElement] = data
        }
        
    }
    
    // 3. tag가 끝날때 실행(/tag)
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
               item.append(items)
            print(items)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "RE", for: indexPath)
        
        let myItem = item[indexPath.row]
        
        let site = cell.viewWithTag(1) as! UILabel
        let pm10 = cell.viewWithTag(2) as! UILabel
        let pm10cai = cell.viewWithTag(3) as! UILabel
        
        pm10.text = myItem["pm10"]
        site.text = myItem["site"]
        pm10cai.text = myItem["pm10Cai"]
        return cell
    }
    
}
