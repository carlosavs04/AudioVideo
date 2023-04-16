//
//  WebViewController.swift
//  AudioVideo
//
//  Created by imac on 08/03/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webPage: WKWebView!
    @IBOutlet weak var vwLoading: UIView!
    var pagina:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webPage.load(URLRequest(url: URL(string: pagina!)!))
        webPage.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        vwLoading.isHidden = true
    }
    
    @IBAction func regresar() {
        self.dismiss(animated: true)
    }
    
}
