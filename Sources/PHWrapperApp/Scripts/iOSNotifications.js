iOSNotifications = { }
iOSNotifications.queue = [ ];

iOSNotifications.callback = function(idx,value) {
	iOSNotifications.queue[idx](value);
	iOSNotifications.queue[idx]="";
}

iOSNotifications.getSettingsURL = function() {
	var promise = new Promise(function(resolve,reject) {
		var len = iOSNotifications.queue.push(resolve);
		var idx = len -1;
		window.webkit.messageHandlers.getSettingsURL.postMessage({idx:idx});
	});
	return promise;
}

iOSNotifications.getNotificationsStatus = function() {
    console.log("[JSBridge] requestNotificationsStatus");
	var promise = new Promise(function(resolve,reject) {
		var len = iOSNotifications.queue.push(resolve);
		var idx = len -1;
		window.webkit.messageHandlers.getNotificationsStatus.postMessage({idx:idx});
	});
	return promise;
}

iOSNotifications.requestNotificationsPermission = function() {
    console.log("[JSBridge] requestNotificationsPermission");
	var promise = new Promise(function(resolve,reject) {
		var len = iOSNotifications.queue.push(resolve);
		var idx = len -1;
		window.webkit.messageHandlers.requestNotificationsPermission.postMessage({idx:idx});
	});
	return promise;
}

iOSNotifications.openSettingsPage = function() {
	var promise = new Promise(function(resolve,reject) {
		var len = iOSNotifications.queue.push(resolve);
		var idx = len -1;
		window.webkit.messageHandlers.openSettingsPage.postMessage({idx:idx});
	});
	return promise;
}

iOSNotifications.subscribe = function(topic) {
	var promise = new Promise(function(resolve,reject) {
		var len = iOSNotifications.queue.push(resolve);
		var idx = len -1;
		window.webkit.messageHandlers.subscribe.postMessage({idx:idx,topic:topic});
	});
	return promise;
}

iOSNotifications.unsubscribe = function(topic) {
	var promise = new Promise(function(resolve,reject){
		var len = iOSNotifications.queue.push(resolve);
		var idx = len -1;
		window.webkit.messageHandlers.unsubscribe.postMessage({idx:idx,topic:topic});
	});
	return promise;
}

iOSNotifications.isSubscribed = function(topic) {
	var promise = new Promise(function(resolve,reject){
		var len = iOSNotifications.queue.push(resolve);
		var idx = len -1;
		window.webkit.messageHandlers.isSubscribed.postMessage({idx:idx,topic:topic});
	});
	return promise;
}
