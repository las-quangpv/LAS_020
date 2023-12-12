
import CoreGraphics


class DResponse: NSObject{
    var success: Bool = false
    var error: String?
    var data: Any?
    var totalPage: Double = 1
    
    init(_success: Bool, _data: Any?, _error: String){
        self.success = _success
        self.error = _error
        self.data = _data
    }
    init(_ success: Bool, data: Any?, totalPage: Double = 1) {
        self.success = success
        self.data = data
        self.totalPage = totalPage
    }
    
    init(error: String?) {
        self.success = false
        self.error = error
    }
}
