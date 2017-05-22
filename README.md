```swift
typealias MB = MemesBackend

final class MemesBackend: Backend {
    static var baseUrl: NSURL {
        return NSURL(string: "backend-url")!
    }
}
```

```swift
extension MemesBackend {
    static func authorizationHeaders() -> HTTPHeaderFields {
        let authToken = ... // read the token
        return [
            "Content-Type": "application/json",
            "Authorization": authToken
        ]
    }
}
```

```swift
struct AllMemesEndpoint: Endpoint {
    var url: NSURL {
        return MB.baseUrl.append("/")
    }
    
    var method: HTTPMethod {
        return .get
    }

    // No headers specified, default will be used ["Content-Type": "application/json"].
}
```

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

```swift
let endpoint = GetSingleMeme(name: "thank-you")
let request = endpoint.request // NSURLRequest
```

