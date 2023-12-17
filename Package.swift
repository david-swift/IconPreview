// swift-tools-version: 5.9
//
//  Package.swift
//  IconPreview
//

import PackageDescription

let package = Package(
    name: "IconPreview",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "IconPreview",
            targets: ["IconPreview"]
        )
    ],
    targets: [
        .executableTarget(
            name: "IconPreview",
            path: "Sources"
        )
    ]
)
