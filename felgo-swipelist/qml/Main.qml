import Felgo 3.0
import QtQuick 2.11

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
        title: "Change Count"
        property Page target: null

        Column {
          anchors.centerIn: parent

          // buttons to increase or decrease the count, which is displayed on the main page
          AppButton {
            text: "Count ++"
            onClicked: {
              app.count++
            }
          }
          AppButton {
            text: "Count --"
            onClicked: {
              app.count--
            }
          }
        }
      }
    }

  }
}
