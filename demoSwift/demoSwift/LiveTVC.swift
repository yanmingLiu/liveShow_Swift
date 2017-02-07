//
//  LiveTVC.swift
//  demoSwift
//
//  Created by yons on 17/2/6.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit
import Just
import Kingfisher

class LiveTVC: UITableViewController {
    
    let url = "http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=5&multiaddr=1"
    
    var list : [UserCellModel] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadList()
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadList), for: .valueChanged)
    }


    func loadList()  {
        Just.post(url) { (r) in
            guard let json = r.json as? NSDictionary else {
                return
            }
            
            let lives = YKLiveStream(fromDictionary: json).lives!
            
            self.list = lives.map({ (live) -> UserCellModel in
                return UserCellModel(portrait: live.creator.portrait, nick: live.creator.nick, location: live.city, viewers: live.onlineUsers, url: live.streamAddr)
            })
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserCell
        
        let live = list[indexPath.row]
        
        
        cell.labelAddr.text = live.location
        cell.labelNick.text = live.nick
        cell.labelViewers.text = "\(live.viewers)"
        
        let imgUrl = URL(string: live.portrait)
        cell.imgPor.kf.setImage(with: imgUrl)
        
        cell.imgPor.layer.cornerRadius = 30.0;
        cell.imgPor.layer.masksToBounds = true
        
        cell.imgBigPor.kf.setImage(with: imgUrl)

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        navigationController?.setToolbarHidden(true, animated: true)
        
        let dvc = segue.destination as! DetailVC
        
        dvc.live = list[(tableView.indexPathForSelectedRow?.row)!]
        
    }
    

    

}
