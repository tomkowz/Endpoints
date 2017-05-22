import Foundation

final class MemesBackend: Backend {
    static var baseUrl: NSURL {
        return NSURL(string: "http://213.32.69.32/m/api")!
    }
}

extension MemesBackend {
    static func allMemesEndpoint() -> Endpoint {
        return allMemesEndpoint()
    }
    
    static func getMemeEndpoint(name: String) -> Endpoint {
        return GetMemeEndpoint(name: name)
    }
}

struct AllMemesEndpoint: Endpoint {
    var url: NSURL {
        return MemesBackend.baseUrl.append("/")
    }
    
    var method: HTTPMethod {
        return .get
    }
}

struct GetMemeEndpoint: Endpoint {
    let name: String
    
    var url: NSURL {
        return MemesBackend.baseUrl.append("/\(name)")
    }
    
    var method: HTTPMethod {
        return .get
    }
}
