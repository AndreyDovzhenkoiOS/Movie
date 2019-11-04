//
//  LoadingImageView.swift
//  Movie
//
//  Created by Andrey on 11/4/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class LoadingImageView: UIImageView {

    let cache = NSCache <NSString, UIImage>()

    private let loadingView = LoadingView().thenUI {
        $0.color = Asset.lightGreen.color
        $0.lineWidth = 4
        $0.isHidden = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLoadingView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadImage(_ url: URL) {
        setupLoadingView(isShow: true)
        if let image = cache.object(forKey: (url.absoluteString) as NSString) {
            self.image = image
            setupLoadingView(isShow: false)
        } else {
            downloadImage(url)
        }
    }

    private func downloadImage(_ url: URL) {
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let downloadImage = UIImage(data: data) else {
                return
            }
            self?.cache.setObject(downloadImage, forKey: (url.absoluteString) as NSString )
            DispatchQueue.main.async {
                self?.image = downloadImage
                self?.setupLoadingView(isShow: false)
            }
        }
        dataTask.resume()
    }

    private func configureLoadingView() {
        addSubview(loadingView)
        loadingView.height(80).aspectRatio().centerX().centerY(-20)
    }

    private func setupLoadingView(isShow: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isShow ?
                self.loadingView.startAnimating() :
                self.loadingView.stopAnimating()
        }
    }
}
