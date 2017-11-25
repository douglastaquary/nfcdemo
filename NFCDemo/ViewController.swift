//
//  ViewController.swift
//  NFCDemo
//
//  Created by Douglas Taquary on 27/09/2017.
//  Copyright © 2017 Douglas Taquary. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController {
    
    @IBOutlet weak var payloadDescription: UILabel!
    
    var detectedMessages = [NFCNDEFMessage]()
    var session: NFCNDEFReaderSession?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payloadDescription.text = "Clique para iniciar a leitura!\n🕵🏻"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func beginingScan(_ sender: Any) {
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        
        payloadDescription.text = "Clique para iniciar a leitura!"
        
        session?.begin()
    }
    
    
}


extension ViewController: NFCNDEFReaderSessionDelegate {
    
    //Read Fail
    
    func readerSession(_ session: NFCNDEFReaderSession,
                       didInvalidateWithError error: Error) {
        
        // Check invalidation reason from the returned error. A new session instance is required to read new tags.
        if let readerError = error as? NFCReaderError {
            // Show alert dialog box when the invalidation reason is not because of a read success from the single tag read mode,
            // or user cancelled a multi-tag read mode session from the UI or programmatically using the invalidate method call.
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alertController = UIAlertController(title: "Sessão inválida!", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    // Read Ok
    
    func readerSession(_ session: NFCNDEFReaderSession,
                       didDetectNDEFs messages: [NFCNDEFMessage]) {
        
        let infoTag = messages[0]
        
        payloadDescription.text = "🎉"
        print("Payload: \n\(infoTag)")
    }
    
}

