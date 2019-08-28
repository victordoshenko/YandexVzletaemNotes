import Foundation

class LoadNotesOperation: AsyncOperation {
    private let notebook: FileNotebook

    private let saveToDb: SaveNoteDBOperation
    private let loadFromDb: LoadNotesDBOperation
	private let loadFromBackend: LoadNotesBackendOperation
    
    private(set) var result: Bool? = false

    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.notebook = notebook
        
        saveToDb = SaveNoteDBOperation(notebook: notebook)
        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        loadFromBackend = LoadNotesBackendOperation(notebook: notebook)

        super.init()

        let adapterOp = BlockOperation(block: {
            switch self.loadFromBackend.result! {
            case .success:
                self.loadFromDb.cancel()
                self.addDependency(self.saveToDb)
                dbQueue.addOperation(self.saveToDb)
            case .failure: break
            }
        })
        
        //Вызывать будем последовательно: loadFromBackend -> adapterOp -> loadFromDb
        //Если loadFromBackend вернуло успех, то с помощью adapterOp отменяем loadFromDb
        adapterOp.addDependency(loadFromBackend)
        loadFromDb.addDependency(adapterOp)
        self.addDependency(loadFromDb)

        dbQueue.addOperation(loadFromDb)
        dbQueue.addOperation(adapterOp)
        backendQueue.addOperation(loadFromBackend)
    }

    override func main() {
        switch loadFromBackend.result! {
        case .success:
            result = true
        case .failure:
            result = false
        }
        finish()
    }
}
