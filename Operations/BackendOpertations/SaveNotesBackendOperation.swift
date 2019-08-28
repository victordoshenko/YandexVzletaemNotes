import Foundation

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    
    override init(notebook: FileNotebook) {
        super.init(notebook: notebook)
    }
    
    override func main() {
        print("Start SaveNotesBackendOperation ...", Date())
        result = .failure(.unreachable)
        sleep(UInt32(AsyncOperation.sleepDelay))
        finish()
        print("SaveNotesBackendOperation finished.", Date())
    }
}
