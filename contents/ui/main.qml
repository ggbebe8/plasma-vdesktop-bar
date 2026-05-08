//강제 삭제
//rm -rf ~/.local/share/plasma/plasmoids/com.gnoeyps.vdbar
 //설치
 //kpackagetool6 -t Plasma/Applet -i .
 //압축
 //zip -r com.gnoeyps.vdbar.plasmoid com.gnoeyps.vdbar/
 //압축 설치
 //kpackagetool6 -t Plasma/Applet -i com.gnoeyps.vdbar.plasmoid

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.taskmanager as TaskManager

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation
    compactRepresentation: coreUI
    fullRepresentation: coreUI

    TaskManager.VirtualDesktopInfo {
        id: vdInfo
    }

    Component {
        id: coreUI

        Row {
            id: mainRow
            spacing: 8
            Layout.minimumWidth: implicitWidth
            Layout.fillHeight: true

            Repeater {
                model: vdInfo.desktopIds

                delegate: Rectangle {
                    id: desktopGroup
                    
                    readonly property string targetDesktop: modelData
                    
                    color: vdInfo.currentDesktop === targetDesktop ? Qt.rgba(0.8, 0.8, 0.8, 0.3) : "transparent"
                    radius: 6
                    border.color: Qt.rgba(0.5, 0.5, 0.5, 0.3)
                    border.width: 1

                    implicitWidth: taskRow.implicitWidth + 16
                    height: parent.height - 2
                    anchors.verticalCenter: parent.verticalCenter

                    Row {
                        id: taskRow
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            text: index + 1
                            color: Kirigami.Theme.textColor
                            font.bold: true
                            font.pixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Repeater {
                            model: TaskManager.TasksModel {
                                id: tasksModel
                                filterByVirtualDesktop: true
                                virtualDesktop: desktopGroup.targetDesktop
                                filterByScreen: true
                            }

                            delegate: Rectangle {
                                width: 28; height: 28
                                radius: 4
                                color: taskMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : "transparent"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                border.color: model.IsActive === true ? "skyblue" : "transparent"
                                border.width: 2
                                
                                Kirigami.Icon {
                                    anchors.fill: parent
                                    anchors.margins: 3
                                    source: model.decoration 
                                }

                                MouseArea {
                                    id: taskMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: {
                                        tasksModel.requestActivate(tasksModel.index(index, 0));
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}