//
//  CalendarViewController.swift
//  MyApp
//
//  Created by Jinwoo Kim on 6/7/22.
//

import UIKit

@MainActor
class MyCaldendarView: UICalendarView, UICollectionViewDelegate {
    private var collectionViewController: CollectionViewController?
    
    func collectionView(_ collectionView: UICollectionView, canPerformPrimaryActionForItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, dismissalPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
//        let view: UIView = .init()
//        view.frame = .init(x: .zero, y: .zero, width: 300.0, height: 300.0)
//        view.backgroundColor = .green
//        return .init(view: view)
//    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration: UIContextMenuConfiguration = .init(identifier: nil, previewProvider: { [weak self] in
            let collectionViewController: CollectionViewController = .init()
            self?.collectionViewController = collectionViewController
            return collectionViewController
        }, actionProvider: { elements -> UIMenu? in
            var elements: [UIMenuElement] = elements

            let test1: UIAction = .init(title: "Test", subtitle: "keepsMenuPresented", image: .init(systemName: "pencil.tip"), identifier: .init("Test1"), discoverabilityTitle: nil, attributes: [.keepsMenuPresented], state: .on) { _ in
                
            }
            
            let test2: UIAction = .init(title: "Test", subtitle: "disabled + mixed", image: .init(systemName: "pencil.tip"), identifier: .init("Test2"), discoverabilityTitle: nil, attributes: [.disabled], state: .mixed) { _ in
                
            }
            
            elements.append(test1)
            elements.append(test2)
            
            return .init(title: "Test", subtitle: "Test", image: .init(systemName: "pencil.tip"), identifier: .init("A"), options: [.displayInline], preferredElementSize: .medium, children: elements)
        })
        
        configuration.badgeCount = 10
        
        return configuration
    }
    
    func collectionView(_ collectionView: UICollectionView, performPrimaryActionForItemAt indexPath: IndexPath) {
        print("Hello!")
    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addAnimations { [weak self, weak collectionViewController] in
            guard let collectionViewController else {
                return
            }
            let rootViewController: UIViewController? = self?.window?.windowScene?.keyWindow?.rootViewController
            rootViewController?.present(collectionViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        animator?.addCompletion { [weak self] in
            self?.collectionViewController = nil
        }
    }
}

@MainActor
class CalendarViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        
        let textField: UITextField = .init()
        textField.delegate = self
        textField.backgroundColor = .lightGray
        
        let calendarView: MyCaldendarView = .init()
        calendarView.delegate = self
//        calendarView.wantsDateDecorations = false
        
//        let singleSelectionDate: UICalendarSelectionSingleDate = .init(delegate: self)
//        calendarView.selectionBehavior = singleSelectionDate
        
        let multiSelectionDate: UICalendarSelectionMultiDate = .init(delegate: self)
        calendarView.selectionBehavior = multiSelectionDate
        
        var buttonConfiguration: UIButton.Configuration = .borderedTinted()
        buttonConfiguration.title = "UIAlertController.severity = .critical"
        let buttonAction: UIAction = .init { [weak self] _ in
            let alert: UIAlertController = .init(title: "Test", message: "Test", preferredStyle: .alert)
            alert.severity = .critical
            
            let action: UIAlertAction = .init(title: "Done", style: .default)
            
            alert.addAction(action)
            
            self?.present(alert, animated: true)
        }
        let button: UIButton = .init(configuration: buttonConfiguration, primaryAction: buttonAction)
        
        var buttonConfiguration2: UIButton.Configuration = .tinted()
        buttonConfiguration2.title = "UIActivityController"
        buttonConfiguration2.baseBackgroundColor = .green
        let button2Action: UIAction = .init { [unowned self] _ in
            let ac: UIActivityViewController = .init(activityItemsConfiguration: self)
            ac.allowsProminentActivity = false
            self.present(ac, animated: true)
        }
        let button2: UIButton = .init(configuration: buttonConfiguration2, primaryAction: button2Action)
        
        var buttonConfiguration3: UIButton.Configuration = .borderedTinted()
        buttonConfiguration3.title = "UIEditMenuInteraction"
        let button3EditInteraction: UIEditMenuInteraction = .init(delegate: self)
        let button3Action: UIAction = .init { _ in
            let configuration: UIEditMenuConfiguration = .init(identifier: nil, sourcePoint: .init(x: 40.0, y: 40.0))
            configuration.preferredArrowDirection = .down
            button3EditInteraction.presentEditMenu(with: configuration)
        }
        let button3: UIButton = .init(configuration: buttonConfiguration3, primaryAction: button3Action)
        button3.addInteraction(button3EditInteraction)
        
        let pasteControlConfiguration: UIPasteControl.Configuration = .init()
        pasteControlConfiguration.cornerStyle = .capsule
        let pasteControl: UIPasteControl = .init(configuration: pasteControlConfiguration)
        pasteControl.target = self
        
        textField.setContentHuggingPriority(.required, for: .vertical)
        calendarView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setContentHuggingPriority(.required, for: .vertical)
        button2.setContentHuggingPriority(.required, for: .vertical)
        button3.setContentHuggingPriority(.required, for: .vertical)
        pasteControl.setContentHuggingPriority(.required, for: .vertical)
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(calendarView)
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(button3)
        stackView.addArrangedSubview(pasteControl)
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - UIPasteConfigurationSupporting
    override func canPaste(_ itemProviders: [NSItemProvider]) -> Bool {
        print(#function)
//        return super.canPaste(itemProviders)
        return true
    }
    
    override func paste(itemProviders: [NSItemProvider]) {
        let alert: UIAlertController = .init(title: nil, message: "\(itemProviders)", preferredStyle: .alert)
        let action: UIAlertAction = .init(title: "Done", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    override func paste(_ sender: Any?) {
        
    }
    
    override func find(_ sender: Any?) {
        
    }
}

extension CalendarViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
//        return .image(.init(systemName: "bookmark.fill"))
        return .default(color: .blue, size: .large)
    }
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        print(dateComponents)
    }
}

