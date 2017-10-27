import Foundation

public typealias HTTPHeaderFields = [String: String]

public protocol Endpoint {
    var url: URL { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaderFields { get }
    var parameters: Any? { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var timeout: TimeInterval { get }
    var request: URLRequest { get }

    // Use it if you want to set default parameters to endpoint.
    // You can override per endpoint and globally
    var parametersWithAdditionalPayload: Any? { get }
}

extension Endpoint {
    public var request: URLRequest {
        var theUrl = url
        if method == .get, let parameters = parametersJSON {
            // Encode parameters and append query to request's url.
            var urlComponents = URLComponents(url: theUrl, resolvingAgainstBaseURL: true)!
            var query = ""
            parameters.forEach { k, v in query = query + "\(k)=\(v)&" }
            urlComponents.query = query
            theUrl = urlComponents.url!
        }
        
        var r = URLRequest(url: theUrl)
        r.httpMethod = method.rawValue
        r.allHTTPHeaderFields = headers
        r.httpBody = parametersData
        r.cachePolicy = cachePolicy
        r.timeoutInterval = timeout
        return r
    }
    
    private var parametersJSON: [String: AnyObject]? {
        return parametersWithAdditionalPayload as? [String: AnyObject]
    }
    
    private var parametersData: Data? {
        if let p = parametersJSON {
            return try? JSONSerialization.data(withJSONObject: p, options: [])
        }
        
        return parameters as? Data
    }
}

public extension Endpoint {
    var headers: HTTPHeaderFields {
        return ["Content-Type": "application/json"]
    }
    
    var parameters: Any? {
        return nil
    }

    var parametersWithAdditionalPayload: Any? {
        return parameters
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
    }
    
    var timeout: TimeInterval {
        return 3.0
    }
}

public extension URL {
    func append(path: String) -> URL {
        return self.appendingPathComponent(path)
    }
}
