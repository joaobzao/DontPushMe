//
//  SSLModule.swift
//  DontPushMe
//
//  Created by Joao Zao on 20/08/2021.
//

import Foundation

final class SSLModule: NSObject, URLSessionDelegate {

    let delegate: SSLModuleDelegate?

    init(delegate: SSLModuleDelegate?) {
        self.delegate = delegate
    }

    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // `NSURLAuthenticationMethodClientCertificate`
        //  indicates the server requested a client certificate.
        if challenge.protectionSpace.authenticationMethod != NSURLAuthenticationMethodClientCertificate {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        guard let url = self.delegate?.push.fileUrl, let password = self.delegate?.push.password, let p12Data = try? Data(contentsOf: url) else {
            // Loading of data failed
            return
        }
        let p12Contents = PKCS12.createPKCS12(pkcs12Data: p12Data, password: password)
        guard let identity = p12Contents.identity else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        // In my case, and as Apple recommends,
        // we do not pass the certificate chain into
        // the URLCredential used to respond to the challenge.
        let credential = URLCredential(identity: identity,
                                       certificates: nil,
                                       persistence: .none)
        challenge.sender?.use(credential, for: challenge)
        completionHandler(.useCredential, credential)
    }
}

protocol SSLModuleDelegate {
    var push: Push { get }
}
