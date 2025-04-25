//
//  IntentHandler.swift
//  Study Buddy Intent
//
//  Created by Kavinsha Chamod on 2025-04-19.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        if intent is Study_Buddy_Intent {
                return CreateNoteHandler()
            }
        return self
    }
    
}
