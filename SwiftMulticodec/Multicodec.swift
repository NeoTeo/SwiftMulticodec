//
//  Multicodec.swift
//  SwiftMulticodec
//
//  Created by Teo Sartori on 08/05/2018.
//

import Foundation
import VarInt

enum MulticodecError : Error {
    case PrefixExtractionBufferTooSmall
    case PrefixExtractionValueOverflow
    case UnknownCodecString
    case UnknownCodecId
}


/// Extract the prefix value from a multicodec prefixed byte buffer
///
/// - Parameter bytes: a multicodec prefixed byte buffer
/// - Returns: the prefix value of the given data
/// - Throws: PrefixExtractionBufferTooSmall if the buffer was too small. PrefixExtractionValueOverflow if the value was larger than 64 bits.
public func extractPrefix(bytes: [UInt8]) throws -> Int64 {
    let (prefix, bytesRead) = varInt(bytes)
    
    // Check for error condition
    if prefix == 0 && bytesRead <= 0 {
        if bytesRead == 0 { throw MulticodecError.PrefixExtractionBufferTooSmall }
        throw MulticodecError.PrefixExtractionValueOverflow
    }
    
    return prefix
}

/// Return the prefix value for a given multicodec string
///
/// - Parameter multiCodec: the name of the multicodec
/// - Returns: the prefix value for the given multicodec as bytes
/// - Throws: UnknownCodecString if the name was invalid
public func getPrefix(multiCodec: String) throws -> [UInt8] {
    guard let codecVal = codecs[multiCodec] else {
        throw MulticodecError.UnknownCodecString
    }
    
    return putVarInt(codecVal)
}


/// Add multicodec prefix to the front of the given byte buffer
///
/// - Parameters:
///   - multiCode: the multicodec name to use for prefixing
///   - bytes: the byte buffer to prefix
/// - Returns: the prefixed byte buffer
/// - Throws: UnknownCodecString if given an invalid multicodec name
public func addPrefix(multiCodec: String, bytes: [UInt8]) throws -> [UInt8] {
    let prefix = try getPrefix(multiCodec: multiCodec)
    
    return prefix + bytes
}


/// Remove the prefix from a prefixed byte buffer
///
/// - Parameter bytes: the prefixed byte buffer
/// - Returns: the byte buffer without the prefix
/// - Throws: See extractPrefix
public func removePrefix(bytes: [UInt8]) throws -> [UInt8] {
    let prefixInt = try extractPrefix(bytes: bytes)
    let prefix = putVarInt(prefixInt)
    
    return Array(bytes[prefix.count...])
}


/// Get the codec name of the codec in the given byte buffer
///
/// - Parameter bytes: the multicodec prefixed byte buffer
/// - Returns: the name of the multicodec prefix
/// - Throws: see extractPrefix
public func getCodec(bytes: [UInt8]) throws -> String {
    let prefix = try extractPrefix(bytes: bytes)
    guard let codecName = codecs.first(where: { $1 == prefix })?.key else {
        throw MulticodecError.UnknownCodecId
    }
    return codecName
}
