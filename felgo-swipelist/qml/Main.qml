import Felgo 3.0
import QtQuick 2.11

App {
  NavigationStack {
    Page {
      title: "Офис"

     AppListView {
       model: ListModel {
         ListElement { type: "Переговорная"; name: "Свет"; description: "light" }
         ListElement { type: "Переговорная"; name: "Медиа" }
         ListElement { type: "Переговорная"; name: "Климат" }
         ListElement { type: "Переговорная"; name: "Шторы" }
         ListElement { type: "Склад"; name: "Свет" }
         ListElement { type: "Склад"; name: "Медиа" }
         ListElement { type: "Склад"; name: "Шторы" }
       }

        delegate: SwipeOptionsContainer {
          id: container

          // the swipe container uses the height of the list item
          height: listItem.height
          SimpleRow {
          id: listItem
            text: name
            onSelected: console.log("Clicked Item #"+index)
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
  }
}
