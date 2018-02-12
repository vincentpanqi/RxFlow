//
//  DemoStep.swift
//  RxFlowDemo
//
//  Created by Thibault Wittemberg on 17-07-25.
//  Copyright (c) RxSwiftCommunity. All rights reserved.
//

import RxFlow

enum DemoStep: Step {
    case onboarding
    case apiKey
    case apiKeyIsComplete
    case login
    case loginIsComplete

    case dashboard
    case movieList

    case moviePicked (withMovieId: Int)
    case castPicked (withCastId: Int)

    case settings
    case settingsDone
    case about
}
