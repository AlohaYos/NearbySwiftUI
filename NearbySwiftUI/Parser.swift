//
//  Parser.swift
//  NearbySwiftUI
//
//  Created by Yos Hashimoto on 2023/03/08.
//

import Foundation

class Parser: NSObject, XMLParserDelegate {
	var appData: AppData!
	var parser:XMLParser!

	override init() {
		super.init()
	}
	
	func initSelf(appData: AppData) {
		self.appData = appData
	}

	func GetAndParseInformation() {
		let nearbyDistance = 10000
		let urlString:String = NSString(format:"https://newtonjapan.com/book/demo/NEARBY/get_nearby_xml.php?lat=%f&lon=%f&nearby=%d&count=50",
										 appData.coordinate.latitude,
										 appData.coordinate.longitude,
										 nearbyDistance
		) as String
		print(urlString)
		let url = URL(string: urlString)
		
		do {
			var content = try String(contentsOf:URL(string: urlString)!)
			print(content)
			dump(content.data(using: .utf8)!)
			parser = XMLParser(data: content.data(using: .utf8)!)
			parser.delegate = self
			if parser.parse() {
				appData.articles.sort { Int($0.distance)! < Int($1.distance)! }
				dump(appData.articles)
				
			}
		}
		catch let error {
			_replDebugPrintln("do-catch error")
		}
	}

	func parserDidStartDocument(_ parser: XMLParser) {
		_replDebugPrintln("パース開始")
	}

	func parserDidEndDocument(_ parser: XMLParser) {
		_replDebugPrintln("パース終了")
	}

	func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
		_replDebugPrintln("パースエラー発生")
		dump(parseError)
	}

	// 開始タグを読み込んだ時よばれる - Start
	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

		if (elementName == "article"){
			anArticle = Article()
			appData.articles.append(anArticle!)
		}
		if (anArticle != nil) {
			var exist = false
			switch elementName {
			case "articleID":
				exist = true
			case "title":
				exist = true
			case "lat":
				exist = true
			case "lon":
				exist = true
			case "distance":
				exist = true
			default:
				exist = false
			}
			
			if exist {
				currentElement = ""
			}
		}
	}

	//閉じタグを読み込んだ時よばれる - End
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

		guard (currentElement != nil) else {return}
		
		switch elementName {
		case "articleID":
			anArticle?.articleID = currentElement!
		case "title":
			anArticle?.title = currentElement!
		case "lat":
			anArticle?.lat = currentElement!
		case "lon":
			anArticle?.lon = currentElement!
		case "distance":
			anArticle?.distance = currentElement!
		default:
			break
		}
		
		currentElement = nil
	}

	//タグ以外のテキストを読み込んだ時（タグとタグ間の文字列）
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		guard (currentElement != nil) else {return}
		guard (string != nil) else {return}
		currentElement?.append(string)
	}

	// MARK: Sort Function
	func DistanceSortClosestFirst(a1:Article, a2:Article) -> ComparisonResult {
		let d1 = a1.distance
		let d2 = a2.distance
		
		if d1<d2 {
			return ComparisonResult.orderedAscending
		}
		else if d1>d2 {
			return ComparisonResult.orderedDescending
		}
		else {
			return ComparisonResult.orderedSame
		}
	}

}

