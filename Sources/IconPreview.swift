//
//  IconPreview.swift
//  IconPreview
//

import SwiftUI

@main
struct IconPreview: App {

    @FocusedObject private var viewModel: ViewModel?
    @State private var darkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView(darkMode: $darkMode)
                .onChange(of: darkMode, initial: true) {
                    if darkMode {
                        NSApplication.shared.appearance = .init(named: .darkAqua)
                    } else {
                        NSApplication.shared.appearance = .init(named: .aqua)
                    }
                }
        }
        .defaultSize(width: 400, height: 400)
        .commands {
            ToolbarCommands()
            commands
        }
    }

    @CommandsBuilder var commands: some Commands {
        CommandGroup(after: .newItem) {
            Button("Import Image") {
                viewModel?.fileImporter = true
            }
            .keyboardShortcut("i")
        }
        CommandGroup(after: .toolbar) {
            Button("Shuffle Icons") {
                viewModel?.loadAppIcons()
            }
            .keyboardShortcut("r")
            Button("Toggle Dark Mode") {
                darkMode.toggle()
            }
            .keyboardShortcut("d")
            Button("Toggle Transparency") {
                viewModel?.transparent.toggle()
            }
            .keyboardShortcut("t")
        }
        CommandGroup(replacing: .help) {
            // swiftlint:disable force_unwrapping
            Link("IconPreview Help", destination: .init(string: "https://github.com/david-swift/IconPreview")!)
            Link(
                "Human Interface Guidelines",
                destination: .init(string: "https://developer.apple.com/design/human-interface-guidelines/app-icons")!
            )
            Divider()
            Link(
                "Template",
                destination: .init(string: "https://github.com/david-swift/IconPreview/blob/main/Template.svg")!
            )
            // swiftlint:enable force_unwrapping
        }
    }

}
