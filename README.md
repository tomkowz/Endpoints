Implement representation of a backend.
```swift
typealias MB = MemesBackend

final class MemesBackend: Backend {
    static var baseUrl: NSURL {
        return NSURL(string: "backend-url")!
    }
}
```

Describe an endpoint. No headers specified, default will be used `["Content-Type": "application/json"]`.
```swift
struct AllMemesEndpoint: Endpoint {
    var url: NSURL {
        return MB.baseUrl.append("/")
    }
    
    var method: HTTPMethod {
        return .get
    }
}
```

// Implement custom headers if you need any.
```swift
extension MemesBackend {
    static func authorizationHeaders() -> HTTPHeaderFields {
        let authToken = ... // read the token from secure storage.
        return [
            "Content-Type": "application/json",
            "Authorization": authToken
        ]
    }
}
```

// Example of an endpoint that takes one param and need custom headers.
```swift
struct GetSingleMeme: Endpoint {
    let name: String

    var url: NSURL {
        return MB.baseUrl.append("/\(name)")
    }

    var method: HTTPMethod {
        return .get
    }

    var headers: HTTPHeaderFields {
        // Custom headers
        return MB.authorizationHeaders()
    }
}
```

// Example of an endpoint to sign in user.
```swift
struct SignInEndpoint: Endpoint {
    let username: String
    let password: String

    var url: NSURL {
        return MB.baseUrl.append("/users/sign_in")
    }
    
    var method: HTTPMethod {
        return .post
    }

    // Parameters might be dictionary or data or nil
    var parameters: AnyObject? {
        return [
            "username": username,
            "password": password
        ]
    }
}
```

// You can get `NSURLRequest` representation of an `Endpoint` via `request` property.
```swift
let endpoint = GetSingleMeme(name: "thank-you")
let request = endpoint.request // NSURLRequest
```
