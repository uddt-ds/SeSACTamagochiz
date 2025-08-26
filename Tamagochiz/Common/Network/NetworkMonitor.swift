//
//  NetworkManager.swift
//  Tamagochiz
//
//  Created by Lee on 8/26/25.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor

    init() {
        monitor = NWPathMonitor()
    }

    func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void) {
        monitor.start(queue: queue)

        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                statusUpdateHandler(path.status)
            }
        }
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
