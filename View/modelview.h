#ifndef CPP4_3DVIEWER_V2_0_SRC_VIEW_MODELVIEW_H_
#define CPP4_3DVIEWER_V2_0_SRC_VIEW_MODELVIEW_H_

#include <QVector3D>
#include <QtQuick3D/QQuick3DGeometry>
#include <algorithm>

#include "controller.h"
#include "modelcore.h"

namespace s21 {

class ModelFacade;

class ModelView : public QQuick3DGeometry {
  Q_OBJECT
  QML_NAMED_ELEMENT(modelView);

 public:
  ModelView();
  ModelView(s21::Controller* c) : controller_(c) {}

  Q_INVOKABLE void translation(float x, float y, float z);
  Q_INVOKABLE void rotation(float x, float y, float z);
  Q_INVOKABLE void scaling(float x, float y, float z);
  Q_INVOKABLE void loadFile(QString _path);
  long num_of_vertex;
  long num_of_faces;
  QString path;
  std::vector<Vertex> vertices;
  std::vector<Triangle> triangles;
  std::vector<Line> lines;

 private:
  Controller* controller_;
  float rotate_x = 0.0;
  float rotate_y = 0.0;
  float rotate_z = 0.0;
  float translation_x = 0.0;
  float translation_y = 0.0;
  float translation_z = 0.0;
  float scale_x = 0.0;
  float scale_y = 0.0;
  float scale_z = 0.0;
  int line_type_flag = 0;
  void UpdateGeometry();

  ModelFacade* facade_;

 public slots:
  long get_num_of_vertexe();
  long get_num_of_faces();
  void set_solid();
  void set_dodet();
  void set_lines();
  void set_textur();
};

}  // namespace s21

#endif  // CPP4_3DVIEWER_V2_0_SRC_VIEW_MODELVIEW_H_
