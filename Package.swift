// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TicTacToeGame",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "TicTacToeGame",
            targets: ["TicTacToeGame"]),
    ],
    targets: [
        .target(
            name: "TicTacToeGame",
            dependencies: []),
        .testTarget(
            name: "TicTacToeGameTests",
            dependencies: ["TicTacToeGame"]),
    ]
)
