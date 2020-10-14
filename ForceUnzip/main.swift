import Foundation
import ZIPFoundation

let prefix = "[ForeUnzip]"
let startTime = CFAbsoluteTimeGetCurrent()
print("\(prefix) starting v.1.0.2")

let sourceUrl: URL = {
    return URL(fileURLWithPath: "/Users/us/Downloads/Media-Pack")
   // return URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
}()
print("\(prefix) current Path: \(sourceUrl.absoluteString)")

let unzip = RecursiveUnzip(sourceUrl)
let grouper = FileGrouper(sourceUrl)

let groups = grouper.result
print("[DEBUG] printing group keys and values")
print(groups)

let duration = round(CFAbsoluteTimeGetCurrent() - startTime)
print("\(prefix) ---------------\n\(prefix) finished after \(duration) seconds")
