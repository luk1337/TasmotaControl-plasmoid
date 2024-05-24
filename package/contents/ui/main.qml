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

        ListView {
            id: listView

            anchors {
                fill: parent
                margins: Kirigami.Units.smallSpacing
            }

            delegate: PlasmaComponents3.CheckBox {
                checked: on
                text: title
                width: listView.width

                onToggled: toggleDevice(index)
            }
            model: devices
            spacing: Kirigami.Units.smallSpacing * 2
        }
    }

    ListModel {
        id: devices

        ListElement {
            on: false
            title: "lampka ;3"
            url: "http://luk-tasmota-2.lan"
        }

        ListElement {
            on: false
            title: "głośniki ^.^"
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
        let request = new XMLHttpRequest()
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
