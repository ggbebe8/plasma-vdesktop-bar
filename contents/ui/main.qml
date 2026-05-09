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
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation
    compactRepresentation: coreUI
    fullRepresentation: coreUI

    TaskManager.VirtualDesktopInfo {
        id: vdInfo
    }

    // D-Bus 명령 실행을 위한 DataSource
    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: (sourceName, data) => {
            disconnectSource(sourceName);
        }
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
                    
                    // 현재 가상 데스크톱 강조 표시
                    color: vdInfo.currentDesktop === targetDesktop ? Qt.rgba(0.8, 0.8, 0.8, 0.3) : "transparent"
                    radius: 6
                    border.color: Qt.rgba(0.5, 0.5, 0.5, 0.3)
                    border.width: 1

                    // 내부 아이콘 개수에 따라 너비 조절
                    implicitWidth: taskRow.implicitWidth + 16
                    height: parent.height - 2
                    anchors.verticalCenter: parent.verticalCenter

                    // 가상 데스크톱 영역 클릭 시 해당 데스크톱으로 전환
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            // qdbus6를 사용하여 KWin에 직접 데스크톱 전환을 요청합니다.
                            // 이는 API 호환성 문제를 피할 수 있는 가장 확실한 방법입니다.
                            executable.connectSource("qdbus6 org.kde.KWin /VirtualDesktopManager org.kde.KWin.VirtualDesktopManager.current " + desktopGroup.targetDesktop);
                        }
                    }

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
                                // Activity 필터 추가로 초기 로딩 안정성 확보
                                filterByActivity: true
                                // 동일 앱 그룹화 해제: 모든 창을 개별 아이콘으로 표시
                                groupMode: TaskManager.TasksModel.GroupDisabled
                            }

                            delegate: Rectangle {
                                // [수정된 핵심 로직]
                                // 1. model.IsOnAllDesktops가 true인 경우(초기 로딩 시 흔히 발생)
                                //    해당 창이 실제로 현재 데스크톱에 활성화된 경우에만 보여줍니다.
                                // 2. 정상적인 상태라면 해당 데스크톱의 아이콘만 보여줍니다.
                                // 3. Plasma 6의 VirtualDesktops 속성을 직접 확인하여 필터링 안정성을 높입니다.
                                visible: {
                                    if (model.IsOnAllDesktops === true) {
                                        return vdInfo.currentDesktop === desktopGroup.targetDesktop;
                                    }
                                    if (model.VirtualDesktops !== undefined && model.VirtualDesktops.length > 0) {
                                        return model.VirtualDesktops.indexOf(desktopGroup.targetDesktop) !== -1;
                                    }
                                    return false; 
                                }

                                width: visible ? 28 : 0
                                height: visible ? 28 : 0
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
                                        const taskIndex = tasksModel.index(index, 0);
                                        if (model.IsActive === true) {
                                            // 이미 활성화된 창이면 최소화
                                            tasksModel.requestToggleMinimized(taskIndex);
                                        } else {
                                            // 활성화되지 않은 창이면 활성화
                                            tasksModel.requestActivate(taskIndex);
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
}