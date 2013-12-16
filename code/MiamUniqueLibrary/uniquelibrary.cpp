#include "uniquelibrary.h"

#include "ui_uniquelibrary.h"

#include "flowlayout.h"

#include <QPushButton>

#include <QtDebug>

#include "albumform.h"

UniqueLibrary::UniqueLibrary(QWidget *parent) :
	QWidget(parent), ui(new Ui::UniqueLibrary), _sqlModel(NULL)
{
	ui->setupUi(this);
	_flowLayout = new FlowLayout();
	ui->scrollArea->setWidgetResizable(true);
	ui->scrollArea->widget()->setLayout(_flowLayout);
}

void UniqueLibrary::init(LibrarySqlModel *sql)
{
	_sqlModel = sql;

	connect(_sqlModel, &LibrarySqlModel::modelAboutToBeReset, this, &UniqueLibrary::reset);
	connect(_sqlModel, &LibrarySqlModel::trackExtractedFromFS, this, &UniqueLibrary::insertTrackFromFile);
	connect(_sqlModel, &LibrarySqlModel::trackExtractedFromDB, this, &UniqueLibrary::insertTrackFromRecord);
}

void UniqueLibrary::insertTrackFromRecord(const QSqlRecord &record)
{
	int i = -1;
	const QString artist = record.value(++i).toString();
	const QString artistAlbum = record.value(++i).toString();
	const QString album = record.value(++i).toString();
	const QString title = record.value(++i).toString();
	int discNumber = record.value(++i).toInt();
	int year = record.value(++i).toInt();
	const QString absPath = record.value(++i).toString();
	const QString file = record.value(++i).toString();
	this->insertTrack(absPath + QDir::separator() + file, artistAlbum, artist, album, discNumber, title, year);
}

void UniqueLibrary::insertTrackFromFile(const FileHelper &fh)
{
	this->insertTrack(fh.fileInfo().absoluteFilePath(), fh.artistAlbum(), fh.artist(), fh.album(), fh.discNumber(),
					  fh.title(), fh.year().toInt());
}

void UniqueLibrary::insertTrack(const QString &absFilePath, const QString &artistAlbum, const QString &artist, const QString &album,
				 int discNumber, const QString &title, int year)
{
	QString theArtist = artistAlbum.isEmpty() ? artist : artistAlbum;
	AlbumForm *wAlbum = NULL;
	if (_albums.contains(album)) {
		wAlbum = _albums.value(album);
	} else {
		wAlbum = new AlbumForm();
		wAlbum->setArtist(theArtist);
		wAlbum->setAlbum(album, year);
		wAlbum->setDiscNumber(discNumber);
		_albums.insert(album, wAlbum);
		ui->scrollArea->widget()->layout()->addWidget(wAlbum);
	}
	wAlbum->appendTrack(title);
}

void UniqueLibrary::reset()
{
	_albums.clear();
	while (QLayoutItem* item = _flowLayout->takeAt(0)) {
		delete item->widget();
		delete item;
	}
}
