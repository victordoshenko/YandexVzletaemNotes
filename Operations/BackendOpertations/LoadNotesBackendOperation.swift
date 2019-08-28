import Foundation

enum NetworkError {
    case unreachable
}

enum LoadNotesBackendResult {
    case success
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: LoadNotesBackendResult?
    
    override init(notebook: FileNotebook) {
        super.init(notebook: notebook)
    }
    
    override func main() {
        print("Start LoadNotesBackendOperation ...", Date())
        sleep(UInt32(AsyncOperation.sleepDelay))
        //notebook.notes = Note.allNotes
        //result = .success
        result = .failure(.unreachable)
        finish()
        print("LoadNotesBackendOperation finished.", Date())
    }
}
