#ifndef _CPP4_3DVIEWER_V2_0_SRC_MODEL_MODELCORE_H_
#define _CPP4_3DVIEWER_V2_0_SRC_MODEL_MODELCORE_H_

#include <cmath>
#include <fstream>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <vector>

namespace s21 {
struct Vertex {
  float x;
  float y;
  float z;
  float u;
  float v;
};

struct Triangle {
  int vx;
  int vy;
  int vz;
};

struct Line {
  int a;
  int b;
};

class TransformationStrategy {
 public:
  virtual void Transform(std::vector<Vertex>& vertices, float a, float b,
                         float c) = 0;
  virtual ~TransformationStrategy() {}
};

class TranslationStrategy : public TransformationStrategy {
 public:
  void Transform(std::vector<Vertex>& vertices, float a, float b,
                 float c) override;
};

class RotationStrategy : public TransformationStrategy {
 public:
  void Transform(std::vector<Vertex>& vertices, float a, float b,
                 float c) override;
};

class ScalingStrategy : public TransformationStrategy {
 public:
  void Transform(std::vector<Vertex>& vertices, float a, float b,
                 float c) override;
};

class ModelCore {
 private:
  ModelCore() : strategy_(nullptr) {}
  TransformationStrategy* strategy_;
  std::vector<Vertex> vertices;
  std::vector<Triangle> triangles;
  std::vector<Line> lines;

 public:
  ~ModelCore() { delete strategy_; }
  void RemoveData();
  int Parser(const std::string& path);
  std::vector<Vertex>& GetVertices() noexcept;
  std::vector<Triangle>& GetTriangles() noexcept;
  std::vector<Line>& GetLines() noexcept;
  void SetVertexUV(std::vector<Vertex>::size_type index, float u, float v);
  Vertex& operator[](std::vector<Vertex>::size_type index);

  static ModelCore& GetInstance() {
    static ModelCore instance;
    return instance;
  }

  ModelCore(const ModelCore&) = delete;
  ModelCore& operator=(const ModelCore&) = delete;
  void SetTransformationStrategy(TransformationStrategy* strategy);

  void TransformVertices(std::vector<Vertex>& vertices, float a, float b,
                         float c);
};
}  // namespace s21

#endif  // _CPP4_3DVIEWER_V2_0_SRC_MODEL_MODELCORE_H_
