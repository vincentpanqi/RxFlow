//
//  SettingsFlow.swift
//  RxFlowDemo
//
//  Created by Thibault Wittemberg on 17-08-09.
//  Copyright (c) RxSwiftCommunity. All rights reserved.
//

import RxFlow
import RxSwift

class SettingsFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UISplitViewController()
    private let settingsStepper: SettingsStepper
    private let services: AppServices

    init(withServices services: AppServices, andStepper stepper: SettingsStepper) {
        self.settingsStepper = stepper
        self.services = services
    }

    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? DemoStep else { return NextFlowItems.stepNotHandled }

        switch step {
        case .settings:
            return navigateToSettingsScreen()
        case .apiKey:
            return navigateToApiKeyScreen()
        case .about:
            return navigateToAboutScreen()
        default:
            return NextFlowItems.stepNotHandled
        }
    }

    private func navigateToSettingsScreen () -> NextFlowItems {
        let navigationController = UINavigationController()
        let settingsListViewController = SettingsListViewController.instantiate()
        let settingsViewModel = SettingsViewModel()
        let settingsViewController = SettingsViewController.instantiate(withViewModel: settingsViewModel, andServices: self.services)

        self.rootViewController.viewControllers = [navigationController, settingsViewController]
        self.rootViewController.preferredDisplayMode = .allVisible

        settingsViewController.title = "Api Key"

        navigationController.viewControllers = [settingsListViewController]
        if let navigationBarItem = navigationController.navigationBar.items?[0] {
            let settingsButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                                 target: self.settingsStepper,
                                                 action: #selector(SettingsStepper.settingsDone))
            navigationBarItem.setRightBarButton(settingsButton, animated: false)
        }

        return NextFlowItems.multiple(flowItems: [NextFlowItem(nextPresentable: settingsListViewController, nextStepper: settingsListViewController),
                                                  NextFlowItem(nextPresentable: settingsViewController, nextStepper: settingsViewModel)])
    }

    private func navigateToApiKeyScreen () -> NextFlowItems {
        let settingsViewModel = SettingsViewModel()
        let settingsViewController = SettingsViewController.instantiate(withViewModel: settingsViewModel, andServices: self.services)
        settingsViewController.title = "Api Key"
        self.rootViewController.showDetailViewController(settingsViewController, sender: nil)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: settingsViewController, nextStepper: settingsViewModel))
    }

    private func navigateToAboutScreen () -> NextFlowItems {
        let settingsAboutViewController = SettingsAboutViewController.instantiate()
        settingsAboutViewController.title = "About"
        self.rootViewController.showDetailViewController(settingsAboutViewController, sender: nil)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: settingsAboutViewController, nextStepper: settingsAboutViewController))
    }

}

class SettingsStepper: Stepper {

    init() {
        self.step.accept(DemoStep.settings)
    }

    @objc func settingsDone () {
        self.step.accept(DemoStep.settingsDone)
    }
}
