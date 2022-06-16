//
//  SceneDelegate.swift
//  MyApp
//
//  Created by Jinwoo Kim on 6/7/22.
//

import UIKit
import Combine

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
#if targetEnvironment(macCatalyst)
    private var toolbarDelegate: ToolbarDelegate = .init()
#endif
    private var cancellableBag: Set<AnyCancellable> = .init()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene: UIWindowScene = (scene as? UIWindowScene) else { return }
        
        let window: UIWindow = .init(windowScene: windowScene)
        let viewController: CalendarViewController = .init()
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
        
        //
        
        if ProcessInfo.processInfo.isMacCatalystApp {
            windowScene.sizeRestrictions!.allowsFullScreen = true
            windowScene.windowingBehaviors!.isClosable = false
            windowScene.windowingBehaviors!.isMiniaturizable = false
        }
        
        Task {
            try await Task.sleep(nanoseconds: 3_000)
            
            let preferences: UIWindowScene.MacGeometryPreferences = await MainActor.run(body: {
                return .init(systemFrame: .init(x: .zero, y: .zero, width: 600.0, height: 800.0))
            })
            
            await MainActor.run(body: {
                // BUG
                windowScene.requestGeometryUpdate(preferences) { error in
                    guard let error: UISceneError = error as? UISceneError else {
                        return
                    }
                    
                    print(error)
                }
            })
        }
        
#if targetEnvironment(macCatalyst)
        let toolbar: NSToolbar = .init(identifier: "main")
        toolbar.delegate = toolbarDelegate
        toolbar.displayMode = .iconAndLabel
        
        if let titleBar: UITitlebar = windowScene.titlebar {
            titleBar.toolbar = toolbar
        }
#endif
        
        session.publisher(for: \.role, options: [.initial, .new])
            .sink { role in
                print(role)
            }
            .store(in: &cancellableBag)
        
#if targetEnvironment(macCatalyst)
        windowScene.effectiveGeometry.publisher(for: \.systemFrame, options: [.initial, .new])
            .sink { systemFrame in
                print(systemFrame)
            }
            .store(in: &cancellableBag)
        
        windowScene.publisher(for: \.isFullScreen)
            .sink { isFullScreen in
                print(isFullScreen)
            }
            .store(in: &cancellableBag)
#endif
    }
}

#if targetEnvironment(macCatalyst)
final class ToolbarDelegate: NSObject, NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let view: UIView = .init()
        view.backgroundColor = .cyan
        return NSUIViewToolbarItem(itemIdentifier: itemIdentifier, uiView: view)
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.init("1"), .init("2"), .init("3"), .init("4"), .init("5")]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.init("1"), .init("2"), .init("3"), .init("4")]
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.init("1"), .init("2"), .init("3")]
    }
    
    func toolbarImmovableItemIdentifiers(_ toolbar: NSToolbar) -> Set<NSToolbarItem.Identifier> {
        return .init([.init("1"), .init("2")])
    }
    
    func toolbar(_ toolbar: NSToolbar, itemIdentifier: NSToolbarItem.Identifier, canBeInsertedAt index: Int) -> Bool {
        return true
    }
    
    func toolbarWillAddItem(_ notification: Notification) {
        
    }
    
    func toolbarDidRemoveItem(_ notification: Notification) {
        
    }
}
#endif
