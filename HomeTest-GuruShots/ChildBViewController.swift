//
//  ChildBViewController.swift
//  HomeTest-GuruShots
//
//  Created by Nevil on 7/21/24.
//

import UIKit

class ChildBViewController: UIViewController {

    let blueView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()

    let coinImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "coin"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let congratulationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Congratulations"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 1.0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(blueView)
        blueView.addSubview(coinImageView)
        blueView.addSubview(congratulationsLabel)

        NSLayoutConstraint.activate([
            blueView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blueView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            blueView.widthAnchor.constraint(equalToConstant: 150),
            blueView.heightAnchor.constraint(equalToConstant: 150),

            coinImageView.centerXAnchor.constraint(equalTo: blueView.centerXAnchor),
            coinImageView.centerYAnchor.constraint(equalTo: blueView.centerYAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 25),
            coinImageView.heightAnchor.constraint(equalToConstant: 25),

            congratulationsLabel.centerXAnchor.constraint(equalTo: blueView.centerXAnchor),
            congratulationsLabel.topAnchor.constraint(equalTo: blueView.topAnchor, constant: 20)
        ])

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(coinTapped))
        coinImageView.isUserInteractionEnabled = true
        coinImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func coinTapped() {
        NotificationCenter.default.post(name: .coinTapped, object: nil)
    }
}
