//
//  SplashViewController.swift
//  AudioVideo
//
//  Created by CoderGeasy on 08/03/23.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var imvSplash: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imvSplash.frame.origin.y = view.frame.height
        imvSplash.frame.origin.x = (view.frame.width - imvSplash.frame.width)/2.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveLinear) {
            self.imvSplash.frame.origin.y = (self.view.frame.height - self.imvSplash.frame.height) / 2.0
        } completion: { res in
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                self.performSegue(withIdentifier: "sgSplash", sender: nil)
            }
        }
    }

}
