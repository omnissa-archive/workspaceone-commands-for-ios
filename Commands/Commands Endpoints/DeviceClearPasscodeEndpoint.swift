//
//  DeviceLockEndpoint.swift
//  Action
//
//  Created by Mohammed Lazim on 4/7/19.
//  Copyright © 2019-2020 Omnissa, LLC.

import Foundation

class DeviceClearPasscodeEndpoint: DeviceCommandEndpoint {
    var command: String = "ClearPasscode"

    var networkService: NetworkService

    init(service: NetworkService) {
        self.networkService = service
    }
}
