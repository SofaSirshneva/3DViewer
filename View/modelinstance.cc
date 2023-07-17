#include "modelinstance.h"

namespace s21 {
ModelInstance::ModelInstance(ModelView *model) { _model = model; }

ModelInstance::~ModelInstance() {}

QColor ModelInstance::color() const { return _color; }

void ModelInstance::setColor(const QColor &newColor) {
  if (_color == newColor) return;
  _color = newColor;
  markDirty();
}

void ModelInstance::change() {
  markDirty();
  update();
}

void ModelInstance::change_scale(float scale) {
  _scale = scale;
  markDirty();
  update();
}

QByteArray ModelInstance::getInstanceBuffer(int *instanceCount) {
  QByteArray instanceData;
  for (std::vector<s21::Vertex>::size_type i = 0; i < _model->vertices.size();
       ++i) {
    auto entry = calculateTableEntry(
        {_model->vertices[i].x, _model->vertices[i].y, _model->vertices[i].z},
        {_scale, _scale, _scale}, {0, 0, 0}, _color, {});
    instanceData.append(reinterpret_cast<const char *>(&entry), sizeof(entry));
  }
  *instanceCount = _model->vertices.size();
  return instanceData;
}
}  // namespace s21
