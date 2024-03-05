import Foundation
import Capacitor

@objc(UserAgentPlugin)
public class UserAgentPlugin: CAPPlugin {

    @objc func get(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.bridge?.webView?.evaluateJavaScript("navigator.userAgent", completionHandler: { (result, error) in
                if error == nil {
                    call.resolve([
                        "userAgent": result ?? ""
                    ])
                } else {
                    call.reject(error.debugDescription)
                }
            })
        }
    }

    @objc func set(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let newUA = call.getString("userAgent") ?? nil
             
             // Check if the provided user-agent is not nil
             guard let userAgent = newUA else {
                 call.reject("User agent cannot be nil")
                 return
             }
             
             // Set the new user-agent for the web view
                if self.bridge?.webView?.customUserAgent != userAgent {
                      // Set the new user-agent for the web view
                      self.bridge?.webView?.customUserAgent = userAgent
                      
                      // Reload the web view to apply the new user-agent
                      self.bridge?.webView?.reload()
                  }
             
             call.resolve()   
        }
    }

    @objc func reset(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.bridge?.webView?.customUserAgent = nil
            call.resolve()
        }
    }
}
