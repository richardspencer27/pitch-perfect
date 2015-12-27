//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Richard Spencer on 12/24/15.
//  Copyright © 2015 Richard Spencer. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var title: String!
    var recordingFilePath: NSURL!
    
    init(title: String, recordingFilePath: NSURL) {
        self.title = title
        self.recordingFilePath = recordingFilePath
    }
}
