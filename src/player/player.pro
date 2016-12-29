QT += widgets multimedia sql websockets

TEMPLATE = app

include(qtsingleapplication/qtsingleapplication.pri)

SOURCES += debug/logbrowser.cpp \
    debug/logbrowserdialog.cpp \
    dialogs/colordialog.cpp \
    dialogs/customizeoptionsdialog.cpp \
    dialogs/customizethemedialog.cpp \
    dialogs/customizethemetaglineedit.cpp \
    dialogs/dragdropdialog.cpp \
    dialogs/equalizerdalog.cpp \
    dialogs/reflector.cpp \
    dialogs/starswidget.cpp \
    styling/miamstyle.cpp \
    views/tageditor/albumcover.cpp \
    views/tageditor/tagconverter.cpp \
    views/tageditor/tageditor.cpp \
    views/tageditor/tageditortablewidget.cpp \
    views/viewloader.cpp \
    columnutils.cpp \
    main.cpp \
    mainwindow.cpp \
    pluginmanager.cpp \
    quickstart.cpp \
    tagbutton.cpp \
    taglineedit.cpp \
    tracksnotfoundmessagebox.cpp \
    remotecontrol.cpp \
    minimodewidget.cpp \
    minislider.cpp

HEADERS += debug/logbrowser.h \
    debug/logbrowserdialog.h \
    dialogs/colordialog.h \
    dialogs/customizeoptionsdialog.h \
    dialogs/customizethemedialog.h \
    dialogs/customizethemetaglineedit.h \
    dialogs/dragdropdialog.h \
    dialogs/equalizerdalog.h \
    dialogs/reflector.h \
    dialogs/starswidget.h \
    styling/miamstyle.h \
    views/tageditor/albumcover.h \
    views/tageditor/tagconverter.h \
    views/tageditor/tageditor.h \
    views/tageditor/tageditortablewidget.h \
    views/viewloader.h \
    columnutils.h \
    mainwindow.h \
    pluginmanager.h \
    quickstart.h \
    tagbutton.h \
    taglineedit.h \
    tracksnotfoundmessagebox.h \
    remotecontrol.h \
    minimodewidget.h \
    minislider.h

FORMS += customizeoptionsdialog.ui \
    customizetheme.ui \
    dragdroppopup.ui \
    equalizerdialog.ui \
    mainwindow.ui \
    quickstart.ui \
    tagconverter.ui \
    tageditor.ui \
    minimode.ui
CONFIG += c++11
RESOURCES += player.qrc
win32 {
    OTHER_FILES += config/mp.rc
    RC_FILE += config/mp.rc
    TARGET = MiamPlayer
}
unix:!macx {
    TARGET = miam-player
}
macx {
    TARGET = MiamPlayer
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.9
}

TRANSLATIONS = translations/player_ar.ts \
    translations/player_cs.ts \
    translations/player_de.ts \
    translations/player_el.ts \
    translations/player_en.ts \
    translations/player_es.ts \
    translations/player_fr.ts \
    translations/player_in.ts \
    translations/player_it.ts \
    translations/player_ja.ts \
    translations/player_kr.ts \
    translations/player_pt.ts \
    translations/player_ru.ts \
    translations/player_th.ts \
    translations/player_vn.ts \
    translations/player_zh.ts

CONFIG(debug, debug|release) {
    win32 {
	LIBS += -L$$PWD/../../lib/debug/win-x64/ -ltag
        LIBS += -L$$OUT_PWD/../core/debug/ -lmiam-core
        LIBS += -L$$OUT_PWD/../library/debug/ -lmiam-library
        LIBS += -L$$OUT_PWD/../tabplaylists/debug/ -lmiam-tabplaylists
        LIBS += -L$$OUT_PWD/../uniquelibrary/debug/ -lmiam-uniquelibrary
        QMAKE_POST_LINK += $${QMAKE_COPY} $$shell_path($$PWD/../core/mp.ico) $$shell_path($$OUT_PWD/debug/)
    }
    OBJECTS_DIR = debug/.obj
    MOC_DIR = debug/.moc
    RCC_DIR = debug/.rcc
    UI_DIR = $$PWD
}

