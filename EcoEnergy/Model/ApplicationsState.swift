//
//  PowerDietTools.swift
//  EcoEnergy
//
//  Created by Marcelo de Araújo on 09/02/202024.
//

import Foundation
import SwiftUI

class ApplicationsState: ValueDataModel<Application> {
	
	static let shared: ApplicationsState = ApplicationsState()
	
	required init(appDirName: String = "EcoEnergy", datastoreName: String = "applicationState") {
		super.init(appDirName: appDirName, datastoreName: datastoreName)
		self.updateAppList()
		WorkspaceEvents.observeRunningApplications()
	}
	
	func updateAppList() {
		Task { @MainActor in
			self.values = await allApps().sorted(by: { $0.url.lastPathComponent <= $1.url.lastPathComponent })
			print("App list updated at \(Date.now.description)")
		}
	}
	
	private func allApps() async -> [Application] {
		let rootAppDir: URL = URL(filePath: "/Applications/")
		let systemAppDir: URL = URL(filePath: "/System/Applications/")
		let userAppDir: URL = URL(filePath: "/Users/\(NSUserName())/Applications/")
		let appDirs: [URL] = [
			rootAppDir,
			systemAppDir,
			userAppDir
		]
		var apps = [Application]()
		for appDir in appDirs {
			do {
				var appUrls: [URL] = try appDir.listDirectory()
				appUrls = appUrls.filter({ $0.pathExtension == "app" })
				apps = apps + appUrls.map { url in
					let currQoS: QoS? = values.filter({ $0.url == url }).first?.qoS
					let isHelper: Bool = url.deletingLastPathComponent().posixPath().contains(".app")
					let isRunning: Bool = {
						let runningApps: [NSRunningApplication] = NSWorkspace.shared.runningApplications
						for app in runningApps {
							if let bundleUrl: URL = app.bundleURL {
								if bundleUrl == url {
									return true
								}
							}
						}
						return false
					}()
					return Application(url: url, isHelper: isHelper, qoS: currQoS ?? .userInteractive, isRunning: isRunning)
				}
			} catch { }
		}
        
		return apps.filter({ $0.name != "EcoEnergy" })
	}
}
