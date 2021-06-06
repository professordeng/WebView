function receiveJSON(json) {
    console.log("received json.");
    console.log(json);
    return "received json successfully.";
}

function sendMessage() {
    window.Object.sendMessage("value")
}

function sendJSON() {
    window.Object.sendJSON({"name" : "professordeng", "score" : "100"})
}

function sendURL() {
    window.location = "sendURL://parameters?value=100";
}
