import Foundation

class RecursiveUnzip {
    private var fileEndings: [String]
    private var source: URL

    init(_ source: URL, _ fileEndings: [String] = [".ZIP", ".tgz",".zip"]) {
        self.source = source
        self.fileEndings = fileEndings

        print("\(prefix) >>> running 'recursive unzip' job")
        print("\(prefix) file endings of compressed Files: \(fileEndings)")
        run()
    }

    @inline(__always)
    private func canUnarchive(_ path: String) -> Bool {
        fileEndings.first(where: { path.hasSuffix($0) }) != nil
    }

    private func run() {
        print("\(prefix) ---------------")

        let allFiles: [String] = (try? FileManager.default.subpathsOfDirectory(atPath: source.path)) ?? []
        print("\(prefix) found \(allFiles.count) files")

        let startingFiles = allFiles.filter { canUnarchive($0) }
        print("\(prefix) found \(startingFiles.count) compressed files")

        if startingFiles.count > 0 {
            startingFiles.forEach { file in
                let url = source.appendingPathComponent(file)
                print("\(prefix) uncompressing file: \(url.absoluteString)")

                let tempSave = url.deletingPathExtension()
                print("\(prefix) new destination: \(tempSave.absoluteString)")
                do {
                    try FileManager.default.unzipItem(at: url, to: tempSave)
                    try FileManager.default.removeItem(at: url)
                    print("\(prefix) uncompressed successfully")
                } catch let error {
                    print("\(prefix) Error: \(error.localizedDescription)")
                    fatalError()
                }
            }

            print("\(prefix) checking next iteration")
            run()
        }
    }
}
