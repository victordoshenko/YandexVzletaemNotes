//
//  GalleryViewController.swift
//  Yandex49
//
//  Created by Victor Doshchenko on 19/07/2019.
//

import UIKit

class GalleryViewController: UIViewController, UIScrollViewDelegate
{
    
    @IBOutlet weak var scrollView: UIScrollView!
    var imgArray = [UIImage]()
    var passedContentOffset = IndexPath()
    var imageViews = [UIImageView]()

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.delegate = self

        for image in imgArray {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
        scrollView.scrollToPage(index: UInt8(passedContentOffset.row), animated: false, after: 0)
        scrollView.isDirectionalLockEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame.size = scrollView.frame.size
            imageView.frame.origin.x = scrollView.frame.width * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        let contentWidth = scrollView.frame.width * CGFloat(imageViews.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
    }
}

extension UIScrollView {
    func scrollToPage(index: UInt8, animated: Bool, after delay: TimeInterval) {
        let offset: CGPoint = CGPoint(x: CGFloat(index) * frame.size.width, y: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.setContentOffset(offset, animated: animated)
        })
    }
}
