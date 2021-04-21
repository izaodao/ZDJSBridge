// This file contains the source for the Javascript side of the
// ZDJSBridge. It is plaintext, but converted to an NSString
// via some preprocessor tricks.
//
// Previous implementations of ZDJSBridge loaded the javascript source
// from a resource. This worked fine for app developers, but library developers who
// included the bridge into their library, awkwardly had to ask consumers of their
// library to include the resource, violating their encapsulation. By including the
// Javascript as a string resource, the encapsulation of the library is maintained.

#import "ZDBridge_JS.h"

NSString * SteupBridge_JS() {
    #define __zdjb_js_func__(x) #x
    
    // BEGIN preprocessorJSCode
    static NSString * preprocessorJSCode = @__zdjb_js_func__(
;function setupZDJSBridge(callback) {
    if (window.jsBridge) { return callback(jsBridge); }
    if (window.ZDJBCallbacks) { return window.ZDJBCallbacks.push(callback); }
    window.ZDJBCallbacks = [callback];
    var ZDJBIframe = document.createElement('iframe');
    ZDJBIframe.style.display = 'none';
    ZDJBIframe.src = 'https://__bridge_loaded__';
    document.documentElement.appendChild(ZDJBIframe);
    setTimeout(function() { document.documentElement.removeChild(ZDJBIframe) }, 0)
}
    setupZDJSBridge(function(bridge) {
        bridge.register('AutoAction', function(data, responseCallback) {
            
            if (!data.funcName) {
                return;
            }
            
            var fn;
            if (data.parameter) {
                fn = data.funcName + '(' + data.parameter + ')';
            } else {
                fn = data.funcName + '()';
            }
            
            if (responseCallback) {
                responseCallback(eval(fn));
            } else {
                eval(fn);
            }
        })
    })
    ); // END preprocessorJSCode

    #undef __zdjb_js_func__
    return preprocessorJSCode;
};

NSString * Bridge_JS() {
	#define __zdjb_js_func__(x) #x
	
	// BEGIN preprocessorJSCode
	static NSString * preprocessorJSCode = @__zdjb_js_func__(
;(function() {
	if (window.jsBridge) {
		return;
	}

	if (!window.onerror) {
		window.onerror = function(msg, url, line) {
			console.log("jsBridge: ERROR:" + msg + "@" + url + ":" + line);
		}
	}
	window.jsBridge = {
		register: register,
		call: call,
		disableJavscriptAlertBoxSafetyTimeout: disableJavscriptAlertBoxSafetyTimeout,
		_fetchQueue: _fetchQueue,
		_handleMessageFromObjC: _handleMessageFromObjC
	};

	var messagingIframe;
	var sendMessageQueue = [];
	var messageHandlers = {};
	
	var CUSTOM_PROTOCOL_SCHEME = 'https';
	var QUEUE_HAS_MESSAGE = '__zdjb_queue_message__';
	
	var responseCallbacks = {};
	var uniqueId = 1;
	var dispatchMessagesWithTimeoutSafety = true;

	function register(handlerName, handler) {
		messageHandlers[handlerName] = handler;
	}
	
	function call(handlerName, data, responseCallback) {
		if (arguments.length == 2 && typeof data == 'function') {
			responseCallback = data;
			data = null;
		}
		_doSend({ handlerName:handlerName, data:data }, responseCallback);
	}
	function disableJavscriptAlertBoxSafetyTimeout() {
		dispatchMessagesWithTimeoutSafety = false;
	}
	
	function _doSend(message, responseCallback) {
		if (responseCallback) {
			var callbackId = 'cb_'+(uniqueId++)+'_'+new Date().getTime();
			responseCallbacks[callbackId] = responseCallback;
			message['callbackId'] = callbackId;
		}
		sendMessageQueue.push(message);
		messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + QUEUE_HAS_MESSAGE;
	}

	function _fetchQueue() {
		var messageQueueString = JSON.stringify(sendMessageQueue);
		sendMessageQueue = [];
		return messageQueueString;
	}

	function _dispatchMessageFromObjC(messageJSON) {
		if (dispatchMessagesWithTimeoutSafety) {
			setTimeout(_doDispatchMessageFromObjC);
		} else {
			 _doDispatchMessageFromObjC();
		}
		
		function _doDispatchMessageFromObjC() {
			var message = JSON.parse(messageJSON);
			var messageHandler;
			var responseCallback;

			if (message.responseId) {
				responseCallback = responseCallbacks[message.responseId];
				if (!responseCallback) {
					return;
				}
				responseCallback(message.responseData);
				delete responseCallbacks[message.responseId];
			} else {
				if (message.callbackId) {
					var callbackResponseId = message.callbackId;
					responseCallback = function(responseData) {
						_doSend({ handlerName:message.handlerName, responseId:callbackResponseId, responseData:responseData });
					};
				}
				
				var handler = messageHandlers[message.handlerName];
				if (!handler) {
                    handler = messageHandlers['AutoAction'];
                    if (!handler) {
                        console.log("jsBridge: WARNING: no handler for message from ObjC:", message);
                    } else {
                        var data = {};
                        data['funcName'] = message.handlerName;
                        data['parameter'] = message.data;
                        handler(data, responseCallback);
                    }
				} else {
					handler(message.data, responseCallback);
				}
			}
		}
	}
	
	function _handleMessageFromObjC(messageJSON) {
        _dispatchMessageFromObjC(messageJSON);
	}

	messagingIframe = document.createElement('iframe');
	messagingIframe.style.display = 'none';
	messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + QUEUE_HAS_MESSAGE;
	document.documentElement.appendChild(messagingIframe);

	register("_disableJavascriptAlertBoxSafetyTimeout", disableJavscriptAlertBoxSafetyTimeout);
	
	setTimeout(_callZDJBCallbacks, 0);
	function _callZDJBCallbacks() {
		var callbacks = window.ZDJBCallbacks;
		delete window.ZDJBCallbacks;
		for (var i=0; i<callbacks.length; i++) {
			callbacks[i](jsBridge);
		}
	}
})();
	); // END preprocessorJSCode

	#undef __zdjb_js_func__
	return preprocessorJSCode;
};
