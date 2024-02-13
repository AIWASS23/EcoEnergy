//
//  QoS.swift
//  EcoEnergy
//
//  Created by Marcelo de Araújo on 09/02/202024.
//

import Foundation

enum QoS: String, CaseIterable, Codable {
	
	case auto
	case userInteractive
	case userInitiated
	case utility
	case background
	
	static var presentedCases: [QoS] {
		let filtered: [QoS] = [.utility, .userInitiated, .userInteractive]
		return QoS.allCases.filter({ !filtered.contains($0) })
	}
	
}
