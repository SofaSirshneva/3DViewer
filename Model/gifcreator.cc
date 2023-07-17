#include "gifcreator.h"

#include "gif.h"

namespace s21 {
void GifCreator::set_filename(const QString& _path) {
  path = _path;
  path = path.remove(0, 7);
}

void GifCreator::create_gif() {
  int status_flag = 0;
  QImage first_image(image_file_pathmask().arg(0));

  if (!first_image.isNull()) {
    GifWriter gif_writer;

    if (GifBegin(&gif_writer, path.toUtf8(),
                 static_cast<uint32_t>(first_image.width()),
                 static_cast<uint32_t>(first_image.height()), 10U)) {
      for (int i = 0; i < 50 && !status_flag; ++i) {
        QImage image(image_file_pathmask().arg(i));
        if (!image.isNull()) {
          if (!GifWriteFrame(&gif_writer,
                             image.convertToFormat(QImage::Format_Indexed8)
                                 .convertToFormat(QImage::Format_RGBA8888)
                                 .constBits(),
                             static_cast<uint32_t>(image.width()),
                             static_cast<uint32_t>(image.height()), 10U)) {
            GifEnd(&gif_writer);
            status_flag = 1;
          }
        } else {
          GifEnd(&gif_writer);
          status_flag = 1;
        }
      }
      GifEnd(&gif_writer);
    }
  }
}

QString GifCreator::image_file_pathmask() {
  QString tmp_dir =
      QStandardPaths::writableLocation(QStandardPaths::TempLocation);

  if (tmp_dir != "") {
    QDir().mkpath(tmp_dir);
  }
  return QDir(tmp_dir).filePath("image_%1.jpg");
}
}  // namespace s21
