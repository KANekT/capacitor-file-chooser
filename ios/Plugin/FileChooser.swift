import UIKit
import MobileCoreServices
import Foundation
import Capacitor

@objc public class FileChooser: NSObject {
    @objc public func getMimeTypes(_ accept: String?) -> [String] {
        if (accept == nil) {
            return [kUTTypeData as String];
        }
        
        let mimeTypes = accept!.components(separatedBy: ",");
        
        return mimeTypes.map { (mimeType: String) -> String in
            switch mimeType {
            case "audio/*":
                return kUTTypeAudio as String
            case "font/*":
                return "public.font"
            case "image/*":
                return kUTTypeImage as String
            case "text/*":
                return kUTTypeText as String
            case "video/*":
                return kUTTypeVideo as String
            default:
                break
            }
            
            if mimeType.range(of: "*") == nil {
                let utiUnmanaged = UTTypeCreatePreferredIdentifierForTag(
                    kUTTagClassMIMEType,
                    mimeType as CFString,
                    nil
                )
                
                if let uti = (utiUnmanaged?.takeRetainedValue()) {
                    let str = uti as String;
                    if !str.hasPrefix("dyn.") {
                        return str
                    }
                }
            }
            
            return kUTTypeData as String
        }
    }
    
    @objc public func detectMimeType (_ url: URL) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(
            kUTTagClassFilenameExtension,
            url.pathExtension as CFString,
            nil
        )?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(
                uti,
                kUTTagClassMIMEType
            )?.takeRetainedValue() {
                return mimetype as String
            }
        }
        
        return "application/octet-stream"
    }
}
