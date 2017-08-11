//
//  ShowImageViewController.swift
//  Extension
//
//  Created by EVERTRUST on 2017/8/10.
//  Copyright © 2017年 EVERTRUST. All rights reserved.
//

import UIKit
import WebKit
class ShowImageViewController: UIViewController {
    
    @IBOutlet weak var myImageView: UIImageView!
    var filePath: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let type = filePath.components(separatedBy: ".").last
        if type == "pdf" {
            openPDF()
            title = "是PDF"
            view.sendSubview(toBack: myImageView)
        } else {
            title = "是圖片"
            showImage()
        }
    }
    
    func showImage() {
        guard let path = filePath else { return }
        myImageView.image = UIImage(contentsOfFile: path)
    }
    
    func openPDF() {
        let webView = WKWebView(frame: CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height))
        view.addSubview(webView)
        guard let path = filePath else { return }
        let url = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: url)
        webView.load(data!, mimeType: "application/pdf", characterEncodingName: "", baseURL: url.deletingLastPathComponent())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
