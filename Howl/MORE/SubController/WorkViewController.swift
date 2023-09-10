//
//  WorkViewController.swift
//  Howl
//
//  Created by apple on 07/09/23.
//

import UIKit
import WebKit

class WorkViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
//MARK: - Outlet
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var dismissBtn: UIButton!
    
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        if let url = URL(string: "https://www.howlforhelp.com/how-it-works") {
            let request = URLRequest(url: url)
            let preferences = WKPreferences()
            preferences.javaScriptCanOpenWindowsAutomatically = true
            let configuration = WKWebViewConfiguration()
            configuration.preferences = preferences
            webView.allowsBackForwardNavigationGestures = false
            webView.navigationDelegate = self
            webView.uiDelegate = self
            webView.load(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
//    MARK: - SetUI
    func setUI(){
        setCornerRadius(to: homeBtn)
        setCornerRadius(to: refreshBtn)
        setCornerRadius(to: forwardBtn)
        setCornerRadius(to: backBtn)
        setCornerRadius(to: dismissBtn)
    }
    
//    MARK: - SetCorner Radius
    func setCornerRadius(to Button: UIButton){
        Button.layer.cornerRadius = 15.0
        Button.clipsToBounds = true
    }

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
            let urlString = "https://www.howlforhelp.com/how-it-works"
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
