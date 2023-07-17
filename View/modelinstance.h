#ifndef CPP4_3DVIEWER_V2_0_SRC_VIEW_MODELINSTANCE_H_
#define CPP4_3DVIEWER_V2_0_SRC_VIEW_MODELINSTANCE_H_

#include <QQuick3DInstancing>

#include "modelview.h"

namespace s21 {
class ModelInstance : public QQuick3DInstancing {
  Q_OBJECT
  QML_NAMED_ELEMENT(modelInstance);

 public:
  ModelInstance(ModelView* model);
  ~ModelInstance();
  QColor color() const;
  std::vector<Vertex> vertices;
  Controller* controller_;

 public slots:
  void change();
  void change_scale(float scale);
  void setColor(const QColor& newColor);

 private:
  QColor _color;
  float _scale;
  ModelView* _model;

 protected:
  QByteArray getInstanceBuffer(int* instanceCount);
};
}  // namespace s21

#endif  // CPP4_3DVIEWER_V2_0_SRC_VIEW_MODELINSTANCE_H_
