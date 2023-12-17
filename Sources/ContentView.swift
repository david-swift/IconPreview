//
//  ContentView.swift
//  IconPreview
//

import AppKit
import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = ViewModel()
    @Binding var darkMode: Bool

    var body: some View {
        Group {
            if let icon = viewModel.svgIcon {
                if let image = NSImage(contentsOf: icon) {
                    grid(image: image)
                        .padding()
                } else {
                    ContentUnavailableView("File import failed.", image: "exclamationmark.triangle")
                }
            } else {
                ContentUnavailableView {
                    Label("Welcome to IconPreview", systemImage: "doc.badge.plus")
                } description: {
                    Text("Open an SVG file containing the app icon.")
                } actions: {
                    Button("Open File") {
                        viewModel.fileImporter = true
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .navigationSubtitle(viewModel.svgIcon?.lastPathComponent ?? "")
        .fileImporter(isPresented: $viewModel.fileImporter, allowedContentTypes: [.image]) { result in
            if case let .success(url) = result {
                viewModel.svgIcon = url
            }
        }
        .toolbar {
            Button {
                viewModel.loadAppIcons()
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            Toggle(isOn: $darkMode) {
                Label("Dark Mode", systemImage: "circle.lefthalf.filled.inverse")
            }
            Toggle(isOn: $viewModel.transparent) {
                Label("Transparent", systemImage: "circle.bottomrighthalf.checkered")
            }
        }
        .task {
            while NSApplication.shared.keyWindow == nil { try? await Task.sleep(nanoseconds: 10) }
            NSApplication.shared.keyWindow?.titlebarAppearsTransparent = true
            NSApplication.shared.keyWindow?.level = .statusBar
            NSApplication.shared.keyWindow?.isMovableByWindowBackground = true
        }
        .environmentObject(viewModel)
        .focusedSceneObject(viewModel)
    }

    func grid(image: NSImage) -> some View {
        Grid {
            GridRow {
                AppIconView(icon: viewModel.icon1)
                AppIconView(icon: viewModel.icon2)
                AppIconView(icon: viewModel.icon3)
            }
            GridRow {
                AppIconView(icon: viewModel.icon4)
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(5)
                AppIconView(icon: viewModel.icon5)
            }
            GridRow {
                AppIconView(icon: viewModel.icon6)
                AppIconView(icon: viewModel.icon7)
                AppIconView(icon: viewModel.icon8)
            }
        }
    }

}
