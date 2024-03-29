//
//  CLI.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//

import Foundation
#if canImport(AppKit)
import AppKit
#endif

#if os(macOS)
class CLI {

    static func runCommand(command: String) -> String {
        let task = Process()
        task.launchPath = "/bin/zsh"
        task.arguments = ["-c", command]

        let pipe = Pipe()
        task.standardOutput = pipe

        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? "No output"
        return output
    }

    // Run an AppleScript
    static func runAppleScript(scriptStr: String) {
        if let script = NSAppleScript(source: scriptStr) {
            var error: NSDictionary?
            script.executeAndReturnError(&error)
            if let err = error {
                print(err)
            }
        }
    }

    // Relaunch app
    static func relaunch(afterDelay seconds: TimeInterval = 5) -> Never {
        let task = Process()
        task.launchPath = "/bin/zsh"
        task.arguments = ["-c", "sleep \(seconds); open \"\(Bundle.main.bundlePath)\""]
        task.launch()

        NSApplication.shared.terminate(self)
        exit(0)
    }

}
#endif
