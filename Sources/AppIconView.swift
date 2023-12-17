//
//  AppIconView.swift
//  IconPreview
//

import SwiftUI

struct AppIconView: View {

    @EnvironmentObject private var viewModel: ViewModel
    var icon: NSImage?

    var body: some View {
        Group {
            if let icon {
                Image(nsImage: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(.red)
                    .onAppear {
                        viewModel.loadAppIcons()
                    }
            }
        }
        .padding(5)
    }

}
