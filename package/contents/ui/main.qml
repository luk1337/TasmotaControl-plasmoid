import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasmoid

PlasmoidItem {
    Plasmoid.icon: Qt.resolvedUrl("icon.svg")

    fullRepresentation: PlasmaComponents3.ScrollView {
        Layout.minimumWidth: Kirigami.Units.gridUnit * 24
        Layout.minimumHeight: Kirigami.Units.gridUnit * 24
        Layout.maximumWidth: Kirigami.Units.gridUnit * 80
        Layout.maximumHeight: Kirigami.Units.gridUnit * 40

        GridView {
            id: gridView

            anchors {
                fill: parent
                margins: Kirigami.Units.smallSpacing
            }

            cellWidth: width / 3
            cellHeight: width / 3
            delegate: Item {
                height: gridView.cellHeight
                width: gridView.cellWidth

                PlasmaComponents3.Button {
                    anchors {
                        fill: parent
                        margins: Kirigami.Units.smallSpacing * 2
                    }

                    Kirigami.Icon {
                        anchors.centerIn: parent
                        height: parent.height * 0.5
                        width: parent.width * 0.5
                        source: Qt.resolvedUrl(on ? iconOn : iconOff)
                    }

                    onClicked: toggleDevice(index)
                }
            }
            model: devices
        }
    }

    ListModel {
        id: devices

        ListElement {
            iconOff: "light-off.svg"
            iconOn: "light-on.svg"
            on: false
            url: "http://luk-tasmota-2.lan"
        }

        ListElement {
            iconOff: "speaker-off.svg"
            iconOn: "speaker-on.svg"
            on: false
            url: "http://luk-tasmota-1.lan"
        }
    }

    Timer {
        interval: 15000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: updateDevices()
    }

    function jsonGetRequest(url, callback) {
        const request = new XMLHttpRequest()
        request.onload = () => callback(JSON.parse(request.responseText))
        request.open("GET", url)
        request.send()
    }

    function updateDevices() {
        for (let i = 0; i < devices.rowCount(); i++) {
            const item = devices.get(i)

            jsonGetRequest(`${item.url}/cm?cmnd=POWER`, (response) => {
                item.on = response.POWER === "ON"
            })
        }
    }

    function toggleDevice(i) {
        const item = devices.get(i)

        jsonGetRequest(`${item.url}/cm?cmnd=POWER%202`, (response) => {
            item.on = response.POWER === "ON"
        })
    }
}
