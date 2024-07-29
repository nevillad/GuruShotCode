//
//  ChildAViewController.swift
//  HomeTest-GuruShots
//
//  Created by Nevil on 7/21/24.
//

import UIKit

class ChildAViewController: UIViewController {

    let coinImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "coin"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(coinImageView)
        NSLayoutConstraint.activate([
            coinImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            coinImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 25),
            coinImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}

