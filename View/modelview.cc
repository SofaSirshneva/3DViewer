#include "modelview.h"

#include "modelfacade.h"

namespace s21 {

ModelView::ModelView() : facade_(nullptr) {
  line_type_flag = 4;
  int status = 0;
  controller_ = new Controller();
  vertices = controller_->GetVertices();
  triangles = controller_->GetTriangles();
  lines = controller_->GetLines();

  if (!status) {
    num_of_faces = triangles.size();
    num_of_vertex = vertices.size();
    UpdateGeometry();
  }
}

long ModelView::get_num_of_vertexe() {
  UpdateGeometry();
  return this->num_of_vertex;
}

long ModelView::get_num_of_faces() {
  UpdateGeometry();
  return this->num_of_faces;
}

void ModelView::set_solid() {
  if (line_type_flag == 1) {
    line_type_flag = 0;
  } else if (line_type_flag == 3) {
    line_type_flag = 2;
  }
  UpdateGeometry();
  update();
}

void ModelView::set_dodet() {
  if (line_type_flag == 0) {
    line_type_flag = 1;
  } else if (line_type_flag == 2) {
    line_type_flag = 3;
  }
  UpdateGeometry();
  update();
}

void ModelView::set_lines() {
  if (line_type_flag == 3) {
    line_type_flag = 1;
  } else if (line_type_flag == 2) {
    line_type_flag = 0;
  }
  UpdateGeometry();
  update();
}

void ModelView::set_textur() {
  if (line_type_flag == 1) {
    line_type_flag = 3;
  } else if (line_type_flag == 0) {
    line_type_flag = 2;
  }
  UpdateGeometry();
  update();
}

void ModelView::UpdateGeometry() {
  this->clear();
  QByteArray v;
  QByteArray t;
  if (line_type_flag == 0) {
    setPrimitiveType(QQuick3DGeometry::PrimitiveType::Lines);
    t.resize(lines.size() * sizeof(Line));
    memcpy(t.data(), lines.data(), lines.size() * sizeof(Line));
  } else if (line_type_flag == 1) {
    setPrimitiveType(QQuick3DGeometry::PrimitiveType::Points);
    t.resize(lines.size() * sizeof(Line));
    memcpy(t.data(), lines.data(), lines.size() * sizeof(Line));
  } else if (line_type_flag == 2) {
    setPrimitiveType(QQuick3DGeometry::PrimitiveType::Triangles);
    t.resize(triangles.size() * sizeof(Triangle));
    memcpy(t.data(), triangles.data(), triangles.size() * sizeof(Triangle));
  } else if (line_type_flag == 4) {
    setPrimitiveType(QQuick3DGeometry::PrimitiveType::Points);
  }
  v.resize(vertices.size() * sizeof(Vertex));
  setStride(sizeof(Vertex));
  memcpy(v.data(), vertices.data(), vertices.size() * sizeof(Vertex));
  setVertexData(v);
  setIndexData(t);
  QVector3D boundsMin, boundsMax;
  for (size_t i = 0; i < vertices.size(); ++i) {
    boundsMin[0] = (std::min(vertices[i].x, boundsMin[0]));
    boundsMin[1] = (std::min(vertices[i].y, boundsMin[1]));
    boundsMin[2] = (std::min(vertices[i].z, boundsMin[2]));
    boundsMax[0] = (std::max(vertices[i].x, boundsMax[0]));
    boundsMax[1] = (std::max(vertices[i].y, boundsMax[1]));
    boundsMax[2] = (std::max(vertices[i].z, boundsMax[2]));
  }
  setBounds(boundsMin, boundsMax);
  addAttribute(QQuick3DGeometry::Attribute::PositionSemantic, 0,
               QQuick3DGeometry::Attribute::F32Type);
  addAttribute(QQuick3DGeometry::Attribute::IndexSemantic, 0,
               QQuick3DGeometry::Attribute::U32Type);
  addAttribute(Attribute::NormalSemantic, 0, Attribute::F32Type);
  addAttribute(QQuick3DGeometry::Attribute::TexCoord0Semantic,
               3 * sizeof(float), QQuick3DGeometry::Attribute::F32Type);
}

void ModelView::translation(float x, float y, float z) {
  controller_->PerformTranslation(vertices, (x - translation_x) * 0.1,
                                  (y - translation_y) * 0.1,
                                  (z - translation_z) * 0.1);
  translation_x = x;
  translation_y = y;
  translation_z = z;
  UpdateGeometry();
  update();
}

void ModelView::rotation(float x, float y, float z) {
  controller_->PerformRotation(vertices, (x - rotate_x) * 0.017,
                               (y - rotate_y) * 0.017, (z - rotate_z) * 0.017);
  rotate_x = x;
  rotate_y = y;
  rotate_z = z;
  UpdateGeometry();
  update();
}

void ModelView::scaling(float x, float y, float z) {
  controller_->PerformScaling(vertices, pow(1.1, x - scale_x),
                              pow(1.1, y - scale_y), pow(1.1, z - scale_z));
  scale_x = x;
  scale_y = y;
  scale_z = z;
  UpdateGeometry();
  update();
}

void ModelView::loadFile(QString _path) {
  int status = 0;
  path = _path;
  path = path.remove(0, 7);
  status = controller_->Parser(path.toStdString().c_str());
  vertices = controller_->GetVertices();
  triangles = controller_->GetTriangles();
  lines = controller_->GetLines();
  if (!status) {
    num_of_faces = triangles.size();
    num_of_vertex = vertices.size();
    UpdateGeometry();
    update();
  }
}

}  // namespace s21
