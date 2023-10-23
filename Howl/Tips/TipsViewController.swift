//
//  TipsViewController.swift
//  Howl
//
//  Created by apple on 23/10/23.
//

import UIKit
import WebKit

class TipsViewController: UIViewController, WKNavigationDelegate, WKUIDelegate  {
    
//MARK: - Outlet
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var dismissBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _loadWebVew()
        let buttonsToRound: [UIButton] = [homeBtn, refreshBtn, forwardBtn, backBtn, dismissBtn]
        let cornerRadius: CGFloat = 15
        
        
        for button in buttonsToRound {
            button.layer.cornerRadius = cornerRadius
            button.layer.masksToBounds = true
        }
        
    }
    
    func _loadWebVew(){
        if Reachability.isConnectedToNetwork() {
            if let url = URL(string: WebURLs.tips) {
                let request = URLRequest(url: url)
                let preferences = WKPreferences()
                preferences.javaScriptCanOpenWindowsAutomatically = true
                let configuration = WKWebViewConfiguration()
                configuration.preferences = preferences
                webView.allowsBackForwardNavigationGestures = false
                webView.navigationDelegate = self
                webView.uiDelegate = self
                webView.load(request)
            }else{
                let alert = UIAlertController(title: DogConstantString.networkErrorTitle, message: DogConstantString.networkErrorMsg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

//    MARK: - Btn Action
    @IBAction func navigateManuallyBtnPress(_ sender: UIButton) {
        switch sender.tag {
            
        case 0:
            
            if webView.canGoBack {
                webView.goBack()
            }
            
        case 1:
            
            if webView.canGoForward {
                webView.goForward()
            }
            
        case 2:
            
            webView.reload()
            
        case 3:
            let urlString = WebURLs.tips
            let url = URL(string: urlString)
            webView.load(URLRequest(url: url!))
            
        default:
            ()
        }
    }
    
    
    @IBAction func backBtnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    

   

}
