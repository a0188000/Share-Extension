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
    var fileName: String!
    
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
                    itemProvider.loadItem(forTypeIdentifier: "public.image", options: nil,  completionHandler: { (item: NSSecureCoding?, error: Error!) in
                        self.fileName = (item as! URL).lastPathComponent
                        self.writeFileToFileManager(item: item)
                    })
                } else if itemProvider.hasItemConformingToTypeIdentifier("com.adobe.pdf") {
                    itemProvider.loadItem(forTypeIdentifier: "com.adobe.pdf", options: nil, completionHandler: { (item: NSSecureCoding?, error: Error!) in
                        self.writePDFToFileManager(item: item)
                    })
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
        return directoryPath.appendingPathComponent("image")
    }
    
    func writeFileToFileManager(item: NSSecureCoding?) {
        guard let url = item as? URL else { return }
        do {
            let data = try Data(contentsOf: url)
            let image = try UIImage(data: data)
            if let image = image {
                guard let path = self.getDocumentsDirectory()?.appendingPathComponent(fileName) else { return }
                let imageData = UIImagePNGRepresentation(image)
                try imageData?.write(to: path)
            }
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    func writePDFToFileManager(item: NSSecureCoding?) {
        let pdfPath = item as! URL
        self.fileName = pdfPath.lastPathComponent
        var filePath = self.getDocumentsDirectory()?.appendingPathComponent(self.fileName).absoluteString
        filePath = filePath?.replacingOccurrences(of: "file://", with: "")
        let finalPath = URL(fileURLWithPath: filePath!)
        do {
            try FileManager.default.copyItem(at: pdfPath, to: finalPath)
        } catch {
            print("可惡")
        }
    }
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
}
