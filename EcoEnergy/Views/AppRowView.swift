//
//  AppRowView.swift
//  EcoEnergy
//
//  Created by Marcelo de Araújo on 10/2/202024.
//

import SwiftUI

struct AppRowView: View {
	
	@Binding var app: Application
	
    var body: some View {
		HStack(alignment: .center) {
			FileThumbnailView(url: app.url, thumbnailWidth: 18)
			Text(!app.isHelper ? app.name : "\(app.name) (Helper App)")
				.font(.title3)
			Spacer()
			launchQuitButton
			Picker("", selection: $app.qoS) {
				Text("All Cores")
					.tag(QoS.userInteractive)
				Text("E-Cores Only")
					.tag(QoS.background)
			}
			.pickerStyle(.segmented)
			.frame(maxWidth: 200)
			.disabled(app.isRunning)
		}
		.contextMenu {
			showInFinderButton
		}
    }
	
	var launchQuitButton: some View {
		Group {
			if !app.isRunning {
				Image(systemName: "play.circle.fill")
					.onTapGesture {
						// Launch app
						app.launchWithQoS(completion: {
							print("\"\(app.name)\" launched.")
						})
					}
					.foregroundStyle(Color.green)
			} else {
				Image(systemName: "stop.circle.fill")
					.onTapGesture {
						// Launch app
						app.quit()
					}
					.foregroundStyle(Color.red)
			}
		}
	}
	
	var showInFinderButton: some View {
		Button("Show in Finder") {
			FileSystem.openDirectory(url: app.url.deletingLastPathComponent())
		}
	}
}
