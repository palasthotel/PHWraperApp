// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PHWrapperApp",
	platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PHWrapperApp",
            targets: ["PHWrapperApp"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
		.package(name: "Inject",
				 url: "https://github.com/benboecker/Inject.git",
				 from: "3.0.0"),
		.package(name: "Firebase",
				 url: "https://github.com/firebase/firebase-ios-sdk.git",
				 from: "9.0.0"),
	],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PHWrapperApp",
            dependencies: [
				"Inject",
				.product(name: "FirebaseAnalytics", package: "Firebase"),
				.product(name: "FirebaseRemoteConfig", package: "Firebase"),
				.product(name: "FirebaseMessaging", package: "Firebase"),
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
