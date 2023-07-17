#ifndef CPP4_3DVIEWER_V2_0_SRC_MODEL_GIFCREATOR_H_
#define CPP4_3DVIEWER_V2_0_SRC_MODEL_GIFCREATOR_H_
#include <QDir>
#include <QImage>
#include <QObject>
#include <QStandardPaths>
#include <QString>

namespace s21 {
class GifCreator : public QObject {
  Q_OBJECT

 public:
  GifCreator() = default;

 public slots:
  void set_filename(const QString& _path);
  void create_gif();
  QString image_file_pathmask();

 private:
  QString path;
};
}  // namespace s21

#endif  // CPP4_3DVIEWER_V2_0_SRC_MODEL_GIFCREATOR_H_
