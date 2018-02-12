//
//  OnboardingFlow.swift
//  RxFlowDemo
//
//  Created by Thibault Wittemberg on 18-02-11.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RxFlow

class OnboardingFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.navigationBar.topItem?.title = "OnBoarding"
        return viewController
    }()

    private let services: AppServices

    init(withServices services: AppServices) {
        self.services = services
    }

    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? DemoStep else { return NextFlowItems.stepNotHandled }

        switch step {
        case .login:
            return navigationToLoginScreen()
        case .loginIsComplete:
            return navigationToApiScreen()
        default:
            return NextFlowItems.stepNotHandled
        }
    }

    private func navigationToLoginScreen () -> NextFlowItems {
        let settingsLoginViewController = SettingsLoginViewController.instantiate()
        settingsLoginViewController.title = "Login"
        self.rootViewController.pushViewController(settingsLoginViewController, animated: false)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: settingsLoginViewController, nextStepper: settingsLoginViewController))
    }

    private func navigationToApiScreen () -> NextFlowItems {
        let settingsViewModel = SettingsViewModel()
        let settingsViewController = SettingsViewController.instantiate(withViewModel: settingsViewModel, andServices: self.services)
        settingsViewController.title = "Api Key"
        self.rootViewController.pushViewController(settingsViewController, animated: true)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: settingsViewController, nextStepper: settingsViewModel))
    }

}
