var urlPrefix = "native://";
var dictionary = {"name" : "David&professordeng", "score" : {"math" : "100", "english" : "60"}};

function initPage(parameter) {
    if (parameter) {
        return "OK";
    }
    return {"value" : "KO"};
}

function test(stringParameter, number, dictionary) {
    console.log("test");
    alert(stringParameter);
    return "OK";
}

function receiveJSON(json) {
    console.log("received json");
    console.log(json);
    return "OK";
}

function sendMessage1() {
    window.webkit.messageHandlers.native.postMessage({parameter1 : "value1", parameter2 : "value2"})
}

function sendMessage2() {
    window.webkit.messageHandlers.native.postMessage("parameters?parameter1=100&parameter2=200&parameter3=abcd")
}

function sendMessage3() {
    window.location = urlPrefix + "parameters?parameter1=100&parameter2=200&parameter3=abcd";
}

function sendJSON() {
    window.webkit.messageHandlers.native.postMessage({message : dictionary});
}

function sendJSONURL() {
    window.location = urlPrefix + "parameters?json=" + encodeURIComponent(JSON.stringify(dictionary));
}

function sendBase64() {
    window.location = urlPrefix + "parameters?base64=" + btoa(encodeURIComponent(JSON.stringify(dictionary)));
}
