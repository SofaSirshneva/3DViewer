#ifndef CPP4_3DVIEWER_V2_0_SRC_CONTROLLER_COREMODEL_H_
#define CPP4_3DVIEWER_V2_0_SRC_CONTROLLER_COREMODEL_H_

#include "modelcore.h"

namespace s21 {
class Controller {
 public:
  Controller() = default;
  Controller(ModelCore* m) : model_(m){};
  std::vector<Vertex>& GetVertices() noexcept;
  std::vector<Triangle> GetTriangles() noexcept;
  std::vector<Line> GetLines() noexcept;
  int Parser(const std::string& path);
  void PerformTranslation(std::vector<Vertex>& vertices, float a, float b,
                          float c);
  void PerformRotation(std::vector<Vertex>& vertices, float a, float b,
                       float c);
  void PerformScaling(std::vector<Vertex>& vertices, float a, float b, float c);

 private:
  ModelCore* model_;
};
}  // namespace s21

#endif  // CPP4_3DVIEWER_V2_0_SRC_CONTROLLER_COREMODEL_H_
