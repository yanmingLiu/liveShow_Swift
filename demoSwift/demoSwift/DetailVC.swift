//
//  DetailVC.swift
//  demoSwift
//
//  Created by yons on 17/2/7.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var live: UserCellModel!
    var playerView: UIView!
    var ijkPlayer: IJKMediaPlayback!
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var giftBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var imgBack: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBg()
        
        setPlayer()
        
        bringViewToFront()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.ijkPlayer.isPlaying() {
            ijkPlayer.prepareToPlay()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: 播放器
    func setPlayer()  {
        self.playerView = UIView(frame: view.bounds)
        view.addSubview(self.playerView)
        
        ijkPlayer = IJKFFMoviePlayerController(contentURLString: live.url, with: nil)
        let pv = ijkPlayer.view!
        
        pv.frame = playerView.bounds
        pv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerView.insertSubview(pv, at: 1)
        ijkPlayer.scalingMode = .aspectFill
    }
    
    // MARK: 模糊图片
    func setBg()  {
        let imgUrl = URL(string: live.portrait)
        imgBack.kf.setImage(with: imgUrl)
        
        let blurEffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = imgBack.bounds
        imgBack.addSubview(effectView)
        
    }
    
    func bringViewToFront()  {
        view.bringSubview(toFront: backBtn)
        view.bringSubview(toFront: giftBtn)
        view.bringSubview(toFront: likeBtn)
    }
    
    // MARK: 送礼物
    @IBAction func giftBtnAction(_ sender: Any) {
        
        let time = 3.0
        let giftView = UIImageView(image: #imageLiteral(resourceName: "porsche"))
        giftView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        view.addSubview(giftView)
        
        let giftViewW: CGFloat = 250
        let giftViewH: CGFloat = 125
        
        UIView.animate(withDuration: time) { 
            giftView.frame = CGRect(x: self.view.center.x - giftViewW/2, y: self.view.center.y - giftViewH/2, width: giftViewW, height: giftViewH)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: { 
            UIView.animate(withDuration: time, animations: { 
                giftView.alpha = 0
            }, completion: { (completed) in
                giftView.removeFromSuperview()
            })
        })
        
        // MARK: 烟花效果
        let layerFw = CAEmitterLayer()
        view.layer.addSublayer(layerFw)
        emmitParticles(from: (sender as AnyObject).center, emitter: layerFw, in: view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time * 2) {
            layerFw.removeFromSuperlayer()
        }
    }
    
    // MARK: 喜欢
    @IBAction func likeBtnAction(_ sender: Any) {
        
        // ❤️特效
        let heart = DMHeartFlyView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        heart.center = CGPoint(x: likeBtn.frame.origin.x, y: likeBtn.frame.origin.y)
        view.addSubview(heart)
        heart.animate(in: view)
        
        // 按钮变化动画
        let btnAnime = CAKeyframeAnimation(keyPath: "transform.scale")
        btnAnime.values = [1.0,0.7,0.5,0.3,0.5,0.7,1.0,1.2,1.4,1.2,1.0]
        btnAnime.keyTimes = [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
        btnAnime.duration = 0.2
        (sender as AnyObject).layer.add(btnAnime,forKey: "SHOW")
        
    }
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.ijkPlayer.shutdown()
        }
    }

}
