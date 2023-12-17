//
//  ViewModel.swift
//  IconPreview
//

import AppKit
import Combine

class ViewModel: ObservableObject {

    @Published var icon1: NSImage?
    @Published var icon2: NSImage?
    @Published var icon3: NSImage?
    @Published var icon4: NSImage?
    @Published var svgIcon: URL? {
        didSet {
            loadAppIcons()
        }
    }
    @Published var icon5: NSImage?
    @Published var icon6: NSImage?
    @Published var icon7: NSImage?
    @Published var icon8: NSImage?

    @Published var fileImporter = false
    @Published var transparent = false {
        didSet {
            if transparent {
                NSApplication.shared.keyWindow?.backgroundColor = .init(white: 1, alpha: 0)
            } else {
                NSApplication.shared.keyWindow?.backgroundColor = .windowBackgroundColor
            }
        }
    }

    private var timer: Timer?

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.objectWillChange.send()
        }
    }

    static func appIcon(_ app: String) -> NSImage? {
        .init(contentsOf: .init(filePath: "/Applications")
            .appending(path: "\(app).app")
            .appending(path: "Contents/Resources/AppIcon.icns"))
    }

    func loadAppIcons() {
        var installedApps = enumerateAppsFolder()
        installedApps.shuffle()
        let getLast: () -> String = {
            if let last = installedApps.popLast() {
                return last
            }
            return "Safari.app"
        }
        setIcon(&icon1, getApp: getLast)
        setIcon(&icon2, getApp: getLast)
        setIcon(&icon3, getApp: getLast)
        setIcon(&icon4, getApp: getLast)
        setIcon(&icon5, getApp: getLast)
        setIcon(&icon6, getApp: getLast)
        setIcon(&icon7, getApp: getLast)
        setIcon(&icon8, getApp: getLast)
    }

    func setIcon(_ icon: inout NSImage?, getApp: () -> String) {
        repeat {
            icon = Self.appIcon(getApp())
        } while icon == nil
    }

    func enumerateAppsFolder() -> [String] {
        var appNames: [String] = []
        let fileManager = FileManager.default
        if let appsURL = fileManager.urls(for: .applicationDirectory, in: .localDomainMask).first {
            if let enumerator = fileManager.enumerator(
                at: appsURL,
                includingPropertiesForKeys: nil,
                options: .skipsSubdirectoryDescendants
            ) {
                while let element = enumerator.nextObject() as? URL {
                    if element.pathExtension == "app" {
                        appNames.append(element.deletingPathExtension().lastPathComponent)
                    }
                }
            }
        }
        return appNames
    }

}
