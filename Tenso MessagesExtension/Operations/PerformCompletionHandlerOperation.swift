
import Foundation
import PeakOperation

class PerformCompletionHandlerOperation: ConcurrentOperation {
    
    var completionHandler : EmptyVoidClosure
    
    init(on complete : @escaping EmptyVoidClosure) {
        completionHandler = complete
    }
    
    override func execute() {
        
        completionHandler()
        
    }
    
}
