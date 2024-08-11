//
//  ViewController.swift
//  CircularSeekBar
//
//  Created by Ankita Thakur on 11/08/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let circularSeekBar = CircularSeekBar()

      override func viewDidLoad() {
          super.viewDidLoad()
          
          setupCircularSeekBar()
      }
      
      private func setupCircularSeekBar() {
          circularSeekBar.translatesAutoresizingMaskIntoConstraints = false
          circularSeekBar.backgroundColor = .clear
          circularSeekBar.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
          
          view.addSubview(circularSeekBar)
          
          NSLayoutConstraint.activate([
              circularSeekBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              circularSeekBar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
              circularSeekBar.widthAnchor.constraint(equalTo: view.widthAnchor),
              circularSeekBar.heightAnchor.constraint(equalToConstant: 300)
          ])
      }
      
      @objc private func valueChanged(_ sender: CircularSeekBar) {
          print("Value changed: \(sender.value)")
      }

}

