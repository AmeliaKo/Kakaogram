//
//  FeedDetailViewController.swift
//  kakaogram
//
//  Created by UramMyeongbu on 2018. 7. 22..
//  Copyright © 2018년 myeongbu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import AVKit
import AVFoundation

class FeedDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    var disposeBag = DisposeBag()
    var item : InstagramData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setDelegate()
        setupMedia()
        setupText()
    }
}

extension FeedDetailViewController {
    func setDelegate() {
        scrollView.delegate = self
    }
    
    func setupMedia() {
        var mediaCount : Int = 0;
        switch (item.mediaType) {
        case .Image, .Video:
            mediaCount = 1
        case .Carousel:
            mediaCount = item.carousel_media.count
        default: break
        }
        
        pageControl.numberOfPages = mediaCount
        scrollView.contentSize.width = scrollView.frame.width * CGFloat(mediaCount)
        
        var positionX : CGFloat = 0;
        
        if(item.mediaType == .Image) {
            addImage(item.image, positionX)
        } else if (item.mediaType == .Video) {
            addVideo(item.video, positionX)
        } else if (item.mediaType == .Carousel) {
            for media in item.carousel_media {
                if let imageData = media.images {
                    addImage(imageData, positionX)
                } else if let videoData = media.videos {
                    addVideo(videoData, positionX)
                }
                positionX += scrollView.frame.width
            }
        }
    }
    
    func setupText() {
        if let text = item.caption?.text {
            textView.text = text
        }
    }
    
    func addImage(_ imageData : Image, _ positionX : CGFloat) {
        let imageView = UIImageView.init(frame: CGRect.init(x: positionX, y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
        imageView.af_setImage(withURL: URL.init(string: imageData.url)!)
        
        scrollView.addSubview(imageView)
    }
    
    func addVideo(_ videoData : Video, _ positionX : CGFloat) {
        player = AVPlayer.init(url: URL.init(string: videoData.url)!)
        playerController = AVPlayerViewController.init()
        
        playerController.player = player
        playerController.view.frame = CGRect.init(x: positionX, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        scrollView.addSubview(playerController.view)
        player.play()
    }
}

extension FeedDetailViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("\(#function)")
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
