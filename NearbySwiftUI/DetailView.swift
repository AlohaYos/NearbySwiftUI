//
//  DetailView.swift
//  NearbySwiftUI
//
//  Created by Yos Hashimoto on 2023/03/08.
//

import SwiftUI
import MapKit

struct Spot: Identifiable {
	let id = UUID()
	let latitude: Double
	let longitude: Double
	var coordinate: CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
}
struct DetailView: View {
	var article:Article!
	var regionMeters = 500.0
	@State var region = MKCoordinateRegion(center: .init(latitude: 35.658584, longitude: 139.745431), latitudinalMeters: 500.0, longitudinalMeters: 500.0)
	@State var spotList:[Spot] = []

    var body: some View {
		GeometryReader { geometry in
			VStack {
				List {
					Section {
						Text("緯度: \(article.lat)")
						Text("経度: \(article.lon)")
					} header: {
						Text("位置情報")
					}
				}
				.frame(height: geometry.size.height*0.25)

				Map(coordinateRegion: $region, annotationItems: spotList, annotationContent: { spot in
					MapMarker(coordinate: spot.coordinate, tint: .blue)
				})
//				Map(coordinateRegion: $region)
				.frame(height: geometry.size.height*0.75)
				.edgesIgnoringSafeArea(.all)
				
			}
			.navigationTitle("\(article.title)")
			.onAppear(perform: {
				var lat:Double = Double(article.lat)!
				var lon:Double = Double(article.lon)!
				region = MKCoordinateRegion(center: .init(latitude: lat, longitude: lon), latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
				spotList.append(Spot(latitude: lat, longitude: lon))


			})
		}
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(article: nil)
    }
}
