//
//  MainViewController.swift
//  HomeTest-GuruShots
//
//  Created by Nevil on 7/21/24.
//

import UIKit
import Combine

class MainViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up childA (yellow) view controller
        let childAViewController = ChildAViewController()
        addChild(childAViewController)
        view.addSubview(childAViewController.view)
        childAViewController.didMove(toParent: self)
        childAViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childAViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            childAViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childAViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childAViewController.view.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Set up childB (red) view controller
        let childBViewController = ChildBViewController()
        addChild(childBViewController)
        view.addSubview(childBViewController.view)
        childBViewController.didMove(toParent: self)
        childBViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childBViewController.view.topAnchor.constraint(equalTo: childAViewController.view.bottomAnchor),
            childBViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childBViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childBViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Subscribe to the notification from ChildBViewController
        NotificationCenter.default.publisher(for: .coinTapped)
            .sink { [weak self] _ in
                self?.animateCoin()
            }
            .store(in: &cancellables)
    }

    private func animateCoin() {
        Task {
            await animateBlueViewBorderAndOpacity()
            await animateCoinScale()
            await moveCoinToYellowView()
        }
    }

    private func animateBlueViewBorderAndOpacity() async {
        guard let childBViewController = children.first(where: { $0 is ChildBViewController }) as? ChildBViewController else {
            return
        }

        let blueView = childBViewController.blueView
        await withCheckedContinuation { continuation in
            UIView.animate(withDuration: 1.5, animations: {
                
                // Layer animation
                let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
                borderWidthAnimation.fromValue = 5
                borderWidthAnimation.toValue = 20
                borderWidthAnimation.duration = 1.5

                let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
                borderColorAnimation.fromValue = UIColor.lightGray.cgColor
                borderColorAnimation.toValue = UIColor.clear.cgColor
                borderColorAnimation.duration = 1.5

                blueView.layer.add(borderWidthAnimation, forKey: "borderWidth")
                blueView.layer.add(borderColorAnimation, forKey: "borderColor")

                // Final values to set
                blueView.layer.borderWidth = 20
                blueView.layer.borderColor = UIColor.clear.cgColor

                // Change opacity for the label opacity same along with border sink and fades
                childBViewController.congratulationsLabel.layer.opacity = 0

            }) { _ in
                continuation.resume()
            }
        }
    }
    private func animateCoinScale() async {
        guard let childBViewController = children.first(where: { $0 is ChildBViewController }) as? ChildBViewController else {
            return
        }

        let coinImageView = childBViewController.coinImageView
        await withCheckedContinuation { continuation in
            UIView.animate(withDuration: 0.5, animations: {
                coinImageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            }) { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    coinImageView.transform = CGAffineTransform.identity
                }) { _ in
                    continuation.resume()
                }
            }
        }
    }

    private func repeatanimateCoinScale() async {
        guard let childBViewController = children.first(where: { $0 is ChildBViewController }) as? ChildBViewController else {
            return
        }

        let coinImageView = childBViewController.coinImageView
        await withCheckedContinuation { continuation in
            UIView.animate(withDuration: 0.5, animations: {
                coinImageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            }) { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    coinImageView.transform = CGAffineTransform.identity
                }) { _ in
                    continuation.resume()
                }
            }
        }
    }

    private func moveCoinToYellowView() async {
        guard let childAViewController = children.first(where: { $0 is ChildAViewController }) as? ChildAViewController,
              let childBViewController = children.first(where: { $0 is ChildBViewController }) as? ChildBViewController else {
            return
        }

        let coinImageView = childBViewController.coinImageView

        // Calculate the final position of the coin in childAViewController
        var finalPosition = self.view.convert(childAViewController.coinImageView.center, from: childAViewController.coinImageView)
        //finalPosition.x = 100

        guard let childAViewController = children.first(where: { $0 is ChildAViewController }) as? ChildAViewController,
              let childBViewController = children.first(where: { $0 is ChildBViewController }) as? ChildBViewController else {
            return
        }

        // Convert coordinates to main view's coordinate space
        let coinAViewCenter = view.convert(childAViewController.coinImageView.center, from: childAViewController.view)
        let coinBViewCenter = view.convert(childBViewController.coinImageView.center, from: childBViewController.view)
        let coinBViewCenterToSuperView = view.convert(childBViewController.blueView.center, from: view)
        let abc = view.convert(childBViewController.coinImageView.frame.origin, from: view)

        childAViewController.coinImageView.frame.origin.x
        // Calculate the distance
        let dx = (coinBViewCenter.x + coinAViewCenter.x) - (childAViewController.coinImageView.frame.origin.x / 2 + childAViewController.coinImageView.frame.width/2)
        let dy = coinBViewCenter.y + coinAViewCenter.y

        finalPosition.y = -dy
        finalPosition.x = -dx
        // Animate the movement to the final position
        await withCheckedContinuation { continuation in
            UIView.animate(withDuration: 0.5, animations: {
                coinImageView.center = finalPosition
            }) { _ in
                continuation.resume()
            }
        }
    }

    private func showRandomMessage() async {
        guard let childBViewController = children.first(where: { $0 is ChildBViewController }) as? ChildBViewController else {
            return
        }

        let showMessage = Bool.random()
        if showMessage {
            await withCheckedContinuation { continuation in
                UIView.animate(withDuration: 1.5, animations: {
                    childBViewController.congratulationsLabel.alpha = 1
                }) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        UIView.animate(withDuration: 1.5, animations: {
                            childBViewController.congratulationsLabel.alpha = 0
                        }) { _ in
                            continuation.resume()
                        }
                    }
                }
            }
        }
    }
}

extension Notification.Name {
    static let coinTapped = Notification.Name("coinTapped")
}
