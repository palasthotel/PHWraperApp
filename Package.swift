// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PHWrapperApp",
	platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "PHWrapperApp",
            targets: ["PHWrapperApp"]),
    ],
    dependencies: [
		.package(url: "https://github.com/benboecker/Inject.git", from: "3.0.0"),
		.package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0"),
	],
    targets: [
        .target(
            name: "PHWrapperApp",
            dependencies: [
				"Inject",
				.product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
				.product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
				.product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
			],
			resources: [
				.copy("Scripts/iOSNotifications.js"),
			]
		),
        .testTarget(
            name: "PHWrapperAppTests",
            dependencies: ["PHWrapperApp"]),
    ]
)
