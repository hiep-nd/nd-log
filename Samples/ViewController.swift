//
//  ViewController.swift
//  Samples
//
//  Created by Nguyen Duc Hiep on 11/10/20.
//

import UIKit
import JustLog

class ViewController: UIViewController {
  var task: URLSessionStreamTask!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

//    task = URLSession.shared.streamTask(withHostName: "localhost", port: 5044)
////    task.startSecureConnection()
////    task.st
//    task.write("Hello elk!".data(using: .utf8)!, timeout: 30) {
//      if let err = $0 {
//        print("Error: \(err).")
//      } else {
//        print("Ok!")
//      }
//    }
//    task.closeWrite()
//    task.resume()

    let logger = Logger.shared

    // file destination
    logger.logFilename = "justeat-demo.log"

    // logstash destination
    logger.logstashHost = "localhost"
    logger.logstashPort = 5044
    logger.logstashTimeout = 5
    logger.logLogstashSocketActivity = true

    // default info
    logger.defaultUserInfo = ["app": "my iOS App",
                              "environment": "production",
                              "tenant": "UK",
                              "sessionID": "someSessionID"]
    logger.setup()

    Logger.shared.verbose("not so important")
    Logger.shared.debug("something to debug")
    Logger.shared.info("a nice information", userInfo: ["some key": "some extra info"])
    Logger.shared.warning("oh no, that won’t be good", userInfo: ["some key": "some extra info"])
    Logger.shared.error("ouch, an error did occur!", error: NSError(), userInfo: ["some key": "some extra info"])
  }

  let vc1 = ViewController1()
  let vc2 = ViewController1()
  let vc3 = ViewController1()

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//
//    vc1.modalPresentationStyle = .fullScreen
//    vc2.modalPresentationStyle = .fullScreen
//    vc3.modalPresentationStyle = .fullScreen

    self.present(vc1, animated: true) {
      self.vc1.present(self.vc2, animated: true) {
        self.vc2.present(self.vc3, animated: true) {
          print("Done!")
        }
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    vc1.dismiss(animated: true)
  }
}

class ViewController1: UIViewController {
//  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
//    super.dismiss(animated: flag, completion: completion)
//  }
  override func viewWillDisappear(_ animated: Bool) {
    print(self.isBeingDismissed)
    super.viewWillDisappear(animated)
    print(self.isBeingDismissed)
  }

  override func viewDidDisappear(_ animated: Bool) {
    print(self.isBeingDismissed)
    super.viewDidDisappear(animated)
    print(self.isBeingDismissed)
  }
}
