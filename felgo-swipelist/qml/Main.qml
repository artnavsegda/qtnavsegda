import Felgo 3.0

App {
  NavigationStack {

    Page {
      title: "Swipe-able List"

      AppListView {
        anchors.fill: parent
        model: [
          {
            text: "Apple",
            detailText: "A delicious fruit with round shape",
            icon: IconType.apple
          },

          {
            text: "Beer",
            detailText: "A delicous drink",
            icon: IconType.beer
          }
        ]

        delegate: SwipeOptionsContainer {
          id: container

          // the swipe container uses the height of the list item
          height: listItem.height
          SimpleRow { id: listItem }

          // set an item that shows when swiping to the right
          leftOption: SwipeButton {
            icon: IconType.gear
            height: parent.height
            onClicked: {
              listItem.text = "Option clicked"
              container.hideOptions() // hide button again after click
            }
          }
          rightOption: SwipeButton {
            icon: IconType.gear
            height: parent.height
            onClicked: {
              listItem.text = "Option clicked"
              container.hideOptions() // hide button again after click
            }
          }
        }

      } // AppListView
    }

  }
}
