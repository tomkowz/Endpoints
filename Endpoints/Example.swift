import Foundation

final class MemesBackend: Backend {
    static var baseUrl: URL {
        return URL(string: "http://213.32.69.32/m/api")!
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
    var url: URL {
        return MemesBackend.baseUrl.append(path: "/")
    }
    
    var method: HTTPMethod {
        return .get
    }
}

struct GetMemeEndpoint: Endpoint {
    let name: String
    
    var url: URL {
        return MemesBackend.baseUrl.append(path: "/\(name)")
    }
    
    var method: HTTPMethod {
        return .get
    }
}
