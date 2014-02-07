
/**
 *
 * gPodder QML UI Reference Implementation
 * Copyright (c) 2013, Thomas Perl <m@thp.io>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
 * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 *
 */

import QtQuick 2.0
import 'common'

Item {
    id: pgst

    GPodderCore { id: py }
    GPodderPlayback { id: player }

    GPodderPodcastListModel { id: podcastListModel }

    property real scalef: width / 480

    anchors.fill: parent

    function update(page, x) {
        var index = -1;
        for (var i=0; i<children.length; i++) {
            if (children[i] === page) {
                index = i;
                break;
            }
        }

        children[index-1].opacity = x / width;
        //children[index-1].pushPhase = x / width;
    }

    property bool loadPageInProgress: false

    function showConfirmation(title, icon, callback) {
        loadPage('Confirmation.qml', {
            title: title,
            icon: icon,
            callback: callback,
        });
    }

    function loadPage(filename, properties) {
        if (pgst.loadPageInProgress) {
            console.log('ignoring loadPage request while load in progress');
            return;
        }

        var component = Qt.createComponent(filename);
        if (component.status != Component.Ready) {
            console.log('Error loading ' + filename + ':' +
                component.errorString());
        }

        if (properties === undefined) {
            properties = {};
        }

        pgst.loadPageInProgress = true;
        component.createObject(pgst, properties);
    }

    PBusyIndicator {
        anchors.centerIn: parent
        visible: !py.ready
    }

    StartPage {
        id: startPage
        visible: py.ready
    }
}
