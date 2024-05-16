//
//  ManageTasks.swift
//  MusicPlayer
//
//  Created by Rahul Singh on 16/05/24.
//

import Foundation

typealias Task = () -> ()
var tasks: [Task] = []

func addTask(_ task: @escaping Task) {
    tasks.append(task)
}

// Function to execute tasks
func executeTasks() {
    for task in tasks {
        task()
    }
    // After execution, you may want to clear the tasks array
    tasks.removeAll()
}
