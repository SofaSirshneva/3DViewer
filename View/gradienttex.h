#ifndef _CPP4_3DVIEWER_V2_0_SRC_MODEL_GRADIENTTEX_H_
#define _CPP4_3DVIEWER_V2_0_SRC_MODEL_GRADIENTTEX_H_
#include <QColor>
#include <QQuick3DTextureData>
#include <QSize>

namespace s21 {
class GradientTex : public QQuick3DTextureData {
 public:
  Q_OBJECT
  QML_NAMED_ELEMENT(gradientTex);

 public:
  GradientTex();

 public slots:
  void setProperty(QColor color1, QColor color2);
  void setDashed();
  void setSolid();

 private:
  int flag_dashed;
  QColor _color1;
  QColor _color2;
  void RegenerateTextureData();
  QColor linearInterpolate(const QColor &color1, const QColor &color2,
                           float value);
};
}  // namespace s21

#endif  // _CPP4_3DVIEWER_V2_0_SRC_MODEL_GRADIENTTEX_H_
