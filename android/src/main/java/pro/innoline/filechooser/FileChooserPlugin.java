package pro.innoline.filechooser;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;

import androidx.activity.result.ActivityResult;
import androidx.documentfile.provider.DocumentFile;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.ActivityCallback;
import com.getcapacitor.annotation.CapacitorPlugin;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@CapacitorPlugin(name = "FileChooser")
public class FileChooserPlugin extends Plugin {
  @PluginMethod()
  public void getFiles(PluginCall call) {
    String accept = call.getString("accept");

    var intent = new Intent(Intent.ACTION_GET_CONTENT);
    intent.setType("*/*");
    if (accept != null && !accept.isEmpty()) {
      intent.putExtra(Intent.EXTRA_MIME_TYPES, accept.split(","));
    }
    intent.addCategory(Intent.CATEGORY_OPENABLE);
    intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true);
    intent.putExtra(Intent.EXTRA_LOCAL_ONLY, true);

    var chooser = Intent.createChooser(intent, "Select File");
    try {
      startActivityForResult(call, chooser, "processChooseFiles");
    } catch (android.content.ActivityNotFoundException ex) {
      String msg = "Please install a File Manager.";
      call.reject(msg);
    }
  }

  @ActivityCallback
  public void processChooseFiles(PluginCall call, ActivityResult result) {
    Intent data = result.getData();

    try {
      int resultCode = result.getResultCode();
      if (resultCode == Activity.RESULT_OK) {
        JSONArray files = new JSONArray();
        assert data != null;
        if (data.getClipData() != null) {
          for (int i = 0; i < data.getClipData().getItemCount(); i++) {
            files.put(processFileUri(call, data.getClipData().getItemAt(i).getUri()));
          }

          JSObject ret = new JSObject();
          ret.put("data", files);
          call.resolve(ret);
        } else if (data.getData() != null) {
          files.put(processFileUri(call, data.getData()));

          JSObject ret = new JSObject();
          ret.put("data", files);
          call.resolve(ret);
        } else {
          call.reject("File URI was null.");
        }
      } else if (resultCode == Activity.RESULT_CANCELED) {
        call.reject("RESULT_CANCELED");
      } else {
        call.reject(String.valueOf(resultCode));
      }
    } catch (Exception err) {
      call.reject("Failed to read file: " + err);
    }
  }

  public JSONObject processFileUri(PluginCall call, Uri uri) {
    var document = DocumentFile.fromSingleUri(getContext(), uri);
    if (document != null) {
      try {
        var file = new JSONObject();
        file.put("mediaType", document.getType());
        file.put("name", document.getName());
        file.put("uri", uri.toString());
        file.put("size", document.length());
        return file;
      } catch (JSONException err) {
        call.reject("Processing failed: " + err);
      }
    }
    return null;
  }
}
