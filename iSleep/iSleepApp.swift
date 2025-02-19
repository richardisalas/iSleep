//
//  iSleepApp.swift
//  iSleep
//
//  Created by Richard Salas on 2025-02-18.
//

import SwiftUI

@main
struct iSleepApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            CalendarView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
