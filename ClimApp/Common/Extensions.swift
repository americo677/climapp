//
//  Extensions.swift
//  ClimApp
//
//  Created by Américo Cantillo Gutiérrez on 5/07/21.
//

import Foundation
import UIKit
import StoreKit

extension UIViewController {
    
    // MARK: - Alerta personalizada
    func showCustomAlert(_ vcSelf: UIViewController!, titleApp: String, strMensaje: String, toFocus: UITextField?) {
        let alertController = UIAlertController(title: titleApp, message:
                                                    strMensaje, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.cancel,handler: {_ in
            
            if toFocus != nil {
                toFocus!.becomeFirstResponder()
            }
        })
        
        alertController.addAction(action)
        
        vcSelf.present(alertController, animated: true, completion: nil)
    }

}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
