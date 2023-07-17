#include "gradienttex.h"

namespace s21 {
GradientTex::GradientTex() {
  _color1 = QColor(0, 0, 0);
  _color2 = QColor(0, 0, 0, 0);
  flag_dashed = 0;
  RegenerateTextureData();
  update();
}

void GradientTex::setProperty(QColor color1, QColor color2) {
  _color1 = color1;
  _color2 = color2;
  RegenerateTextureData();
  update();
}

void GradientTex::setDashed() {
  flag_dashed = 1;
  RegenerateTextureData();
  update();
}

void GradientTex::setSolid() {
  flag_dashed = 0;
  RegenerateTextureData();
  update();
}

QColor GradientTex::linearInterpolate(const QColor &color1,
                                      const QColor &color2, float value) {
  QColor output;

  output.setRedF(color1.redF() + (value * (color2.redF() - color1.redF())));
  output.setGreenF(color1.greenF() +
                   (value * (color2.greenF() - color1.greenF())));
  output.setBlueF(color1.blueF() + (value * (color2.blueF() - color1.blueF())));

  return output;
}

void GradientTex::RegenerateTextureData() {
  int width = 2;
  int height = 1;
  QByteArray texturData;
  QByteArray singleLine;
  singleLine.resize(width * 4 * sizeof(float));
  float *p = reinterpret_cast<float *>(singleLine.data());
  for (int i = 0; i < width; ++i) {
    if (i < width / 2 || !flag_dashed) {
      *p++ = _color1.redF();
      *p++ = _color1.greenF();
      *p++ = _color1.blueF();
      *p++ = _color1.alphaF();
    } else {
      *p++ = _color2.redF();
      *p++ = _color2.greenF();
      *p++ = _color2.blueF();
      *p++ = _color2.alphaF();
    }
  }
  for (int j = 0; j < height; ++j) {
    texturData += singleLine;
  }
  setSize(QSize(width, height));
  setFormat(QQuick3DTextureData::Format::RGBA32F);
  setHasTransparency(false);
  setTextureData(texturData);
}
}  // namespace s21
