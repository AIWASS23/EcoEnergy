//
//  Notification.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/202024.
//

import Cocoa

class Notification {

    public var text: String {
        didSet {
            label.stringValue = text
        }
    }

    let window: NSWindow
    let visibleTime: TimeInterval
    var label: NSTextField!

    init(
        text: String = "",
        visibleTime: TimeInterval = 2.0
    ) {
        self.text = text
        self.window = NSWindow(
            contentRect: NSRect(origin: .zero, size: CGSize(width: 100, height: 100)),
            styleMask: .borderless, backing: .buffered, defer: true
        )
        self.visibleTime = visibleTime
        buildUI()
    }

    class NotificationSession {
        var cancelled = false
        let modal: Bool

        init(modal: Bool) {
            self.modal = modal
        }
    }

    var previousShowSession: NotificationSession?

    func show() {
        fadeOutTimer?.invalidate()
        fadeOutTimer = nil
        previousShowSession?.cancelled = true

        let newSession = NotificationSession(modal: false)
        self.previousShowSession = newSession
        fadeIn(session: newSession)
        window.makeKeyAndOrderFront(nil)
        window.center()
    }

    func runModal() {
        fadeIn(session: NotificationSession(modal: true))
        NSApp.runModal(for: window)
    }

    func buildUI() {
        window.hasShadow = false
        window.level = .modalPanel
        window.backgroundColor = .clear
        window.alphaValue = 0

        let contentView = NSView(frame: self.window.frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.wantsLayer = true
        contentView.layer!.masksToBounds = true
        contentView.layer!.cornerRadius = 10.0

        self.window.contentView = contentView
        let visualEffectView = NSVisualEffectView(frame: self.window.frame)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.material = .hudWindow
        visualEffectView.state = .active
        contentView.addSubview(visualEffectView)
        NSLayoutConstraint.activate([
            visualEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            visualEffectView.topAnchor.constraint(equalTo: contentView.topAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        label = NSTextField(labelWithString: self.text)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = NSFont.systemFont(ofSize: 18)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        visualEffectView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: visualEffectView.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor, constant: -10)
        ])
    }

    var fadeOutTimer: Timer?
    func fadeIn(session: NotificationSession) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.1
            window.animator().alphaValue = 1.0
        }, completionHandler: {
            guard !session.cancelled else { return }
            let timer = Timer(timeInterval: self.visibleTime, repeats: false) { _ in
                self.fadeOut(session: session)
            }

            RunLoop.current.add(timer, forMode: .common)
            self.fadeOutTimer = timer
        })
    }

    func fadeOut(session: NotificationSession) {
        window.alphaValue = 1.0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            window.animator().alphaValue = 0.0
        }, completionHandler: {
            if session.modal {
                NSApp.stopModal()
            }
        })
    }
}
