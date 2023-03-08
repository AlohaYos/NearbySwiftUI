//
//  LocationManager.swift
//  NearbySwiftUI
//
//  Created by Yos Hashimoto on 2023/03/08.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
	var appData: AppData!
	let manager = CLLocationManager()
	@Published var location = CLLocation()
	@Published var heading = CLHeading()

	override init() {
		super.init()
	}
	
	func initSelf(appData: AppData) {
		self.appData = appData
		self.manager.delegate = self
		self.manager.requestWhenInUseAuthorization()
		self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
		self.manager.distanceFilter = 1
		self.manager.startUpdatingLocation()
		self.manager.startUpdatingHeading()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
		appData.heading = newHeading.trueHeading
		print("ヘディング:\(appData.heading.description)")
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.location = locations.last!
		//appData.coordinate = locations[0].coordinate
		
		/* Tokyo tower location */
		var tmpCood = CLLocationCoordinate2D()
		tmpCood.latitude = 35.658587
		tmpCood.longitude = 139.745425
		appData.coordinate = tmpCood;
		/* */

		_replDebugPrintln("緯度:\(appData.coordinate.latitude) 経度:\(appData.coordinate.longitude)")
//		// POI情報のパース
//		GetAndParseInformation()
//		// リストの再表示
//		let navControl = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
////		let tableVC = navControl.storyboard?.instantiateViewController(withIdentifier: "TableVC") as! TableVC
//		let tableVC = navControl.topViewController as! TableVC
//		tableVC.tableView.reloadData()
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("位置情報の取得に失敗した")
	}
	
	func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
		return true
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .notDetermined:
			manager.requestWhenInUseAuthorization()
			break
		case .denied:
			_replDebugPrintln("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
			// 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
			break
		case .restricted:
			_replDebugPrintln("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
			// 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
			break
		case .authorizedAlways:
			_replDebugPrintln("常時、位置情報の取得が許可されています。")
			// 位置情報取得の開始処理
			break
		case .authorizedWhenInUse:
			_replDebugPrintln("起動時のみ、位置情報の取得が許可されています。")
			// 位置情報取得の開始処理
			break
		}
	}
}
