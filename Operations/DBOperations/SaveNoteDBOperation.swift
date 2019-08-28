import Foundation

class SaveNoteDBOperation: BaseDBOperation {
    private let note: Note?
    
    init(note: Note,
         notebook: FileNotebook) {
        self.note = note
        super.init(notebook: notebook)
    }

    override init(notebook: FileNotebook) {
        self.note = nil
        super.init(notebook: notebook)
    }

    override func main() {
        print("Start SaveNoteDBOperation ... ", Date())
        sleep(UInt32(AsyncOperation.sleepDelay))
        if note != nil {
            notebook.add(note!)
        }
		notebook.saveToFile()
        finish()
        print("SaveNoteDBOperation finished. ", Date())
    }
}
