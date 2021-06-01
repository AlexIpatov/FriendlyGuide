//
//  UIViewController + Extensions.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 25.05.2021.
//

import UIKit



extension UIViewController {

    // MARK: - Alert
    func showAlert(needСancellation: Bool = false,
                   with title: String,
                   and message: String,
                   completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        if needСancellation {
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            alertController.addAction(cancelAction)
        }
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - Configure func for set up collection view
    func configure<T: SelfConfiguringCell, U: Hashable>(collectionView: UICollectionView,
                                                        cellType: T.Type,
                                                        with value: U,
                                                        for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId,
                                                            for: indexPath) as? T else { fatalError() }
        cell.configure(with: value)
        return cell
    }
}


protocol ErrorAllertPresentable {
    func showErrorAlert(title: String, error: Error, actions: [UIAlertAction])
}

extension UIViewController: ErrorAllertPresentable {
    func showErrorAlert(title: String, error: Error, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title,
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true, completion: nil)
    }
}
