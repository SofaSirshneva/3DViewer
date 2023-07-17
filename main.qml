//! [import]
import QtQuick
import QtQml 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick3D
import Qt.labs.platform 1.1
import QtQuick3D.Helpers
import models
import gradientTex
//! [import]


ApplicationWindow {
    id: window
    width: 1920
    height: 1080
    visible: true
    property bool closing: false
    title: file_dialog.file


    Component.onCompleted: {
        onTriggered: {
            settings_dialog.open()
        }

    }
    onClosing: {
        close.accepted = closing
        save_dialog.open()
    }


    MenuBar {
        Menu {
            title: "file"
            MenuItem {
                text: "open"
                shortcut: "Ctrl+O"
                onTriggered: file_dialog.open()
            }
        }
    }

    FileDialog {
        id: settings_dialog
        title: "Choose file"
        onAccepted: {
            save_load.load(settings_dialog.file)
            save_dialog.file = save_load.get_path()
            alic.checked = save_load.get_type_cum()
            textura.checked = save_load.get_tex_or_line()
            central.checked = !save_load.get_type_cum()
            liniya.checked = save_load.get_tex_or_line()
            solid.checked = !save_load.get_skelet_model()
            dotted.checked = save_load.get_skelet_model()
            combo.currentIndex = save_load.get_vex_model()
            xAxis.value = save_load.get_cum_axis_x()
            yAxis.value = save_load.get_cum_axis_y()
            zAxis.value = save_load.get_cum_axis_z()
            bold_line.value = save_load.get_bold_lines()
            bold_dodet.value = save_load.get_bold_points()
            xmoveAxis.value = save_load.get_rotate_x()
            ymoveAxis.value = save_load.get_rotate_y()
            zmoveAxis.value = save_load.get_rotate_z()
            spin_x_move.value = save_load.get_translation_x()
            spin_y_move.value = save_load.get_translation_y()
            spin_z_move.value = save_load.get_translation_z()
            spin_x_scaling.value = save_load.get_scale_x()
            spin_y_scaling.value = save_load.get_scale_y()
            spin_z_scaling.value = save_load.get_scale_z()
            bkg_dialog.color = save_load.get_bgk_color()
            file_dialog.file = save_load.get_path()
            model_context.loadFile(file_dialog.file)
            num_of_vex.text = model_context.get_num_of_vertexe()
            num_of_face.text = model_context.get_num_of_faces()
            model_context.rotation(xmoveAxis.value, ymoveAxis.value, zmoveAxis.value)
            model_context.translation(spin_x_move.value, spin_y_move.value, spin_z_move.value)
            model_context.scaling(spin_x_scaling.value, spin_y_scaling.value, spin_z_scaling.value)
            inst.change()
            edge_dialog.color = save_load.get_dot_color()
            model_dialog.color = save_load.get_model_color()
            gradient_tex.setProperty(save_load.get_model_color(), save_load.get_bgk_color())
            if(save_load.get_tex_or_line() === 1)
                model_context.set_textur()
            else
                model_context.set_lines()
            if(save_load.get_vex_model() === 1)
                krug.source = "#Sphere"
            else if (save_load.get_vex_model() === 2)
                krug.source = "#Cube"
            inst.change_scale(save_load.get_bold_points() / 10000)
            inst.setColor(save_load.get_dot_color())

        }
        onRejected: {
            file_dialog.open()

        }
    }
    FileDialog {
        id: save_dialog
        title: "Choose file"
        fileMode: FileDialog.SaveFile
        onAccepted: {
            save_load.save(save_dialog.file,
                           alic.checked,
                           textura.checked,
                           dotted.checked,
                           combo.currentIndex,
                           xAxis.value,
                           yAxis.value,
                           zAxis.value,
                           bold_line.value,
                           bold_dodet.value,
                           xmoveAxis.value,
                           ymoveAxis.value,
                           zmoveAxis.value,
                           spin_x_move.value,
                           spin_y_move.value,
                           spin_z_move.value,
                           spin_x_scaling.value,
                           spin_y_scaling.value,
                           spin_z_scaling.value,
                           edge_dialog.color,
                           model_dialog.color,
                           bkg_dialog.color,
                           file_dialog.file)
            closing = true
            window.close()
        }
        onRejected: {
            closing = true
            window.close()
        }
    }

    FileDialog {
        id: file_dialog
        title: "Choose file"
        defaultSuffix: "obj"
        nameFilters: ["3D files (*.obj)"]
        onAccepted: {
            model_context.loadFile(file_dialog.file)
            num_of_vex.text = model_context.get_num_of_vertexe()
            num_of_face.text = model_context.get_num_of_faces()
            inst.change()
        }
    }
    FileDialog {
        id: screen_dialog
        title: "Choose file"
        nameFilters: ["Image files(*.png *.jpg *.bmp)"]
        fileMode: FileDialog.SaveFile
        onAccepted: {
            view.grabToImage(function(result) {
                result.saveToFile(screen_dialog.file);
            })
        }
    }

    FileDialog {
        id: gif_dialog
        title: "Choose file"
//        nameFilters: ["Image files(*.gif)"]
        fileMode: FileDialog.SaveFile
        onAccepted: {
            gif_creator.set_filename(gif_dialog.file);
            gif_time.start();
        }
    }

    Timer {
        id:gif_time
        interval: 100
        repeat: true
        triggeredOnStart: true
        property int frameNumber: 0
        property int frameCount: 50
        onRunningChanged: {
            if (running) {
                frameNumber = 0;
            } else {
                gif_creator.create_gif();
            }
        }
        onTriggered: {
            if (frameNumber < frameCount) {
                var frame_number =frameNumber;

                view.grabToImage(function(result) {
                    result.saveToFile(gif_creator.image_file_pathmask().arg(frame_number));
                }, Qt.size(640, 480));
                frameNumber = frameNumber + 1;
            } else {
                stop();
            }
        }
    }

    GridLayout {
        id: gridlay
        anchors.fill: parent
        columns: 40
        rows: 3
        rowSpacing: 0
        columnSpacing: 0

        // Блок отвечающий за камеру ========================

        Frame {
//            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.column: 0
            Layout.columnSpan: 1
            Layout.row: 0
            background: Rectangle {
                color: "transparent"
                border.color: "black"
                width: 333
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "lightsteelblue" }
                    GradientStop { position: 1.0; color: "slategray" }
            }
            radius: 2
            }
            GridLayout {
                id: cum_lay
                anchors.fill: parent
                columns: 15
                rows: 14

                Label {
                    text: "Camera"
                    color: "black"
                    font.bold: true
                    Layout.column: 8
                    Layout.columnSpan: 3
                    Layout.row: 0
                }
                Label {
                    text: "Camera Position"
                    font.pointSize: 10
                    color: "black"
                    font.bold: true
                    Layout.column: 3
                    Layout.columnSpan: 5
                    Layout.row: 1
                }
                Label {
                    text: "Axis X"
                    color: "black"
                    font.bold: true
                    font.pointSize: 10
                    Layout.column: 1
                    Layout.columnSpan: 5
                    Layout.row: 2
                }

                Label {
                    text: "Axis Y"
                    color: "black"
                    font.bold: true
                    font.pointSize: 10
                    Layout.column: 1
                    Layout.columnSpan: 5
                    Layout.row: 3
                }
                Label {
                    text: "Axis Z"
                    color: "black"
                    font.bold: true
                    font.pointSize: 10
                    Layout.column: 1
                    Layout.columnSpan: 5
                    Layout.row: 4
                }
                Label {
                    text: "Bold lines"
                    color: "black"
                    font.bold: true
                    font.pointSize: 10
                    Layout.column: 7
                    Layout.columnSpan: 5
                    Layout.row: 6
                }
                Label {
                    text: "Bold dodets"
                    color: "black"
                    font.bold: true
                    font.pointSize: 10
                    Layout.column: 7
                    Layout.columnSpan: 5
                    Layout.row: 7
                }

                Slider { //поменять цвета всем слайдерам
                    id: xAxis
                    from: -180.0
                    to: 180.0
                    stepSize: 0.5
                    value: 0.0
                    snapMode: Slider.SnapAlways
                    background: Rectangle {
                            x: xAxis.leftPadding
                            y: xAxis.topPadding + xAxis.availableHeight / 2 - height / 2
                            implicitWidth: 80
                            implicitHeight: 4
                            width: xAxis.availableWidth
                            height: implicitHeight
                            radius: 2
                            color: "#bdbebf"

                            Rectangle {
                                width: xAxis.visualPosition * parent.width
                                height: parent.height
                                color: "#0c8082"
                                radius: 2
                            }
                        }

                        handle: Rectangle {
                            x: xAxis.leftPadding + xAxis.visualPosition * (xAxis.availableWidth - width)
                            y: xAxis.topPadding + xAxis.availableHeight / 2 - height / 2
                            radius: 13
                            implicitWidth: 15
                            implicitHeight: 15
                            color: xAxis.pressed ? "#f0f0f0" : "#0366D6"
                            border.color: "#0366D6"
                        }
                    Layout.column: 4
                    Layout.columnSpan: 5
                    Layout.row: 2
                }

                Slider {
                    id: yAxis
                    from: -180.0
                    to: 180.0
                    stepSize: 0.5
                    value: 0.0
                    snapMode: Slider.SnapAlways
                    background: Rectangle {
                            x: yAxis.leftPadding
                            y: yAxis.topPadding + yAxis.availableHeight / 2 - height / 2
                            implicitWidth: 80
                            implicitHeight: 4
                            width: yAxis.availableWidth
                            height: implicitHeight
                            radius: 2
                            color: "#bdbebf"

                            Rectangle {
                                width: yAxis.visualPosition * parent.width
                                height: parent.height
                                color: "#0c8082"
                                radius: 2
                            }
                        }

                        handle: Rectangle {
                            x: yAxis.leftPadding + yAxis.visualPosition * (yAxis.availableWidth - width)
                            y: yAxis.topPadding + yAxis.availableHeight / 2 - height / 2
                            radius: 13
                            implicitWidth: 15
                            implicitHeight: 15
                            color: yAxis.pressed ? "#f0f0f0" : "#0366D6"
                            border.color: "#0366D6"
                        }
                    Layout.column: 4
                    Layout.columnSpan: 5
                    Layout.row: 3
                }

                Slider {
                    id: zAxis
                    from: -180.0
                    to: 180.0
                    stepSize: 0.5
                    value: 0.0
                    background: Rectangle {
                            x: zAxis.leftPadding
                            y: zAxis.topPadding + zAxis.availableHeight / 2 - height / 2
                            implicitWidth: 80
                            implicitHeight: 4
                            width: zAxis.availableWidth
                            height: implicitHeight
                            radius: 2
                            color: "#bdbebf"

                            Rectangle {
                                width: zAxis.visualPosition * parent.width
                                height: parent.height
                                color: "#0c8082"
                                radius: 2
                            }
                        }

                        handle: Rectangle {
                            x: zAxis.leftPadding + zAxis.visualPosition * (zAxis.availableWidth - width)
                            y: zAxis.topPadding + zAxis.availableHeight / 2 - height / 2
                            radius: 13
                            implicitWidth: 15
                            implicitHeight: 15
                            color: zAxis.pressed ? "#f0f0f0" : "#0366D6"
                            border.color: "#0366D6"
                        }
                    snapMode: Slider.SnapAlways
                    Layout.column: 4
                    Layout.columnSpan: 5
                    Layout.row: 4
                }

                Slider { //толщина линий
                    id: bold_line
                    from: 0
                    to: 1
                    stepSize: 0.001
                    value: 0.0
                    snapMode: Slider.SnapAlways
                    background: Rectangle {
                            x: bold_line.leftPadding
                            y: bold_line.topPadding + bold_line.availableHeight / 2 - height / 2
                            implicitWidth: 80
                            implicitHeight: 4
                            width: bold_line.availableWidth
                            height: implicitHeight
                            radius: 2
                            color: "#bdbebf"

                            Rectangle {
                                width: bold_line.visualPosition * parent.width
                                height: parent.height
                                color: "#0c8082"
                                radius: 2
                            }
                        }

                        handle: Rectangle {
                            x: bold_line.leftPadding + bold_line.visualPosition * (bold_line.availableWidth - width)
                            y: bold_line.topPadding + bold_line.availableHeight / 2 - height / 2
                            radius: 13
                            implicitWidth: 15
                            implicitHeight: 15
                            color: bold_line.pressed ? "#f0f0f0" : "#0366D6"
                            border.color: "#0366D6"
                        }
                    Layout.column: 10
                    Layout.columnSpan: 5
                    Layout.row: 6
                }
                Slider { //толщина точек
                    id: bold_dodet
                    from: 0
                    to: 1
                    stepSize: 0.001
                    value: 0.0
                    snapMode: Slider.SnapAlways
                    onMoved: {
                        krug.instancing = inst
                        inst.change_scale(bold_dodet.value / 10000)
                    }
                    background: Rectangle {
                            x: bold_dodet.leftPadding
                            y: bold_dodet.topPadding + bold_dodet.availableHeight / 2 - height / 2
                            implicitWidth: 80
                            implicitHeight: 4
                            width: bold_dodet.availableWidth
                            height: implicitHeight
                            radius: 2
                            color: "#bdbebf"

                            Rectangle {
                                width: bold_dodet.visualPosition * parent.width
                                height: parent.height
                                color: "#0c8082"
                                radius: 2
                            }
                        }

                        handle: Rectangle {
                            x: bold_dodet.leftPadding + bold_dodet.visualPosition * (bold_dodet.availableWidth - width)
                            y: bold_dodet.topPadding + bold_dodet.availableHeight / 2 - height / 2
                            radius: 13
                            implicitWidth: 15
                            implicitHeight: 15
                            color: bold_dodet.pressed ? "#f0f0f0" : "#0366D6"
                            border.color: "#0366D6"
                        }
                    Layout.column: 10
                    Layout.columnSpan: 5
                    Layout.row: 7
                }
                Label {
                        text: "Projection Type"
                        color: "black"
                        font.bold: true
                        font.pointSize: 10
                        Layout.column: 11
                        Layout.columnSpan: 7
                        Layout.row: 1

                    }
                Label {
                        text: "Line Type"
                        color: "black"
                        font.bold: true
                        font.pointSize: 10
                        Layout.column: 11
                        Layout.columnSpan: 5
                        Layout.row: 3

                    }
                RowLayout {
                    RadioButton {
                        id: alic
                        onClicked: {
                            view.camera = ortho_cum
                            govno_grishi.controlledObject = ortho_cum
                        }
                        contentItem: Text {
                            text: qsTr("Ortho")
                            color: "black"
                            font.bold: true
                            font.pointSize: 10
                            leftPadding: alic.indicator.width + alic.spacing
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    RadioButton {
                        id: central
                        checked: true
                        onClicked: {
                            view.camera = persp_cum
                            govno_grishi.controlledObject = persp_cum
                        }
                        contentItem: Text {
                            text: qsTr("Persp")
                            color: "black"
                            font.bold: true
                            font.pointSize: 10
                            leftPadding: central.indicator.width + central.spacing
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Layout.column: 10
                    Layout.columnSpan: 8
                    Layout.row: 2
                }
                RowLayout {
                    RadioButton {
                        id: solid
                        onClicked: gradient_tex.setSolid()
                        checked: true
                        contentItem: Text {
                            text: qsTr("Solid")
                            color: "black"
                            font.bold: true
                            font.pointSize: 10
                            leftPadding: solid.indicator.width + solid.spacing
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    RadioButton {
                        id: dotted
                        onClicked: gradient_tex.setDashed()
                        contentItem: Text {
                            text: qsTr("Dotted")
                            color: "black"
                            font.bold: true
                            font.pointSize: 10
                            leftPadding: dotted.indicator.width + dotted.spacing
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Layout.column: 10
                    Layout.columnSpan: 8
                    Layout.row: 4
                }

                RowLayout {
                    RadioButton {
                        id: textura
                        onClicked: model_context.set_textur()
                        contentItem: Text {
                            text: qsTr("TXT")
                            color: "black"
                            font.bold: true
                            font.pointSize: 10
                            leftPadding: textura.indicator.width + textura.spacing
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    RadioButton {
                        id: liniya
                        checked: true
                        onClicked: model_context.set_lines()
                        contentItem: Text {
                            text: qsTr("LNS")
                            color: "black"
                            font.bold: true
                            font.pointSize: 10
                            leftPadding: liniya.indicator.width + liniya.spacing
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Layout.column: 10
                    Layout.columnSpan: 8
                    Layout.row: 5
                }
                Button {
                    id: reco
                    text: "Record"
                    font.bold: true
                    onClicked: gif_dialog.open()
                    background: Rectangle {
                        radius: 4
                        border.color: "grey"
                        border.width: 1
                        color: reco.pressed ? "red" : "#0c8082"
                    }
                    Layout.column: 1
                    Layout.columnSpan: 6
                    Layout.row: 5
                }
                Button {
                    id: snapshot
                    text: "Snapshot"
                    font.bold: true
                    onClicked: screen_dialog.open()
                    background: Rectangle {
                        radius: 4
                        border.color: "grey"
                        border.width: 1
                        color: snapshot.pressed ? "red" : "#0c8082"
                    }
                    Layout.column: 7
                    Layout.columnSpan: 6
                    Layout.row: 5
                }
                Button {
                    id: offWASD
                    text: "offWASD"
                    font.bold: true
                    onClicked: view.camera = kostil_kirilla
                    background: Rectangle {
                        radius: 4
                        border.color: "grey"
                        border.width: 1
                        color: offWASD.pressed ? "red" : "#0c8082"
                    }
                    Layout.column: 1
                    Layout.columnSpan: 6
                    Layout.row: 6
                }
                ComboBox {
                    id: combo
                    model: ["none", "circle", "square"]
                    onActivated: {
                        if(combo.currentIndex === 0) {
                            krug.source = ""
                        } else if(combo.currentIndex === 1) {
                            krug.source = "#Sphere"
                        } else if(combo.currentIndex === 2) {
                            krug.source = "#Cube"
                        }
                    }

                    contentItem: Text {
                        text: combo.displayText
                        font: combo.font
                        color: "black"
                    }
                    Layout.column: 1
                    Layout.columnSpan: 5
                    Layout.row: 7
                }
            }
        }
// ==============================================================
// Блок отвечающий за манипуляции с Моделью========================
        Frame {
            Layout.column: 0
            Layout.columnSpan: 1
//            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.row: 1
            background: Rectangle {
                color: "transparent"
                border.color: "black"
                width: 333
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "lightsteelblue" }
                    GradientStop { position: 1.0; color: "slategray" }
                }
                radius: 2
            }
            GridLayout {
                id: model_lay
                anchors.fill: parent
                columns: 20
                rows: 14
                Label {
                    text: "Model"
                    color: "black"
                    font.bold: true
                    Layout.column: 9
                    Layout.columnSpan: 5
                    Layout.row: 0
                }
                Label {
                    text: "Moving"
                    font.pointSize: 10
                    color: "black"
                    font.bold: true
                    Layout.column: 10
                    Layout.columnSpan: 5
                    Layout.row: 1
                }
                Label {
                    text: "Scale"
                    font.pointSize: 10
                    color: "black"
                    font.bold: true
                    Layout.column: 15
                    Layout.columnSpan: 5
                    Layout.row: 1
                }
                Label {
                    text: "Rotation"
                    font.pointSize: 11
                    color: "black"
                    font.bold: true
                    Layout.column: 4
                    Layout.columnSpan: 5
                    Layout.row: 1
                }
                Label {
                    text: "Axis X"
                    color: "black"
                    font.bold: true
                    font.pointSize: 10
                    Layout.column: 1
                    Layout.columnSpan: 5
                    Layout.row: 2
                }

                Label {
                    text: "Axis Y"
                    color: "black"
                    font.bold: true
                    font.pointSize: 10
                    Layout.column: 1
                    Layout.columnSpan: 5
                    Layout.row: 3
                }
                Label {
                    text: "Axis Z"
                    color: "black"
                    font.bold: true
                    font.pointSize: 10
                    Layout.column: 1
                    Layout.columnSpan: 5
                    Layout.row: 4
                }
                Label {
                    text: "Model Info"
                    color: "black"
                    font.bold: true
                    font.pointSize: 10
                    Layout.column: 0
                    Layout.columnSpan: 5
                    Layout.row: 5
                }
                Label {
                    text: "V"
                    color: "black"
                    font.bold: true
                    Layout.column: 6
                    Layout.columnSpan: 3
                    Layout.row: 5
                }
                Label {
                    text: "H"
                    color: "black"
                    font.bold: true
                    Layout.column: 10
                    Layout.columnSpan: 3
                    Layout.row: 5
                }
                Label {
                    id: num_of_vex
                    text: model_context.get_num_of_vertexe()
                    color: "black"
                    font.bold: true
                    font.pointSize: 10
                    Layout.column: 7
                    Layout.columnSpan: 8
                    Layout.row: 5
                }
                Label {
                    id: num_of_face
                    text: model_context.get_num_of_faces()
                    color: "black"
                    font.bold: true
                    font.pointSize: 10
                    Layout.column: 11
                    Layout.columnSpan: 8
                    Layout.row: 5
                }
                SpinBox {
                    id: spin_x_move
                    from: -10000
                    to: 10000
                    implicitHeight: 22
                    implicitWidth: 65
                    onValueModified: {
                        model_context.translation(spin_x_move.value, spin_y_move.value, spin_z_move.value)
                        inst.change()
                    }

                    background: Rectangle {
                        height: parent.height
                        implicitHeight: 5
                        implicitWidth: 10
                        radius: 4
                        color: spin_x_move.up.pressed || spin_x_move.down.pressed ? "#f0f0f0" : "lightsteelblue"
                        border.color: enabled ? "black" : "lightsteelblue"
                    }
                    contentItem: TextInput {
                            z: 2
                            text: spin_x_move.textFromValue(spin_x_move.value, spin_x_move.locale)

                            font: spin_x_move.font
                            color: "black"
                            selectionColor: "black"
                            selectedTextColor: "black"
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                            validator: spin_x_move.validator
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                        }
                    up.indicator: Rectangle {
                        x: parent.width - width
                        height: parent.height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 2
                        color: spin_x_move.up.pressed ? "#054b4d" : "#0c8082"
                        border.color: enabled ? "black" : "lightsteelblue"

                        Text {
                            text: "+"
                            font.pixelSize: spin_x_move.font.pixelSize * 2
                            color: "black"
                            anchors.fill: parent
                            fontSizeMode: Text.Fit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    down.indicator: Rectangle {
                        x: parent.width - width
                        y: parent.height - height
                        height: parent.height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 2
                        color: spin_x_move.down.pressed ? "#054b4d" : "#0c8082"
                        border.color: enabled ? "black" : "lightsteelblue"

                        Text {
                            text: "-"
                            font.pixelSize: spin_x_move.font.pixelSize * 2
                            color: "black"
                            anchors.fill: parent
                            fontSizeMode: Text.Fit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Layout.column: 10
                    Layout.columnSpan: 5
                    Layout.row: 2
                }
                SpinBox {
                    id: spin_y_move
                    from: -10000
                    to: 10000
                    implicitHeight: 22
                    implicitWidth: 65
                    onValueModified: {
                        model_context.translation(spin_x_move.value, spin_y_move.value, spin_z_move.value)
                        inst.change()
                    }

                    background: Rectangle {
                        height: parent.height
                        implicitHeight: 5
                        implicitWidth: 10
                        radius: 4
                        color: spin_y_move.up.pressed || spin_y_move.down.pressed ? "#f0f0f0" : "lightsteelblue"
                        border.color: enabled ? "black" : "lightsteelblue"
                    }
                    contentItem: TextInput {
                            z: 2
                            text: spin_y_move.textFromValue(spin_y_move.value, spin_y_move.locale)

                            font: spin_y_move.font
                            color: "black"
                            selectionColor: "black"
                            selectedTextColor: "black"
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                            validator: spin_y_move.validator
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                        }
                    up.indicator: Rectangle {
                        x: parent.width - width
                        height: parent.height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 2
                        color: spin_y_move.up.pressed ? "#054b4d" : "#0c8082"
                        border.color: enabled ? "black" : "lightsteelblue"

                        Text {
                            text: "+"
                            font.pixelSize: spin_y_move.font.pixelSize * 2
                            color: "black"
                            anchors.fill: parent
                            fontSizeMode: Text.Fit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    down.indicator: Rectangle {
                        x: parent.width - width
                        y: parent.height - height
                        height: parent.height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 2
                        color: spin_y_move.down.pressed ? "#054b4d" : "#0c8082"
                        border.color: enabled ? "black" : "lightsteelblue"

                        Text {
                            text: "-"
                            font.pixelSize: spin_y_move.font.pixelSize * 2
                            color: "black"
                            anchors.fill: parent
                            fontSizeMode: Text.Fit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Layout.column: 10
                    Layout.columnSpan: 5
                    Layout.row: 3
                }
                SpinBox {
                    id: spin_z_move
                    from: -10000
                    to: 10000
                    implicitHeight: 22
                    implicitWidth: 65
                    onValueModified: {
                        model_context.translation(spin_x_move.value, spin_y_move.value, spin_z_move.value)
                        inst.change()
                    }

                    background: Rectangle {
                        height: parent.height
                        implicitHeight: 5
                        implicitWidth: 10
                        radius: 4
                        color: spin_z_move.up.pressed || spin_z_move.down.pressed ? "#f0f0f0" : "lightsteelblue"
                        border.color: enabled ? "black" : "lightsteelblue"
                    }
                    contentItem: TextInput {
                            z: 2
                            text: spin_z_move.textFromValue(spin_z_move.value, spin_z_move.locale)

                            font: spin_z_move.font
                            color: "black"
                            selectionColor: "black"
                            selectedTextColor: "black"
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                            validator: spin_z_move.validator
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                        }
                    up.indicator: Rectangle {
                        x: parent.width - width
                        height: parent.height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 2
                        color: spin_z_move.up.pressed ? "#054b4d" : "#0c8082"
                        border.color: enabled ? "black" : "lightsteelblue"

                        Text {
                            text: "+"
                            font.pixelSize: spin_z_move.font.pixelSize * 2
                            color: "black"
                            anchors.fill: parent
                            fontSizeMode: Text.Fit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    down.indicator: Rectangle {
                        x: parent.width - width
                        y: parent.height - height
                        height: parent.height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 2
                        color: spin_z_move.down.pressed ? "#054b4d" : "#0c8082"
                        border.color: enabled ? "black" : "lightsteelblue"

                        Text {
                            text: "-"
                            font.pixelSize: spin_z_move.font.pixelSize * 2
                            color: "black"
                            anchors.fill: parent
                            fontSizeMode: Text.Fit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Layout.column: 10
                    Layout.columnSpan: 5
                    Layout.row: 4
                }
                SpinBox { //поменять цвета в боксах
                    id: spin_x_scaling
                    from: -10000
                    to: 10000
                    implicitHeight: 22
                    implicitWidth: 65

                    onValueModified: {
                        model_context.scaling(spin_x_scaling.value, spin_y_scaling.value, spin_z_scaling.value)
                        inst.change()
                    }

                    background: Rectangle {
                        height: parent.height
                        implicitHeight: 5
                        implicitWidth: 10
                        radius: 4
                        color: spin_x_scaling.up.pressed || spin_x_scaling.down.pressed ? "#f0f0f0" : "lightsteelblue"
                        border.color: enabled ? "black" : "lightsteelblue"
                    }
                    contentItem: TextInput {
                            z: 2
                            text: spin_x_scaling.textFromValue(spin_x_scaling.value, spin_x_scaling.locale)

                            font: spin_x_scaling.font
                            color: "black"
                            selectionColor: "black"
                            selectedTextColor: "black"
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                            validator: spin_x_scaling.validator
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                        }
                    up.indicator: Rectangle {
                        x: parent.width - width
                        height: parent.height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 2
                        color: spin_x_scaling.up.pressed ? "#054b4d" : "#0c8082"
                        border.color: enabled ? "black" : "lightsteelblue"

                        Text {
                            text: "+"
                            font.pixelSize: spin_x_scaling.font.pixelSize * 2
                            color: "black"
                            anchors.fill: parent
                            fontSizeMode: Text.Fit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    down.indicator: Rectangle {
                        x: parent.width - width
                        y: parent.height - height
                        height: parent.height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 2
                        color: spin_x_scaling.down.pressed ? "#054b4d" : "#0c8082"
                        border.color: enabled ? "black" : "lightsteelblue"

                        Text {
                            text: "-"
                            font.pixelSize: spin_x_scaling.font.pixelSize * 2
                            color: "black"
                            anchors.fill: parent
                            fontSizeMode: Text.Fit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Layout.column: 15
                    Layout.columnSpan: 5
                    Layout.row: 2
                }
                SpinBox {
                    id: spin_y_scaling
                    from: -10000
                    to: 10000
                    implicitHeight: 22
                    implicitWidth: 65

                    onValueModified: {
                        model_context.scaling(spin_x_scaling.value, spin_y_scaling.value, spin_z_scaling.value)
                        inst.change()
                    }

                    background: Rectangle {
                        height: parent.height
                        implicitHeight: 5
                        implicitWidth: 10
                        radius: 4
                        color: spin_y_scaling.up.pressed || spin_y_scaling.down.pressed ? "#f0f0f0" : "lightsteelblue"
                        border.color: enabled ? "black" : "lightsteelblue"
                    }
                    contentItem: TextInput {
                            z: 2
                            text: spin_y_scaling.textFromValue(spin_y_scaling.value, spin_y_scaling.locale)

                            font: spin_y_scaling.font
                            color: "black"
                            selectionColor: "black"
                            selectedTextColor: "black"
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                            validator: spin_y_scaling.validator
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                        }
                    up.indicator: Rectangle {
                        x: parent.width - width
                        height: parent.height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 2
                        color: spin_y_scaling.up.pressed ? "#054b4d" : "#0c8082"
                        border.color: enabled ? "black" : "lightsteelblue"

                        Text {
                            text: "+"
                            font.pixelSize: spin_y_scaling.font.pixelSize * 2
                            color: "black"
                            anchors.fill: parent
                            fontSizeMode: Text.Fit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    down.indicator: Rectangle {
                        x: parent.width - width
                        y: parent.height - height
                        height: parent.height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 2
                        color: spin_y_scaling.down.pressed ? "#054b4d" : "#0c8082"
                        border.color: enabled ? "black" : "lightsteelblue"

                        Text {
                            text: "-"
                            font.pixelSize: spin_y_scaling.font.pixelSize * 2
                            color: "black"
                            anchors.fill: parent
                            fontSizeMode: Text.Fit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Layout.column: 15
                    Layout.columnSpan: 5
                    Layout.row: 3
                }
                SpinBox {
                    id: spin_z_scaling
                    from: -10000
                    to: 10000
                    implicitHeight: 22
                    implicitWidth: 65

                    onValueModified: {
                        model_context.scaling(spin_x_scaling.value, spin_y_scaling.value, spin_z_scaling.value)
                        inst.change()
                    }

                    background: Rectangle {
                        height: parent.height
                        implicitHeight: 5
                        implicitWidth: 10
                        radius: 4
                        color: spin_z_scaling.up.pressed || spin_z_scaling.down.pressed ? "#f0f0f0" : "lightsteelblue"
                        border.color: enabled ? "black" : "lightsteelblue"
                    }
                    contentItem: TextInput {
                            z: 2
                            text: spin_z_scaling.textFromValue(spin_z_scaling.value, spin_z_scaling.locale)

                            font: spin_z_scaling.font
                            color: "black"
                            selectionColor: "black"
                            selectedTextColor: "black"
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                            validator: spin_z_rotation.validator
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                        }
                    up.indicator: Rectangle {
                        x: parent.width - width
                        height: parent.height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 2
                        color: spin_z_scaling.up.pressed ? "#054b4d" : "#0c8082"
                        border.color: enabled ? "black" : "lightsteelblue"

                        Text {
                            text: "+"
                            font.pixelSize: spin_z_scaling.font.pixelSize * 2
                            color: "black"
                            anchors.fill: parent
                            fontSizeMode: Text.Fit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    down.indicator: Rectangle {
                        x: parent.width - width
                        y: parent.height - height
                        height: parent.height / 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius: 2
                        color: spin_z_scaling.down.pressed ? "#054b4d" : "#0c8082"
                        border.color: enabled ? "black" : "lightsteelblue"

                        Text {
                            text: "-"
                            font.pixelSize: spin_z_scaling.font.pixelSize * 2
                            color: "black"
                            anchors.fill: parent
                            fontSizeMode: Text.Fit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Layout.column: 15
                    Layout.columnSpan: 5
                    Layout.row: 4
                }
                Slider {
                    id: xmoveAxis
                    from: -180.0
                    to: 180.0
                    stepSize: 0.5
                    value: 0.0
                    snapMode: Slider.SnapAlways
                    onMoved: {
                        model_context.rotation(xmoveAxis.value, ymoveAxis.value, zmoveAxis.value)
                        inst.change()
                    }
                    background: Rectangle {
                            x: xmoveAxis.leftPadding
                            y: xmoveAxis.topPadding + xmoveAxis.availableHeight / 2 - height / 2
                            implicitWidth: 80
                            implicitHeight: 4
                            width: xmoveAxis.availableWidth
                            height: implicitHeight
                            radius: 2
                            color: "#bdbebf"

                            Rectangle {
                                width: xmoveAxis.visualPosition * parent.width
                                height: parent.height
                                color: "#0c8082"
                                radius: 2
                            }
                        }

                        handle: Rectangle {
                            x: xmoveAxis.leftPadding + xmoveAxis.visualPosition * (xmoveAxis.availableWidth - width)
                            y: xmoveAxis.topPadding + xmoveAxis.availableHeight / 2 - height / 2
                            radius: 13
                            implicitWidth: 15
                            implicitHeight: 15
                            color: xmoveAxis.pressed ? "#f0f0f0" : "#0366D6"
                            border.color: "#0366D6"
                        }
                    Layout.column: 5
                    Layout.columnSpan: 5
                    Layout.row: 2
                }

                Slider {
                    id: ymoveAxis
                    from: -180.0
                    to: 180.0
                    stepSize: 0.5
                    value: 0.0
                    snapMode: Slider.SnapAlways
                    onMoved: {
                        model_context.rotation(xmoveAxis.value, ymoveAxis.value, zmoveAxis.value)
//                        dot_model_context.rotation(xmoveAxis.value, ymoveAxis.value, zmoveAxis.value)
                        inst.change()
                    }
                    background: Rectangle {
                            x: ymoveAxis.leftPadding
                            y: ymoveAxis.topPadding + ymoveAxis.availableHeight / 2 - height / 2
                            implicitWidth: 80
                            implicitHeight: 4
                            width: ymoveAxis.availableWidth
                            height: implicitHeight
                            radius: 2
                            color: "#bdbebf"

                            Rectangle {
                                width: ymoveAxis.visualPosition * parent.width
                                height: parent.height
                                color: "#0c8082"
                                radius: 2
                            }
                        }

                        handle: Rectangle {
                            x: ymoveAxis.leftPadding + ymoveAxis.visualPosition * (ymoveAxis.availableWidth - width)
                            y: ymoveAxis.topPadding + ymoveAxis.availableHeight / 2 - height / 2
                            radius: 13
                            implicitWidth: 15
                            implicitHeight: 15
                            color: ymoveAxis.pressed ? "#f0f0f0" : "#0366D6"
                            border.color: "#0366D6"
                        }
                    Layout.column: 5
                    Layout.columnSpan: 5
                    Layout.row: 3
                }

                Slider {
                    id: zmoveAxis
                    from: -180.0
                    to: 180.0
                    stepSize: 0.5
                    value: 0.0
                    snapMode: Slider.SnapAlways
//                    onMoved: model_context.rotation(xmoveAxis.value, ymoveAxis.value, zmoveAxis.value)
                    onMoved: {
                        model_context.rotation(xmoveAxis.value, ymoveAxis.value, zmoveAxis.value)
//                        dot_model_context.rotation(xmoveAxis.value, ymoveAxis.value, zmoveAxis.value)
                        inst.change()
                    }
                    background: Rectangle {
                            x: zmoveAxis.leftPadding
                            y: zmoveAxis.topPadding + zmoveAxis.availableHeight / 2 - height / 2
                            implicitWidth: 80
                            implicitHeight: 4
                            width: zmoveAxis.availableWidth
                            height: implicitHeight
                            radius: 2
                            color: "#bdbebf"

                            Rectangle {
                                width: zmoveAxis.visualPosition * parent.width
                                height: parent.height
                                color: "#0c8082"
                                radius: 2
                            }
                        }

                        handle: Rectangle {
                            x: zmoveAxis.leftPadding + zmoveAxis.visualPosition * (zmoveAxis.availableWidth - width)
                            y: zmoveAxis.topPadding + zmoveAxis.availableHeight / 2 - height / 2
                            radius: 13
                            implicitWidth: 15
                            implicitHeight: 15
                            color: zmoveAxis.pressed ? "#f0f0f0" : "#0366D6"
                            border.color: "#0366D6"
                        }
                    Layout.column: 5
                    Layout.columnSpan: 5
                    Layout.row: 4
                }
                Layout.column: 1
                Layout.columnSpan: 10
                Layout.row: 2
            }

        }

        // Блок отвечающий за палитру ===========================================================
        Frame {
            Layout.column: 0
            Layout.columnSpan: 1
//            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.row: 2
            background: Rectangle {
                color: "transparent"
                border.color: "black"
                width: 333
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "lightsteelblue" }
                    GradientStop { position: 1.0; color: "slategray" }
                }
                radius: 2
            }
            GridLayout {
                id: color_lay
                anchors.fill: parent
                columns: 16
                rows: 2
                Layout.fillWidth: true

                Label {
                    text: "Color"
                    color: "black"
                    font.bold: true
                    Layout.column: 6
                    Layout.columnSpan: 2
                    Layout.row: 0
                }
                ColorDialog {
                    id: bkg_dialog
                    onAccepted: gradient_tex.setProperty(model_dialog.color, bkg_dialog.color)
                }
                ColorDialog {
                    id: model_dialog
                    onAccepted: gradient_tex.setProperty(model_dialog.color, bkg_dialog.color)
                }
                ColorDialog {
                    id: edge_dialog
                    onAccepted: inst.setColor(edge_dialog.color)
                }

                Button {
                    id: button_bg
                    text: "  Background  "
                    font.bold: true
                    highlighted: true
                    background: Rectangle {
                        radius: 4
                        border.color: "grey"
                        border.width: 1
                        color: button_bg.pressed ? "#054b4d" : "#0c8082"
                    }
                    onClicked: bkg_dialog.open()
                    Layout.column: 0
                    Layout.columnSpan: 3
                    Layout.row: 1
                }

                Button {
                    id: button_model
                    text: "     Model      "
                    font.bold: true
                    highlighted: true
                    background: Rectangle {
                        radius: 4
                        border.color: "grey"
                        border.width: 1
                        color: button_model.pressed ? "#054b4d" : "#0c8082"
                    }
                    onClicked: model_dialog.open()
                    Layout.column: 7
                    Layout.columnSpan: 4
                    Layout.row: 1
                }

                Button {
                    id: button_edge
                    text: "        Point        "
                    font.bold: true
                    highlighted: true
                    background: Rectangle {
                        radius: 4
                        border.color: "grey"
                        border.width: 1
                        color: button_edge.pressed ? "#054b4d" : "#0c8082"
                    }
                    onClicked: edge_dialog.open()
                    Layout.column: 12
                    Layout.columnSpan: 5
                    Layout.row: 1
                }
                Layout.column: 3
                Layout.columnSpan: 10
                Layout.row: 2
            }
        }
        // Блок отвечающий за вывод модели========================

        Node {
            id: basicScene

            WasdController {
                controlledObject: bunny
            }

            //! [camera]
            PerspectiveCamera {
                id: persp_cum
                position: Qt.vector3d(10, 2, 0)
                fieldOfView: 90
                clipFar: 20000
                clipNear: 0.1

            }
            PerspectiveCamera {
                id: kostil_kirilla
                position: Qt.vector3d(10, 2, 0)
                eulerRotation.x: xAxis.value
                eulerRotation.y: yAxis.value - 95
                eulerRotation.z: zAxis.value
                fieldOfView: 90
                clipFar: 20000
                clipNear: 0.1

            }

            OrthographicCamera {
                   id: ortho_cum
                   position: Qt.vector3d(10, 2, 0)
                   eulerRotation.x: xAxis.value
                   eulerRotation.y: yAxis.value - 10
                   eulerRotation.z: zAxis.value
                   clipFar: 10000.0
                   clipNear: 10.0
            }
            //! [camera]


            //! [light]
            DirectionalLight {
                eulerRotation.x: -40
                eulerRotation.y: -40
            }
            PointLight {
                 position: Qt.vector3d(20, 0, 0)
            }
            SpotLight {
                position: Qt.vector3d(0, 0, 0)
                brightness: 1
                eulerRotation: Qt.vector3d(-70, -40, 0)

            }

//            Model {
//                source: "#Rectangle"
//                y: -200
//                scale: Qt.vector3d(15, 15, 15)
//                eulerRotation.x: -90
//                materials: [
//                    DefaultMaterial {
//                        diffuseColor: Qt.rgba(0.8, 0.6, 0.4, 1.0)
//                    }
//                ]
//                Layout.column: 4
//            }
//            Model {
//                source: "#Rectangle"
//                z: -400
//                scale: Qt.vector3d(15, 15, 15)
//                materials: [
//                    DefaultMaterial {
//                        diffuseColor: Qt.rgba(0.8, 0.8, 0.9, 1.0)
//                    }
//                ]
//            }
//            Model {
//                source: "#Cube"
//                position: light1.position
//                rotation: light1.rotation
//                property real size: slider1.highlight ? 0.2 : 0.1
//                scale: Qt.vector3d(size, size, size)
//                materials: [
//                    DefaultMaterial {
//                        diffuseColor: light1.color
//                        opacity: 0.4
//                    }
//                ]
//            }
//            Model {
//                source: "#Cube"
//                position: light2.position
//                rotation: light2.rotation
//                property real size: slider2.highlight ? 0.2 : 0.1
//                scale: Qt.vector3d(size, size, size)
//                materials: [
//                    DefaultMaterial {
//                        diffuseColor: light2.color
//                        opacity: 0.4
//                    }
//                ]
//            }
//            Model {
//                source: "#Cube"
//                position: light4.position
//                rotation: light4.rotation
//                property real size: slider4.highlight ? 0.2 : 0.1
//                scale: Qt.vector3d(size, size, size)
//                materials: [
//                    DefaultMaterial {
//                        diffuseColor: light4.color
//                        opacity: 0.4
//                    }
//                ]
//            }
            //! [light]



            //! [objects]
            Model {
                id: bunny
                position: Qt.vector3d(10, -1, -6)
                geometry: model_context

                y: -100
                scale: Qt.vector3d(36, 36, 36)
                property variant material
                property bool animate: true
//                NumberAnimation on eulerRotation.y {
//                    running: animate
//                    loops: Animation.Infinite
//                    duration: 5000
//                    from: 0
//                    to: -360
//                }
                materials: [ DefaultMaterial {
                        diffuseMap: Texture {
                            textureData: GradientTex {
                                id: gradient_tex
                            }
                            minFilter: Texture.Nearest
                            magFilter: Texture.Nearest
                            mappingMode: Texture.UV
                            scaleU: 4
                            scaleV: 1
                        }

                        lighting: DefaultMaterial.NoLighting
                        cullMode: DefaultMaterial.NoCulling
                        specularAmount: 0.5
                        opacity: bold_line.value


                    }
                ]
            }
            Model {
                id: bunny_dot
                position: Qt.vector3d(10, -1, -6)

                instancing: inst
                y: -100
                scale: Qt.vector3d(36, 36, 36)
                property variant material
                property bool animate: true
//                NumberAnimation on eulerRotation.y {
//                    running: animate
//                    loops: Animation.Infinite
//                    duration: 5000
//                    from: 0
//                    to: -360
//                }

                materials: [ DefaultMaterial {
                        diffuseColor: edge_dialog.color
                        lighting: DefaultMaterial.NoLighting
                        cullMode: DefaultMaterial.NoCulling
                        specularAmount: 0.5
                        lineWidth: 12
                        pointSize: bold_dodet.value
                    }
                ]


            Node {
                Model {
                     id: krug
                     source: ""
                     position: Qt.vector3d(0, 0, 0)
                     instancing: bunny_dot.instancing
                     materials:  DefaultMaterial {
                     diffuseColor: edge_dialog.color
                     lighting: DefaultMaterial.NoLighting
                     cullMode: DefaultMaterial.NoCulling
                     }
                }
            }
        }
    }
        //! [objects]

        View3D {
            id:view
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.column:1
            Layout.columnSpan: 39
            Layout.row: 0
            Layout.rowSpan: 3
            importScene: basicScene
            camera: persp_cum

            //! [environment]
            environment: SceneEnvironment {
                clearColor: bkg_dialog.color
                backgroundMode: SceneEnvironment.Color
            }
            //! [environment]

            //control
            WasdController {
                id: govno_grishi
                controlledObject: persp_cum
                speed: 0.01
            }
        }
    }
}

