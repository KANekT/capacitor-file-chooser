import Foundation
import Capacitor
import MobileCoreServices

@objc(FileChooserPlugin)
public class FileChooserPlugin: CAPPlugin {
    private var _call: CAPPluginCall? = nil
    private let implementation = FileChooser()
    
    @objc func getFiles(_ call: CAPPluginCall) {
        let accept: String? = call.getString("accept");
        let types = implementation.getMimeTypes(accept);
        
        guard let viewController = bridge?.viewController else {
            call.reject("Unable to display choose files!")
            return
        }
        self._call = call;
        callPicker(ctrl: viewController, utis: types)
    }
    
    @objc public func callPicker (ctrl: UIViewController, utis: [String]) {
        DispatchQueue.main.async { [weak self] in
            let documentPicker = UIDocumentPickerViewController(
                documentTypes: utis,
                in: .import
            )
            
            documentPicker.allowsMultipleSelection = true
            
            if #available(iOS 13.0, *) {
                documentPicker.shouldShowFileExtensions = true
            }
            
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            
            ctrl.present(
                documentPicker,
                animated: true,
                completion: nil
            )
        }
    }
    
    func documentWasSelected (urls: [URL]) {
        var files: [JSObject] = [];
        for url in urls {
            var result = JSObject();
            result["mediaType"] = implementation.detectMimeType(url);
            result["name"] = url.lastPathComponent;
            result["uri"] = url.absoluteString;
            
            do
            {
                let fileDictionary = try FileManager.default.attributesOfItem(atPath: url.path)
                result["size"] = (fileDictionary[FileAttributeKey.size] as! JSValue)
            }
            catch{
                result["size"] = 0;
            }
            
            files.append(result);
        }
        
        var ret = JSObject();
        ret["data"] = files;
        
        self._call?.resolve(ret);
    }
}

extension FileChooserPlugin: UIDocumentPickerDelegate {
    @available(iOS 11.0, *)
    public func documentPicker (
        _ controller: UIDocumentPickerViewController,
        didPickDocumentsAt urls: [URL]
    ) {
        self.documentWasSelected(urls: urls)
    }
    
    public func documentPicker (
        _ controller: UIDocumentPickerViewController,
        didPickDocumentAt url: URL
    ) {
        self.documentWasSelected(urls: [url])
    }
    
    public func documentPickerWasCancelled (_ controller: UIDocumentPickerViewController) {
        self._call?.reject("RESULT_CANCELED")
    }
}
