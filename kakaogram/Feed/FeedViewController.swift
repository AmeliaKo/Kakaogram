//
//  ViewController.swift
//  kakaogram
//
//  Created by UramMyeongbu on 2018. 7. 21..
//  Copyright © 2018년 myeongbu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage
import ObjectMapper

class FeedViewController: UIViewController {
    
    @IBOutlet weak var channelScrollView: UIScrollView!
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    var serverItems : [InstagramData]!
    
    let tagArray = ["popular", "food" , "dog" , "cat" , "kakao"]
    var tagButtons : [UIButton]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setDelegate()
        
        bindTagButton()
        bindTagButtonTapped()
        bindCollectionViewCellTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRecentMedia(url: String(format: INSTAGRAM_IOS.RECENT_MEDIA, INSTAGRAM_IOS.ACCESSTOKEN))
    }
    
}

extension FeedViewController {
    func setDelegate() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        feedCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func getRecentMedia(url urlString : String)
    {
        guard let url = URL.init(string: urlString) else { return }
        
        Alamofire.request(url).responseJSON {[weak self] response in
            guard let `self` = self else { return }
            
            switch response.result {
            case .success( _):
                print(response)
                if let data = Mapper<JSONData>().map(JSONObject: response.result.value) {
                    self.serverItems = data.data
                    self.bindData(Observable.just(data.data))
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func bindTagButton() {
        var positionX : CGFloat = 10;
        
        for i in 0 ..< 5 {
            let channelButton : UIButton = UIButton.init()
            channelButton.frame = CGRect.init(x: positionX, y: 5, width: 80, height: 80)
            channelButton.backgroundColor = UIColor.gray
            channelButton.setTitle("\(tagArray[i])", for: .normal)
            channelButton.layer.cornerRadius = 80 / 2
            channelButton.clipsToBounds = true
            
            channelScrollView.addSubview(channelButton)
            channelScrollView.contentSize = CGSize.init(width: channelButton.frame.origin.x + channelButton.frame.width + 10, height: channelScrollView.contentSize.height)
            positionX += channelButton.frame.width + 10
            
            tagButtons.append(channelButton)
        }
    }
    
    func bindData(_ items : Observable<[InstagramData]>) {
        feedCollectionView.dataSource = nil
        items.bind(to: feedCollectionView.rx.items(cellIdentifier: "cell")){ (row, data, cell) in
            if let cell = cell as? FeedCollectionViewCell {
                cell.imageView.image = nil
                cell.imageView.af_setImage(withURL: URL.init(string: data.image.url)!)

            }
        }.disposed(by: disposeBag)
    }
    
    func bindTagButtonTapped() {
        for button in tagButtons {
            button.rx.tap.map {
                button.titleLabel?.text
                }.subscribe(onNext: { [weak self] (title) in
                    guard let `self` = self else { return }
                    self.getRecentMedia(url: String.init(format: INSTAGRAM_IOS.SEARCH_TAG, title!, INSTAGRAM_IOS.ACCESSTOKEN))
                }).disposed(by: disposeBag)
        }
    }
    
    func bindCollectionViewCellTapped() {
        feedCollectionView.rx.itemSelected
            .asObservable().subscribe(onNext: { [weak self] (indexPath) in
                guard let `self` = self else { return }
                guard let detailVC : FeedDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetail") as? FeedDetailViewController
                    else { return }
                
                detailVC.item = self.serverItems[indexPath.row]
                self.navigationController?.pushViewController(detailVC, animated: true)
                
            }).disposed(by: disposeBag)
    }
}

extension FeedViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellsAcross: CGFloat = 3
        let spaceBetweenCells: CGFloat = 2
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        return CGSize(width: dim, height: dim)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}

extension UIViewController : UIGestureRecognizerDelegate {
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool { return true }
}





