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
       id: myListView
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
                mainPage.navigationStack.push(counterPageComponent, { room: index })
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

        property int room: 0

        property var dataModel: [
            [
//              {name: "Споты", logo: IconType.camera, slider: true},
//              {name: "Ленты", logo: IconType.android, slider: true},
              {name: "Потолок", logo: IconType.apple, type: "lamp", channel: 3, level: 0, power: true}
            ],//свет переговорная
            [],//медиа переговорная
            [],//климат переговорная
            [
              {name: "Жалюзи", logo: IconType.dashcube, type: "shades", channel: 3, level: 0, power: false}
            ],//шторы переговорная
            [
//              {name: "Споты", logo: IconType.camera, slider: true},
//              {name: "Ленты", logo: IconType.android, slider: true},
              {name: "Потолок 1", logo: IconType.camera, type: "lamp", channel: 1, level: 0, power: false},
              {name: "Потолок 2", logo: IconType.android, type: "lamp", channel: 2, level: 0, power: false}
            ],//свет склад
            [],//медиа склад
            [
              {name: "Левая штора", logo: IconType.ambulance, type: "shades", channel: 1, level: 0, power: true},
              {name: "Правая штора", logo: IconType.dashcube, type: "shades", channel: 2, level: 0, power: true}
            ]//шторы склад
        ]

        Timer {
            id: timer
            interval: 300; running: false; repeat: false
            onTriggered: page.dataModelChanged()
        }

        WebSocket {
            id: socket
            url: "ws://192.168.88.20:8080"
            onTextMessageReceived: {
                //messageBox.text = "Received message: " + message
                //console.log("Received message: " + message)

                function getBoundString(msg, startChar, stopChar)
                {
                    var response = "";

                    if (msg != null && msg.length > 0)
                    {
                        var start = msg.indexOf(startChar);

                        if (start >= 0)
                        {
                            start += startChar.length;

                            var end = msg.indexOf(stopChar, start);

                            if (start < end)
                            {
                                response = msg.substring(start, end);
                            }
                        }
                    }

                    return response;
                }

                //ON[CHANNEL]
                if (message.indexOf("ON[") == 0)
                {
                    var channel = parseInt(getBoundString(message, "ON[", "]"), 10);

                    if (isNaN(channel) == false)
                    {
                        console.log("digital channel " + channel + " goes high state");
                        switch (channel)
                        {
                        case 1:
                            dataModel[4][0].power = true;
                        break;
                        case 2:
                            dataModel[4][1].power = true;
                        break;
                        case 3:
                            dataModel[0][0].power = true;
                        break;
                        }
                    }
                }
                //OFF[CHANNEL]
                else if (message.indexOf("OFF[") == 0)
                {
                    var channel = parseInt(getBoundString(message, "OFF[", "]"), 10);

                    if (isNaN(channel) == false)
                    {
                        console.log("digital channel " + channel + " goes low state");
                        switch (channel)
                        {
                        case 1:
                            dataModel[4][0].power = false;
                        break;
                        case 2:
                            dataModel[4][1].power = false;
                        break;
                        case 3:
                            dataModel[0][0].power = false;
                        break;
                        }
                    }
                }
                // LEVEL[LEVEL,VALUE]
                else if (message.indexOf("LEVEL[") == 0)
                {
                    var channel = parseInt(getBoundString(message, "LEVEL[", ","), 10);
                    var value = parseInt(getBoundString(message, ",", "]"), 10);

                    console.log("analog channel " + channel + " goes " + value + " level");

                    switch (channel)
                    {
                    case 1:
                        dataModel[6][0].level = value;
                    break;
                    case 2:
                        dataModel[6][1].level = value;
                    break;
                    case 3:
                        dataModel[3][0].level = value;
                    break;
                    }
                }
                //page.dataModelChanged();
                timer.start();

            }
            onStatusChanged: if (socket.status == WebSocket.Error) {
                                 console.log("Error: " + socket.errorString)
                             } else if (socket.status == WebSocket.Open) {
                                 //socket.sendTextMessage("Hello World")
                                 console.log("Good")
                             } else if (socket.status == WebSocket.Closed) {
                                 //messageBox.text += "\nSocket closed"
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

        AppListView {
          id: myListView

          // UI properties
          property real widthIcon: dp(40)
          property real widthDay: dp(250)
          property real widthTempMaxMin: dp(60)
          property real widthRain: dp(40)
          property real itemRowSpacing: dp(20)
          spacing: dp(5) // vertical spacing between list items/rows/delegates

          // the model will usually come from a web server, copy it here for faster development & testing
          model: page.dataModel[room]

          delegate: Row {
            id: dailyWeatherDelegate
            spacing: myListView.itemRowSpacing

            Icon {
              width: myListView.widthIcon
              anchors.verticalCenter: parent.verticalCenter
              icon: modelData.logo
            }

            Column {
              width: myListView.widthDay
              anchors.verticalCenter: parent.verticalCenter
              AppText {
                text: modelData.name
  //              horizontalAlignment: Text.AlignHCenter
  //              horizontalAlignment: Text.AlignLeft
                width: myListView.widthDay
                anchors.horizontalCenter: parent.horizontalCenter
              }
              AppSlider {
                id: slider
                width: myListView.widthDay
                anchors.horizontalCenter: parent.horizontalCenter
                visible: modelData.type === "shades"
                from: 0
                to: 65535
                stepSize: 1
                value: modelData.level
                onMoved: {
                  console.log("moved");
                  socket.sendTextMessage("LEVEL[" + modelData.channel + "," + value + "]");
                }
              }
            }

            Column {
              width: myListView.widthRain
              anchors.verticalCenter: parent.verticalCenter
              AppSwitch {
                anchors.horizontalCenter: parent.horizontalCenter
                checked: {
                    switch(modelData.type) {
                      case "lamp":
                        return modelData.power;
                        break;
                      case "shades":
                        if (modelData.level == 0)
                          return false;
                        else if (modelData.level == 65535)
                          return true;
                        break;
                      default:
                        break;
                    }
                }
                updateChecked: true;
                onToggled: {
                    //socket.sendTextMessage("Hello World");

                    switch(modelData.type) {
                      case "lamp":
                        console.log("toggle lamp");
                        socket.sendTextMessage("PUSH[" + modelData.channel + "]");
                        socket.sendTextMessage("RELEASE[" + modelData.channel + "]");
                        break;
                      case "shades":
                        console.log("toggle shades");
                        if (checked)
                        {
                          socket.sendTextMessage("LEVEL[" + modelData.channel + ",65535]");
                        }
                        else
                        {
                          socket.sendTextMessage("LEVEL[" + modelData.channel + ",0]");
                        }
                        break;
                      default:
                        // code block
                    }
                }
              }
              IconButton {
                // Icon in default state
                icon: IconType.hearto
                // Icon in selected state
                selectedIcon: IconType.heart

                toggle: true

                onToggled: {
                  setTimeout(console.debug("Button toggled"),1000);
                  //myListView.model = page.dataModel2;
                  //page.room = 1;
                  console.log(page.dataModel[0][0].name);
                  page.dataModelChanged();
                }
                anchors.horizontalCenter: parent.horizontalCenter
              }
            }

          }// dailyWeatherDelegate
        }//ListView
      }
    }

  }
}
