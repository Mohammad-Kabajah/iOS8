//
//  ViewController.swift
//  Cassini
//
//  Created by Mohammad Kabajah on 9/1/15.
//  Copyright (c) 2015 Mohammad Kabajah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ivc = segue.destination as? ImageViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "Earth":
                    ivc.imageURL = DemoURL.NASA.Earth
                    ivc.title = "Earth"
                case "Saturn":
                    ivc.imageURL = DemoURL.NASA.Saturn
                    ivc.title = "Saturn"
                case "Cassini":
                    ivc.imageURL = DemoURL.NASA.Cassini
                    ivc.title = "Cassini"
                case "UNI":
                    ivc.imageURL = DemoURL.Stanford
                    ivc.title = "Stanford"
                default: break
                }
            }
        }
    }

}

