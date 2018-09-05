// first answer from this SO question https://stackoverflow.com/questions/45029968/how-do-i-set-the-combobox-width-to-fit-the-largest-item

import QtQuick 2.7
import QtQuick.Controls 2.3

ComboBox {
    id: control

    property bool sizeToContents
    property int modelWidth

    width: (sizeToContents) ? modelWidth + 2*leftPadding + 2*rightPadding : implicitWidth

    delegate: ItemDelegate {
        width: control.width
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        font.weight: control.currentIndex === index ? Font.DemiBold : Font.Normal
        font.family: control.font.family
        font.pointSize: control.font.pointSize
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
    }

    TextMetrics {
        id: textMetrics
    }

    onModelChanged: {
        textMetrics.font = control.font
        for(var i = 0; i < model.length; i++){
            textMetrics.text = model[i]
            modelWidth = Math.max(textMetrics.width, modelWidth)
        }
    }
}
