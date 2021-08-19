//
//  PKCS12.swift
//  DontPushMe
//
//  Created by Joao Zao on 19/08/2021.
//
//  Source: https://gist.github.com/algal/66703927b8379182640a42294e5f3c0b
//

import Foundation

struct PKCS12 {
    let label: String?
    let keyID: NSData?
    let trust: SecTrust?
    let certChain: [SecTrust]?
    let identity: SecIdentity?
}

extension PKCS12 {
    /// Creates a PKCS12 from a piece of data.
    /// - Parameters:
    ///   - pkcs12Data:
    ///   - password:
    static func createPKCS12(pkcs12Data: Data, password: String) -> PKCS12 {
        let importPasswordOption: NSDictionary = [kSecImportExportPassphrase as NSString: password]

        var items: CFArray?
        let secError: OSStatus = SecPKCS12Import(pkcs12Data as NSData, importPasswordOption, &items)
        guard secError == errSecSuccess else {
            if secError == errSecAuthFailed {
                NSLog("Incorrect password?")

            }
            fatalError("Error trying to import PKCS12 data")
        }

        guard let theItemsCFArray = items else { fatalError() }
        let theItemsNSArray: NSArray = theItemsCFArray as NSArray
        guard let dictArray = theItemsNSArray as? [[String: AnyObject]] else { fatalError() }

        func f<T>(key: CFString) -> T? {
            for dict in dictArray {
                if let value = dict[key as String] as? T {
                    return value
                }
            }
            return nil
        }

        let label: String? = f(key: kSecImportItemLabel)
        let keyID: NSData? = f(key: kSecImportItemKeyID)
        let trust: SecTrust? = f(key: kSecImportItemTrust)
        let certChain: [SecTrust]? = f(key: kSecImportItemCertChain)
        let identity: SecIdentity? = f(key: kSecImportItemIdentity)

        return PKCS12(label: label, keyID: keyID, trust: trust, certChain: certChain, identity: identity)
    }
}
