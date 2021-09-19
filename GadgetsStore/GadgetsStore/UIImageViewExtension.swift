//
//  UIImageViewExtension.swift
//  GadgetsStore
//
//  Created by Vulisi Sahithi on 19/09/21.
//

import UIKit

extension UIImageView {
    func getImageFromURl(with urlString: String?) {
        guard let url = URL(string: urlString ?? "") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print("Error with fetching images: \(err)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                    self.contentMode = .scaleAspectFit
                }
            }
        }
        task.resume()
    }
}
