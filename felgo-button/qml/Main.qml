import Felgo 3.0

App {
  Page {
    AppButton {
      flat: false
      text: "Button"
      onClicked: console.log("Button click");
      anchors.centerIn: parent
    }
  }
}
