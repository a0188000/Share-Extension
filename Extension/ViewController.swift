//
//  ViewController.swift
//  Extension
//
//  Created by EVERTRUST on 2017/8/10.
//  Copyright © 2017年 EVERTRUST. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var directoryPath: String!
    var filesName = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gitFilesName()
        setReloadBtn()
        setNotification()
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    func setReloadBtn() {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 24)
        btn.setTitle("reload", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(reload), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func reload() {
        if filesName.count > 0 {
            filesName.removeAll()
        }
        gitFilesName()
        tableView.reloadData()
    }
    
    func gitFilesName() {
        guard let directoryPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ExtensionFileManager") else {
            print("找不到app group")
            return
        }
        
        let directoryPathString = directoryPath.absoluteString.replacingOccurrences(of: "file://", with: "")
        let imageDirectoryPath = directoryPathString.appending("image/")
        self.directoryPath = imageDirectoryPath
        do {
            let list = try FileManager.default.contentsOfDirectory(atPath: imageDirectoryPath)
            for file in list {
                if file != ".DS_Store" {
                    filesName.append(file)
                }
            }
        } catch {
            print("not fend")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filesName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = filesName[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let showVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowImageViewController") as? ShowImageViewController else { return }
        showVC.filePath = directoryPath.appending(filesName[indexPath.row])
        navigationController?.pushViewController(showVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let file = directoryPath.appending(filesName[indexPath.row])
                try FileManager.default.removeItem(atPath: file)
                filesName.remove(at: indexPath.row)
                self.tableView.reloadData()
            } catch {
                print("error")
            }
            
        }
    }
}


