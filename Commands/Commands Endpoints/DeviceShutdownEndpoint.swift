//
//  DeviceShutdownEndpoint.swift
//  Omnissa Action
//
//  Created by Mohammed Lazim on 5/1/19.
//  Copyright © 2019 Omnissa. All rights reserved.
//

import Foundation

class DeviceShutdownEndpoint: DeviceCommandEndpoint {
    var command: String = "Shutdown"

    var networkService: NetworkService

    init(service: NetworkService) {
        self.networkService = service
    }
}
