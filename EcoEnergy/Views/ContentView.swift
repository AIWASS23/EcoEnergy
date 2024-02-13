//
//  ContentView.swift
//  EcoEnergy
//
//  Created by Marcelo de Araújo on 9/2/202024.
//

import SwiftUI

struct ContentView: View {
	
	@EnvironmentObject private var applicationsState: ApplicationsState
	
	@State private var query: String = ""
	@State private var queryQos: [QoS] = [.userInteractive, .background]
	@State private var includeHelpers: Bool = false
	
	var body: some View {
		VStack {
			if !searchedApps.isEmpty {
				List(searchedApps) { app in
					AppRowView(app: app)
				}
			} else {
				ProgressView()
			}
		}
		.searchable(text: $query)
		.toolbar {
			ToolbarItemGroup {
				reloadButton
				qoSFilterMenu
			}
		}
	}
	
	var reloadButton: some View {
		Button {
			applicationsState.updateAppList()
		} label: {
			Label("", systemImage: "arrow.clockwise")
		}
	}
	
	var qoSFilterMenu: some View {
		Picker("", selection: $queryQos) {
			Text("All Apps")
				.tag([QoS.userInteractive, QoS.background])
			Text("P & E-Cores")
				.tag([QoS.userInteractive])
			Text("E-Cores")
				.tag([QoS.background])
		}
	}
	
	var searchedApps: Binding<[Application]> {
		var searchResults: Binding<[Application]>
		if query.isEmpty {
			searchResults = $applicationsState.values
		} else {
			searchResults = $applicationsState.values.filter({
				$0.name.lowercased().contains(query.lowercased())
			})
		}
		let qoSResult: Binding<[Application]> = searchResults.filter({ queryQos.contains($0.qoS) })
		return qoSResult
	}
	
}

#Preview {
    ContentView()
		.environmentObject(ApplicationsState.shared)
}
