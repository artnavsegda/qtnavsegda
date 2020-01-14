import Felgo 3.0
import QtQuick 2.0

App {

  NavigationStack {

    Page {
      title: "Custom List Delegate"

      AppListView {
        id: myListView

        // UI properties
        property real widthIcon: dp(60)
        property real widthDay: dp(90)
        property real widthTempMaxMin: dp(60)
        property real widthRain: dp(40)
        property real itemRowSpacing: dp(20)
        spacing: dp(5) // vertical spacing between list items/rows/delegates

        // the model will usually come from a web server, copy it here for faster development & testing
        model: [
          {day: "Monday",    tempMax: 21, tempMin: 15, rainProbability: 0.8, rainAmount: 3.153, logo: IconType.camera},
          {day: "Tuesday",   tempMax: 24, tempMin: 15, rainProbability: 0.2, rainAmount: 0.13},
          {day: "Wednesday", tempMax: 26, tempMin: 16, rainProbability: 0.01, rainAmount: 0.21},
          {day: "Thursday",  tempMax: 32, tempMin: 21, rainProbability: 0, rainAmount: 0},
          {day: "Friday",    tempMax: 28, tempMin: 20, rainProbability: 0, rainAmount: 0},
          {day: "Saturday",  tempMax: 26, tempMin: 19, rainProbability: 0, rainAmount: 0},
          {day: "Sunday",    tempMax: 25, tempMin: 19, rainProbability: 0, rainAmount: 0}
        ]

        delegate: Row {
          id: dailyWeatherDelegate
          spacing: myListView.itemRowSpacing

          Icon {
            width: myListView.widthIcon
            anchors.verticalCenter: parent.verticalCenter
            icon: modelData.logo
          }

          AppText {
            // if it is the first entry, display "Today", if it is the second, display "Tomorrow"
            // otherwise display the day property from the model
            text: index === 0 ? "Today" :
                  index === 1 ? "Tomorrow" :
                  modelData.day

            // make all days the same width
            width: myListView.widthDay
            anchors.verticalCenter: parent.verticalCenter
          }

          AppText {
            text: modelData.tempMax + "°/" + modelData.tempMin + "°"
            horizontalAlignment: Text.AlignHCenter
            width: myListView.widthTempMaxMin
            anchors.verticalCenter: parent.verticalCenter
          }

          Column {
            width: myListView.widthRain
            anchors.verticalCenter: parent.verticalCenter
            AppText {
              text: Math.round(modelData.rainAmount*10)/10 + "l" // round to 1 decimal
              fontSize: 18
              anchors.horizontalCenter: parent.horizontalCenter
            }
            AppText {
              id: precipProbability
              text: Math.round(modelData.rainProbability * 1000)/10 + "%" // round percent to 1 decimal
              fontSize: 12
              anchors.horizontalCenter: parent.horizontalCenter
            }
          }

          AppSwitch {
            anchors.verticalCenter: parent.verticalCenter
          }

        }// dailyWeatherDelegate
      }//ListView

    }// Page
  }
}
