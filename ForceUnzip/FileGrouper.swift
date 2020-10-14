import Foundation

class FileGrouper {
    private var source: URL
    public var result: [String: [URL]] = [:]
    
    let fileEndings = [".png", ".gif"]
    
    
    
    init(_ source: URL) {
        self.source = source
        print("\(prefix) ---------------\n\(prefix) >>> running 'file grouper' job")
        run()
    }
    
    
    
    private func mapValidFilesToDict(_ path: String) {
        let fileNameArray = path.split(separator: "/").last?.split(separator: "-") ?? []
        
        if fileNameArray.count > 1 {
            let key = String(fileNameArray[0])
            var temp: [URL] = result[key] ?? []
            temp.append(URL(fileURLWithPath: path))
            result[key] = temp
            //renameFolder(path)
           // rename()
        }
    }
    
    func isMediaFile(_ path: String) -> Bool {
        print("\(prefix) file endings of compressed Files: \(fileEndings)")
        return fileEndings.first(where: { path.hasSuffix($0) }) != nil
    }
    
    
//    private func renameFolder(_ path: String){
//        print("\(prefix) currently at path: \(path)")
//        var fileNameArray = path.split(separator: "/").last?.split(separator: "_").first?.split(separator: "-") ?? []
//        let key = fileNameArray[0]
//        fileNameArray.removeFirst()
//        let name = fileNameArray.joined(separator: " ")
//        print("\(prefix) identified file name: \(name)")
//        
//        //old folder path
//        let  oldURL = source.appendingPathComponent("\(key)")
//        let tempSave = oldURL.deletingPathExtension()
//        print("\(prefix) old destination: \(tempSave.absoluteString)")
//        
//        //New Folder name
//        let newUrl = source.appendingPathComponent("\(name)")
//        print("\(prefix) new url: \(newUrl.absoluteString)")
//        
//        do {
//            try FileManager.default.createDirectory(atPath: newUrl.absoluteString, withIntermediateDirectories: true, attributes: nil)
//            print("\(prefix) copying files from \(oldURL.absoluteString) to \(newUrl.absoluteString)")
//            //            try FileManager.default.moveItem(atPath: oldURL.absoluteString, toPath: newUrl.absoluteString)
//            try FileManager.default.copyItem(at: oldURL, to: newUrl)
//            print("\(prefix) removing old folder \(oldURL.absoluteString) after copy")
//            try FileManager.default.removeItem(at: oldURL)
//            print("\(prefix) moved items successfully")
//        } catch let error {
//            print("\(prefix) Error: \(error.localizedDescription)")
//            fatalError()
//        }
//        
//    }
    
    
    private func rename(){
        print("\(prefix) ------ running renaming task ---------")
        for res in result{
            print("\(prefix) current key: \(res.key)")
            //old file path
            let oldUrl = source.appendingPathComponent(res.key)
            var newUrl = URL(fileURLWithPath: "")
            //let temp = oldUrl.deletingPathExtension()
            print("\(prefix) old file destination \(oldUrl.absoluteString)")
            if !res.value.isEmpty{
                var val = res.value[0]
                var fileNameArray = val.absoluteString.split(separator: "/").last?.split(separator: "_").first?.split(separator: "-") ?? []
                fileNameArray.removeFirst()
                let name = fileNameArray.joined(separator: " ")
                print("\(prefix) identified file name: \(name)")
                
                //new folder path
                newUrl = source.appendingPathComponent("\(name)")
                print("\(prefix) new url: \(newUrl.absoluteString)")
            }
            do {
                try FileManager.default.createDirectory(atPath: newUrl.absoluteString, withIntermediateDirectories: true, attributes: nil)
                print("\(prefix) copying files from \(oldUrl.absoluteString) to \(newUrl.absoluteString)")
                // try FileManager.default.moveItem(atPath: oldURL.absoluteString, toPath: newUrl.absoluteString)
                try FileManager.default.copyItem(at: oldUrl, to: newUrl)
                
                print("\(prefix) moved items successfully")
            } catch let error {
                print("\(prefix) Error: \(error.localizedDescription)")
                fatalError()
            }
            
            
            
            
        }
        removeOldFolders()
    }
    
    private func removeOldFolders(){
        for res in result{
            //old file path
            let oldUrl = source.appendingPathComponent(res.key)
            print("\(prefix) removing old folder \(oldUrl.absoluteString) after copy")
            do{
                try FileManager.default.removeItem(at: oldUrl)
            }
            catch{
                print("\(prefix) Error: \(error.localizedDescription)")
                fatalError()
            }
        }
    }
    
    private func run() {
        print("\(prefix) ---------------")
        
        let allFiles: [String] = (try? FileManager.default.subpathsOfDirectory(atPath: source.path)) ?? []
        print("\(prefix) found \(allFiles.count) files")
        
        allFiles.forEach {
            mapValidFilesToDict($0)
            
            
        }
        print("\(prefix) \(result.count) items in result dict: \(result)")

        rename()
        
        print("\(prefix) created \(result.count) valid groups")
        
    }
}
