import Foundation

class RemoveNoteDBOperation: BaseDBOperation {
    private let note: Note
    
    init(note: Note,
         notebook: FileNotebook) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {        
        print("Start RemoveNoteDBOperation ... ", Date())
        sleep(UInt32(AsyncOperation.sleepDelay))
        notebook.remove(with: note.uid)
		notebook.saveToFile()
        finish()
        print("RemoveNoteDBOperation finished. ", Date())
    }
}
