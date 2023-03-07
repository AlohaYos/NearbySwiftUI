//
//  AppData.swift
//  NearbySwiftUI
//
//  Created by Yos Hashimoto on 2023/03/08.
//

import Foundation
import CoreLocation

class AppData: NSObject {
	var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
	var heading: CLLocationDirection = 0.0
	var course: CLLocationDirection = 0.0
	var speed: CLLocationSpeed = 0.0
	var articles:[Article] = []

	override init() {}
}
