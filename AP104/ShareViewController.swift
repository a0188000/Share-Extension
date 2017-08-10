//
//  ShareViewController.swift
//  AP104
//
//  Created by EVERTRUST on 2017/8/10.
//  Copyright © 2017年 EVERTRUST. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    var listCount: Int = 0
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {

        guard let inputItem: [NSExtensionItem] = self.extensionContext?.inputItems as? [NSExtensionItem] else { return }
        for item in inputItem {
            guard let attachments = item.attachments as? [NSItemProvider] else { return }
            for itemProvider in attachments {
                if itemProvider.hasItemConformingToTypeIdentifier("public.image") {
                    itemProvider.loadItem(forTypeIdentifier: "public.image", options: nil,  completionHandler: { (item, error) in
                        if (error != nil) {
                            print("error:\(error.localizedDescription)")
                        }
                        let image = UIImage(data: NSData(contentsOf: item as! URL)! as Data)
                        if image != nil {
                            DispatchQueue.main.async {
                                self.writeFileToFileManager(image: image!)
                            }
                            
                        } else {
                            print("done fail")
                        }
                        
                    })
                } else {
                    print("type error")
                }
                
            }
        }
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    func getDocumentsDirectory() -> URL? {
        
        guard let directoryPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ExtensionFileManager") else {
            print("找不到")
            return nil
        }
        let directoryPathString = directoryPath.absoluteString.replacingOccurrences(of: "file://", with: "")
        let imageDirectoryPath = directoryPathString.appending("image")
        print("\(directoryPath)")
        if !FileManager.default.fileExists(atPath: imageDirectoryPath) {
            do {
                try FileManager.default.createDirectory(atPath: imageDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("創建資料夾失敗")
            }
            
        } else {
            print("資料夾以存在")
        }
        do {
            let list = try FileManager.default.contentsOfDirectory(atPath: imageDirectoryPath)
            for file in list {
                if file != ".DS_Store" {
                    listCount += 1
                }
            }
        } catch {
            print("not fend")
        }
        return directoryPath.appendingPathComponent("image")
    }
    
    func writeFileToFileManager(image: UIImage) {
        guard let path = self.getDocumentsDirectory()?.appendingPathComponent(fileName()) else { return }
        
        let imageData = UIImagePNGRepresentation(image)
        do {
            try imageData?.write(to: path)
            print("write done")
        } catch {
            print("write fail")
        }
    }
    
    func fileName() -> String{
        return "copy".appending(String(listCount + 1)) + ".png"
    }
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
