import UIKit

class FileNotebook {
    var notes: [Note] = []

    public func add(_ note: Note) {
        self.remove(with: note.uid)
        notes.append(note)
        notes.sort { $0.inDateTime < $1.inDateTime }
    }
    public func remove(with uid: String) {
        if let index:Int = notes.firstIndex(where: {$0.uid == uid}) {
            notes.remove(at: index)
        }
    }
    public func saveToFile() {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        let dirurl = path.appendingPathComponent("FileNotebook")
        var isDir: ObjCBool = true
        let exists = FileManager.default.fileExists(atPath: dirurl.absoluteString, isDirectory: &isDir)
        if !(exists && isDir.boolValue) {
			try? FileManager.default.createDirectory(at: dirurl, withIntermediateDirectories: false, attributes: nil)
        }
        let filename = dirurl.appendingPathComponent("FileNotebook.dat")
        print("filename = ", filename)
        do {
            let data = try JSONSerialization.data(withJSONObject: notes.map({$0.json}), options: [])
            FileManager.default.createFile(atPath: filename.path, contents: data, attributes: nil)
        } catch {
            print("Can't save data")
        }
    }
    public func loadFromFile() {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        let filename = path.appendingPathComponent("FileNotebook/FileNotebook.dat")
        guard let data = (try? Data(contentsOf: URL(fileURLWithPath: filename.path), options: .alwaysMapped)) else {notes = Note.allNotes; return}
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let object = json as? [Any] {
            notes.removeAll()
            for o in object {
                notes.append(Note.parse(json: o as! [String : Any])!)
            }
        }
    }
}
