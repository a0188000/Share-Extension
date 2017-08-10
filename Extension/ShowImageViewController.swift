//
//  ShowImageViewController.swift
//  Extension
//
//  Created by EVERTRUST on 2017/8/10.
//  Copyright © 2017年 EVERTRUST. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    var filePath: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(filePath)")
        show()
    }

    func show() {
        guard let path = filePath else { return }
        myImageView.image = UIImage(contentsOfFile: path)
        print("\(NSTemporaryDirectory())")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
