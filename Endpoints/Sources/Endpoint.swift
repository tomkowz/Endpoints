import Foundation

public typealias HTTPHeaderFields = [String: String]

public protocol Endpoint {
    var url: NSURL { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaderFields { get }
    var parameters: AnyObject? { get }
    var cachePolicy: NSURLRequestCachePolicy { get }
    var timeout: NSTimeInterval { get }
    var request: NSURLRequest { get }
}

extension Endpoint {
    public var request: NSURLRequest {
        var theUrl = url
        if method == .get, let parameters = parametersJSON {
            // Encode parameters and append query to request's url.
            let urlComponents = NSURLComponents(URL: theUrl, resolvingAgainstBaseURL: true)!
            var query = ""
            parameters.forEach { k, v in query = query + "\(k)=\(v)&" }
            urlComponents.query = query
            theUrl = urlComponents.URL!
        }
        
        let r = NSMutableURLRequest(URL: theUrl)
        r.HTTPMethod = method.rawValue
        r.allHTTPHeaderFields = headers
        r.HTTPBody = parametersData
        r.cachePolicy = cachePolicy
        r.timeoutInterval = timeout
        return r
    }
    
    private var parametersJSON: [String: AnyObject]? {
        return parameters as? [String: AnyObject]
    }
    
    private var parametersData: NSData? {
        if let p = parametersJSON {
            return try? NSJSONSerialization.dataWithJSONObject(p, options: [])
        }
        
        return parameters as? NSData
    }
}

public extension Endpoint {
    var headers: HTTPHeaderFields {
        return ["Content-Type": "application/json"]
    }
    
    var parameters: AnyObject? {
        return nil
    }
    
    var cachePolicy: NSURLRequestCachePolicy {
        return NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
    }
    
    var timeout: NSTimeInterval {
        return 3.0
    }
}

public extension NSURL {
    func append(path: String) -> NSURL {
        return self.URLByAppendingPathComponent(path)!
    }
}
