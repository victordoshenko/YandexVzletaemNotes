import Foundation

class LoadNotesDBOperation: BaseDBOperation {
    
    override init(notebook: FileNotebook) {
        super.init(notebook: notebook)
    }
    
    override func main() {
        print("Start LoadNotesDBOperation ... ", Date())
        sleep(UInt32(AsyncOperation.sleepDelay))
		notebook.loadFromFile()
        finish()
        print("LoadNotesDBOperation finished. ", Date())
    }
}
