//
//  VideosTableViewController.swift
//  AudioVideo
//
//  Created by imac on 08/03/23.
//

import UIKit
import AVKit
import youtube_ios_player_helper

class VideosTableViewController: UITableViewController, YTPlayerViewDelegate {
    var videos:[URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videos = [URL(fileURLWithPath: Bundle.main.path(forResource: "Muse - Starlight", ofType: "mp4")!), URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let ytpVideo = YTPlayerView()
            let altura = view.frame.width * 0.67
            ytpVideo.frame = CGRect(x: 0, y: (view.frame.height - altura) / 2.0, width: view.frame.width, height: altura)
            ytpVideo.backgroundColor = .black
            view.addSubview(ytpVideo)
            ytpVideo.load(withVideoId: "1VsfWqiSBBg")
            ytpVideo.delegate = self
        } else {
            let reproductor = AVPlayer(url: videos[indexPath.section])
            let pVC = AVPlayerViewController()
            
            pVC.player = reproductor
            self.present(pVC, animated: true) {
                reproductor.play()
                
            }
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {

        if state == .paused {
            playerView.removeFromSuperview()
        }
    }
}
