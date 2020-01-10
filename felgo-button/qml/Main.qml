import Felgo 3.0
import QtQuick 2.0
import QtWebSockets 1.0

App {
  Page {

    WebSocket {
        id: socket
        url: "ws://192.168.88.20:8080"
        onTextMessageReceived: {
            messageBox.text = "Received message: " + message
            console.log("Received message: " + message)
        }
        onStatusChanged: if (socket.status == WebSocket.Error) {
                             console.log("Error: " + socket.errorString)
                         } else if (socket.status == WebSocket.Open) {
                             //socket.sendTextMessage("Hello World")
                             console.log("Good")
                         } else if (socket.status == WebSocket.Closed) {
                             messageBox.text += "\nSocket closed"
                         }
        active: true
    }

    Column {
         anchors.centerIn: parent

         // text to show the current count and button to push the second page
          AppSwitch {
            onToggled: {
                console.log("Sending message: Hello World");
                //socket.sendTextMessage("Hello World");
                socket.sendTextMessage("PUSH[1]");
                socket.sendTextMessage("RELEASE[1]");
            }
            anchors.horizontalCenter: parent.horizontalCenter
          }
          AppText {
            id: messageBox
            text: socket.status == WebSocket.Open ? qsTr("Websocket open") : qsTr("Websocket closed")
          }
    }
  }
}
