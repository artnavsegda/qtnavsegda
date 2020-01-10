import Felgo 3.0
import QtQuick 2.11
import QtWebSockets 1.0

App {
    id: app

    property int count: 0

  NavigationStack {
    Page {
      id: mainPage
      title: "Офис"

     AppListView {
       model: ListModel {
         ListElement { type: "Переговорная"; name: "Свет"; description: "light"; logo: "" }
         ListElement { type: "Переговорная"; name: "Медиа"; logo: "" }
         ListElement { type: "Переговорная"; name: "Климат"; logo: "" }
         ListElement { type: "Переговорная"; name: "Шторы"; logo: "" }
         ListElement { type: "Склад"; name: "Свет"; logo: "" }
         ListElement { type: "Склад"; name: "Медиа"; logo: "" }
         ListElement { type: "Склад"; name: "Шторы"; logo: "" }
       }

        delegate: SwipeOptionsContainer {
          id: container

          // the swipe container uses the height of the list item
          height: listItem.height
          SimpleRow {
          id: listItem
            text: name
            onSelected: {
                console.log("Clicked Item #"+index)
                mainPage.navigationStack.push(counterPageComponent)
            }
            iconSource: logo
//            detailText: description
          }

          // set an item that shows when swiping to the right
          leftOption: SwipeButton {
            icon: IconType.gear
            height: parent.height
            onClicked: {
              listItem.text = "Option clicked"
              container.hideOptions() // hide button again after click
            }
          }
          rightOption: Row {
              //spacing: 2
              height: parent.height
              //Rectangle { color: "red"; width: 50; height: 50 }
              SwipeButton {
                          backgroundColor : "red"
                          icon: IconType.remove
                          height: parent.height
                          onClicked: {
                            //listItem.text = "Option clicked"
                            console.log("Clicked Option A #"+index)
                            container.hideOptions() // hide button again after click
                          }
              }
              SwipeButton {
                          icon: IconType.gear
                          height: parent.height
                          onClicked: {
                            //listItem.text = "Option clicked"
                            console.log("Clicked Option B #"+index)
                            container.hideOptions() // hide button again after click
                          }
              }
          }
        }

       section.property: "type"
       section.delegate: SimpleSection { }
     }
    }

    Component {
      id: counterPageComponent
      Page {
        id: page
        title: "Change Count"

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

        titleItem: Row {
          spacing: dp(6)

          Icon {
            icon: IconType.camera
          }

          AppText {
            id: titleText
            anchors.verticalCenter: parent.verticalCenter
            text: page.title
            font.bold: true
            font.family: Theme.boldFont.name
            font.pixelSize: dp(Theme.navigationBar.titleTextSize)
            color: "orange"
          }
        } // titleItem

        property Page target: null

        Column {
             anchors.centerIn: parent

             // text to show the current count and button to push the second page
              AppButton {
                flat: false
                text: "Button"
                onClicked: {
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

  }
}
