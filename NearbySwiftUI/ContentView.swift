//
//  ContentView.swift
//  NearbySwiftUI
//
//  Created by Yos Hashimoto on 2023/03/08.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
	@EnvironmentObject var appData : AppData

	var body: some View {
		NavigationView {
			List {
				ForEach(0..<appData.articles.count) { index in
					HStack {
						NavigationLink(destination: DetailView(article: appData.articles[index]), label: {
							Text(appData.articles[index].title)
							Spacer()
							Text("\(appData.articles[index].distance)m")
						})
					}
				}
			}
			.navigationTitle("名所リスト")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
	
	func TapAction(index: Int) {
		print(index)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
