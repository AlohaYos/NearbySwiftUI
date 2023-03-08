//
//  AppData.swift
//  NearbySwiftUI
//
//  Created by Yos Hashimoto on 2023/03/08.
//

import Foundation
import CoreLocation

class AppData: NSObject, ObservableObject {
	var locationManager: LocationManager!
	var parser: Parser!
	@Published var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
	@Published var heading: CLLocationDirection = 0.0
	@Published var course: CLLocationDirection = 0.0
	@Published var speed: CLLocationSpeed = 0.0
	@Published var articles:[Article] = []

	override init() {
		super.init()
		locationManager = LocationManager()
		locationManager.initSelf(appData: self)
		parser = Parser()
		parser.initSelf(appData: self)
	}
}
