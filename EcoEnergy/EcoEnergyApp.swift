//
//  EcoEnergyApp.swift
//  EcoEnergy
//
//  Created by Marcelo de Araújo on 9/2/202024.
//

import SwiftUI

@main
struct EcoEnergyApp: App {
	
	@StateObject private var applicationsState: ApplicationsState = ApplicationsState.shared
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(applicationsState)
        }
    }
}
