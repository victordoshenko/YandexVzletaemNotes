import Foundation

class RemoveNoteOperation: AsyncOperation {
    private let dbQueue: OperationQueue
    private let note: Note
    private let notebook: FileNotebook
    private let removeFromDb: RemoveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation?

    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.note = note
        self.notebook = notebook

        removeFromDb = RemoveNoteDBOperation(note: note, notebook: notebook)
        self.dbQueue = dbQueue

        super.init()
        
        removeFromDb.completionBlock = {
            let saveToBackend = SaveNotesBackendOperation(notebook: notebook)
            saveToBackend.completionBlock = {
                switch saveToBackend.result! {
                case .success:
                    self.result = true
                case .failure:
                    self.result = false
                }
                self.finish()
            }
            backendQueue.addOperation(saveToBackend)
            self.addDependency(saveToBackend)
        }
    }
    
    override func main() {
        dbQueue.addOperation(removeFromDb)
    }
}
