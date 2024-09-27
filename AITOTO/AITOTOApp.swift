//
//  AITOTOApp.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/19.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // プロバイダファクトリの宣言
        let providerFactory: AppCheckProviderFactory

        // ビルド設定に応じてプロバイダを切り替え
        #if DEBUG
        providerFactory = AppCheckDebugProviderFactory()
        #else
        if #available(iOS 14.0, *) {
            providerFactory = AppAttestProviderFactory()
        } else {
            providerFactory = DeviceCheckProviderFactory()
        }
        #endif

        // App Checkのプロバイダを設定
        AppCheck.setAppCheckProviderFactory(providerFactory)

        // Firebaseの初期化
        FirebaseApp.configure()

        return true
    }
}

@main
struct AITOTOApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
