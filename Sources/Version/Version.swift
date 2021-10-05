//
//  Version.swift
//  Version
//
//  Created by Anton Heestand on 2021-08-31.
//

import Foundation

public struct Version: Equatable, Comparable, Codable {
    
    public let major: Int
    public let minor: Int
    public let patch: Int
    
    public let tag: String?
    
    public var semantic: String { "\(major).\(minor).\(patch)" }
    
    public var semanticWithTag: String { tag != nil ? "\(semantic)-\(tag!)" : semantic }
    
    public static let zero = Version(0, 0, 0)
    
    public static let os: Version = {
        let v = ProcessInfo.processInfo.operatingSystemVersion
        return Version(v.majorVersion, v.minorVersion, v.patchVersion)
    }()
    
    public static let currentVersion: Version? = {
        guard let raw: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return nil }
        return Version(raw)
    }()
    
    public static let currentBuild: Int? = {
        guard let raw = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            return nil }
        return Int(raw)
    }()
    
    public init(_ major: Int, _ minor: Int, _ patch: Int, tag: String? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.tag = tag
    }
    
    public init?(_ version: String) {
        
        let parts: [String] = version.split(separator: "-").map({ "\($0)" })
        guard parts.count == 1 || parts.count == 2 else { return nil }
        
        let semantic: String = parts.first!
        
        let texts: [String] = semantic.split(separator: ".").map({ "\($0)" })
        guard !texts.isEmpty else { return nil }
        
        let numbers: [Int] = texts.compactMap({ Int($0) })
        
        guard texts.count == numbers.count else { return nil }
        
        major = numbers[0]
        
        if numbers.count >= 2 {
            minor = numbers[1]
        } else {
            minor = 0
        }
        
        if numbers.count >= 3 {
            patch = numbers[2]
        } else {
            patch = 0
        }
        
        tag = parts.count == 2 ? parts.last! : nil
    }
    
    public static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major == rhs.major {
            if lhs.minor == rhs.minor {
                if lhs.patch == rhs.patch {
                    return false
                } else {
                    return lhs.patch < rhs.patch
                }
            } else {
                return lhs.minor < rhs.minor
            }
        } else {
            return lhs.major < rhs.major
        }
    }
}