CONFIG(release, debug|release) {
    win32 {
	LIBS += -L$$PWD/../../lib/release/win-x64/ -ltag
        LIBS += -L$$OUT_PWD/../core/release/ -lmiam-core
        LIBS += -L$$OUT_PWD/../library/release/ -lmiam-library
        LIBS += -L$$OUT_PWD/../tabplaylists/release/ -lmiam-tabplaylists
        LIBS += -L$$OUT_PWD/../uniquelibrary/release/ -lmiam-uniquelibrary
        QMAKE_POST_LINK += $${QMAKE_COPY} $$shell_path($$PWD/../core/mp.ico) $$shell_path($$OUT_PWD/release/)
    }
    OBJECTS_DIR = release/.obj
    MOC_DIR = release/.moc
    RCC_DIR = release/.rcc
    UI_DIR = $$PWD
}
unix {
    LIBS += -ltag -L$$OUT_PWD/../core/ -lmiam-core
    LIBS += -L$$OUT_PWD/../library/ -lmiam-library
    LIBS += -L$$OUT_PWD/../tabplaylists/ -lmiam-tabplaylists
    LIBS += -L$$OUT_PWD/../uniquelibrary/ -lmiam-uniquelibrary
}
unix:!macx {
    target.path = /usr/bin
    desktop.path = /usr/share/applications
    desktop.files = $$PWD/../../debian/usr/share/applications/miam-player.desktop
    icon64.path = /usr/share/icons/hicolor/64x64/apps
    icon64.files = $$PWD/../../debian/usr/share/icons/hicolor/64x64/apps/application-x-miamplayer.png
    appdata.path = /usr/share/appdata
    appdata.files = $$PWD/../../fedora/miam-player.appdata.xml
    INSTALLS += desktop \
	target \
	icon64 \
	appdata
}
macx {
    LIBS += -L$$PWD/../../lib/osx/ -ltag -L$$OUT_PWD/../core/ -lmiam-core
    ICON = $$PWD/../../osx/MiamPlayer.icns
    QMAKE_SONAME_PREFIX = @executable_path/../Frameworks
    #1 create Framework and PlugIns directories
    #2 copy third party library: TagLib, QtAV
    #3 copy own libs
    QMAKE_POST_LINK += $${QMAKE_MKDIR} $$shell_path($$OUT_PWD/MiamPlayer.app/Contents/Frameworks/) && \
     $${QMAKE_MKDIR} $$shell_path($$OUT_PWD/MiamPlayer.app/Contents/PlugIns/) && \
     $${QMAKE_COPY} $$shell_path($$PWD/../../lib/osx/libtag.dylib) $$shell_path($$OUT_PWD/MiamPlayer.app/Contents/Frameworks/) && \
     $${QMAKE_COPY} $$shell_path($$OUT_PWD/../core/libmiam-core.*.dylib) $$shell_path($$OUT_PWD/MiamPlayer.app/Contents/Frameworks/) && \
     $${QMAKE_COPY} $$shell_path($$OUT_PWD/../library/libmiam-library.*.dylib) $$shell_path($$OUT_PWD/MiamPlayer.app/Contents/Frameworks/) && \
     $${QMAKE_COPY} $$shell_path($$OUT_PWD/../tabplaylists/libmiam-tabplaylists.*.dylib) $$shell_path($$OUT_PWD/MiamPlayer.app/Contents/Frameworks/) && \
     $${QMAKE_COPY} $$shell_path($$OUT_PWD/../uniquelibrary/libmiam-uniquelibrary.*.dylib) $$shell_path($$OUT_PWD/MiamPlayer.app/Contents/Frameworks/)
}

3rdpartyDir  = $$PWD/../core/3rdparty
INCLUDEPATH += $$3rdpartyDir
DEPENDPATH += $$3rdpartyDir

INCLUDEPATH += $$PWD/dialogs $$PWD/filesystem $$PWD/playlists $$PWD/views $$PWD/views/tageditor
INCLUDEPATH += $$PWD/../core
INCLUDEPATH += $$PWD/../library
INCLUDEPATH += $$PWD/../tabplaylists
INCLUDEPATH += $$PWD/../uniquelibrary

DEPENDPATH += $$PWD/dialogs $$PWD/filesystem $$PWD/playlists $$PWD/views $$PWD/views/tageditor
DEPENDPATH += $$PWD/../core
DEPENDPATH += $$PWD/../library
DEPENDPATH += $$PWD/../tabplaylists
DEPENDPATH += $$PWD/../uniquelibrary