extension CalendarViewController: UICalendarSelectionMultiDateDelegate {
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canSelectDate dateComponents: DateComponents) -> Bool {
        return true
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canDeselectDate dateComponents: DateComponents) -> Bool {
        return true
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        print(dateComponents, selection.selectedDates)
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
        print(dateComponents, selection.selectedDates)
    }
}

extension CalendarViewController: UIActivityItemsConfigurationReading {
    var itemProvidersForActivityItemsConfiguration: [NSItemProvider] {
        return [.init(item: "Test" as NSString, typeIdentifier: "Test")]
    }
    
    var applicationActivitiesForActivityItemsConfiguration: [UIActivity]? {
        return [CollaborationCopyLinkActivity()]
    }
}

final class CollaborationCopyLinkActivity: UIActivity {
    override var activityType: UIActivity.ActivityType? {
        return .collaborationCopyLink
    }
    
    override var activityTitle: String? {
        return "Test"
    }
    
    override var activityImage: UIImage? {
        return .init(systemName: "pencil.slash")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        super.prepare(withActivityItems: activityItems)
    }
    
    override class var activityCategory: UIActivity.Category {
        return .share
    }
}

extension CalendarViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, editMenuForCharactersIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        let test1: UIAction = .init(title: "Test", subtitle: "keepsMenuPresented", image: .init(systemName: "pencil.tip"), identifier: nil, discoverabilityTitle: nil, attributes: [.keepsMenuPresented], state: .on) { _ in
            
        }
        
        let test2: UIAction = .init(title: "Test", subtitle: "disabled + mixed", image: .init(systemName: "pencil.tip"), identifier: nil, discoverabilityTitle: nil, attributes: [.disabled], state: .mixed) { _ in
            
        }
        
        
        let menu: UIMenu = .init(title: "Test", subtitle: "Test", image: .init(systemName: "pencil.tip"), identifier: nil, options: [.displayInline], preferredElementSize: .medium, children: [test1, test2])
        
        print(test1.conforms(to: UIMenuLeaf.self))
        
        return menu
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CalendarViewController: UIEditMenuInteractionDelegate {
    func editMenuInteraction(_ interaction: UIEditMenuInteraction, menuFor configuration: UIEditMenuConfiguration, suggestedActions: [UIMenuElement]) -> UIMenu? {
        let test1: UIAction = .init(title: "Test", subtitle: "keepsMenuPresented", image: .init(systemName: "pencil.tip"), identifier: nil, discoverabilityTitle: nil, attributes: [.keepsMenuPresented], state: .on) { _ in
            
        }
        
        let test2: UIAction = .init(title: "Test", subtitle: "disabled + mixed", image: .init(systemName: "pencil.tip"), identifier: nil, discoverabilityTitle: nil, attributes: [.disabled], state: .mixed) { _ in
            
        }
        
        let command: UICommand = .init(title: "Find", action: #selector(find(_:)))
        
        let menu: UIMenu = .init(title: "Test", subtitle: "Test", image: .init(systemName: "pencil.tip"), identifier: nil, options: [.displayInline], preferredElementSize: .large, children: [test1, test2, command])
        
        return menu
    }
    
    func editMenuInteraction(_ interaction: UIEditMenuInteraction, targetRectFor configuration: UIEditMenuConfiguration) -> CGRect {
//        return .init(x: .zero, y: .zero, width: 10.0, height: 3.0)
        let frame: CGRect = interaction.view!.frame
        return .init(x: frame.midX, y: .zero, width: .zero, height: .zero)
    }

    func editMenuInteraction(_ interaction: UIEditMenuInteraction, willPresentMenuFor configuration: UIEditMenuConfiguration, animator: UIEditMenuInteractionAnimating) {
        
    }

    func editMenuInteraction(_ interaction: UIEditMenuInteraction, willDismissMenuFor configuration: UIEditMenuConfiguration, animator: UIEditMenuInteractionAnimating) {
        
    }
}
