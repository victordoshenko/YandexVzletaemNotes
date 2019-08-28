import Foundation

class BaseBackendOperation: AsyncOperation {
    let notebook: FileNotebook
    
    init(notebook: FileNotebook) {
        self.notebook = notebook
        super.init()
    }
}
