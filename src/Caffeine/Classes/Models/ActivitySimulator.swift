//
//  ActivitySimulator.swift
//  Caffeine
//
//  Created by Dominic Rodemer on 14.12.24.
//

import Foundation
import AppKit
import IOKit
import CoreGraphics

/// Simulates user activity when the system has been idle for too long.
/// This prevents apps like Microsoft Teams from showing "Away" status.
final class ActivitySimulator {
    static let shared = ActivitySimulator()

    private var checkTimer: Timer?
    private let idleThreshold: TimeInterval = 90  // seconds before simulating activity
    private let checkInterval: TimeInterval = 30  // how often to check idle time

    private init() {}

    deinit {
        stopMonitoring()
    }

    // MARK: - Public Methods

    /// Starts monitoring system idle time and simulating activity when needed
    func startMonitoring() {
        stopMonitoring()

        // Ensure timer is scheduled on main run loop
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.checkTimer = Timer.scheduledTimer(
                withTimeInterval: self.checkInterval,
                repeats: true
            ) { [weak self] _ in
                self?.checkAndSimulateIfNeeded()
            }
        }
    }

    /// Stops monitoring and simulating activity
    func stopMonitoring() {
        checkTimer?.invalidate()
        checkTimer = nil
    }


    // MARK: - Private Methods

    private func checkAndSimulateIfNeeded() {
        guard getSystemIdleTime() >= idleThreshold else { return }
        simulateActivity()
    }

    private func getSystemIdleTime() -> TimeInterval {
        var iterator: io_iterator_t = 0

        guard IOServiceGetMatchingServices(
            kIOMainPortDefault,
            IOServiceMatching("IOHIDSystem"),
            &iterator
        ) == KERN_SUCCESS else { return 0 }

        defer { IOObjectRelease(iterator) }

        let entry = IOIteratorNext(iterator)
        guard entry != 0 else { return 0 }

        defer { IOObjectRelease(entry) }

        var unmanagedDict: Unmanaged<CFMutableDictionary>?
        guard IORegistryEntryCreateCFProperties(
            entry,
            &unmanagedDict,
            kCFAllocatorDefault,
            0
        ) == KERN_SUCCESS,
        let dict = unmanagedDict?.takeRetainedValue() as? [String: Any],
        let idleTime = dict["HIDIdleTime"] as? Int64 else { return 0 }

        // HIDIdleTime is in nanoseconds
        let systemIdleTime = TimeInterval(idleTime) / 1_000_000_000
        //print(systemIdleTime)
        
        return systemIdleTime
    }

    private func simulateActivity() {
        // Get current mouse position using NSEvent (no permissions required)
        let currentPos = NSEvent.mouseLocation

        // Convert from bottom-left origin (NSEvent) to top-left origin (CGWarpMouseCursorPosition)
        guard let screenHeight = NSScreen.main?.frame.height else { return }
        let cgPoint = CGPoint(x: currentPos.x, y: screenHeight - currentPos.y)

        // Move 1 pixel right, then back to original position
        // CGWarpMouseCursorPosition works without Accessibility permission
        let newPos = CGPoint(x: cgPoint.x + 1, y: cgPoint.y)
        CGWarpMouseCursorPosition(newPos)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            CGWarpMouseCursorPosition(cgPoint)
        }
    }
}
