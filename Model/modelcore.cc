#include "modelcore.h"

namespace s21 {
void ModelCore::RemoveData() {
  triangles.clear();
  lines.clear();
  vertices.clear();
}

std::vector<Vertex>& ModelCore::GetVertices() noexcept { return vertices; }
std::vector<Triangle>& ModelCore::GetTriangles() noexcept { return triangles; }
std::vector<Line>& ModelCore::GetLines() noexcept { return lines; }

void ModelCore::SetTransformationStrategy(TransformationStrategy* strategy) {
  strategy_ = strategy;
}

void ModelCore::TransformVertices(std::vector<Vertex>& vertices, float a,
                                  float b, float c) {
  if (strategy_) strategy_->Transform(vertices, a, b, c);
  strategy_ = nullptr;
}

void TranslationStrategy::Transform(std::vector<Vertex>& vertices, float a,
                                    float b, float c) {
  for (size_t i = 0; i < vertices.size(); ++i) {
    vertices[i].x += a;
    vertices[i].y += b;
    vertices[i].z += c;
  }
}

void RotationStrategy::Transform(std::vector<Vertex>& vertices, float a,
                                 float b, float c) {
  for (size_t i = 0; i < vertices.size(); ++i) {
    float x = vertices[i].x;
    float y = vertices[i].y;
    float z = vertices[i].z;
    vertices[i].x = x * cos(b) * cos(c) - y * cos(b) * sin(c) + z * sin(b);
    vertices[i].y = -z * cos(b) * sin(a) +
                    (cos(c) * sin(a) * sin(b) + cos(a) * sin(c)) * x -
                    (sin(a) * sin(b) * sin(c) - cos(a) * cos(c)) * y;
    vertices[i].z = z * cos(a) * cos(b) -
                    (cos(a) * cos(c) * sin(b) - sin(a) * sin(c)) * x +
                    (cos(a) * sin(b) * sin(c) + cos(c) * sin(a)) * y;
  }
}

void ScalingStrategy::Transform(std::vector<Vertex>& vertices, float a, float b,
                                float c) {
  for (size_t i = 0; i < vertices.size(); ++i) {
    vertices[i].x *= a;
    vertices[i].y *= b;
    vertices[i].z *= c;
  }
}

void ModelCore::SetVertexUV(std::vector<Vertex>::size_type index, float u,
                            float v) {
  if (index < vertices.size()) {
    vertices[index].u = u;
    vertices[index].v = v;
  } else {
    throw std::runtime_error("Invalid vertex index.");
  }
}

Vertex& ModelCore::operator[](std::vector<Vertex>::size_type index) {
  if (index < vertices.size()) {
    return vertices[index];
  } else {
    throw std::runtime_error("Invalid vertex index.");
  }
}

int ModelCore::Parser(const std::string& path) {
  RemoveData();
  int status = 0;
  std::string line;
  std::ifstream file(path);

  if (!file.is_open()) {
    try {
      throw std::runtime_error("Failed to open file.");
    } catch (std::exception& e) {
      status = 1;
    }
    return status;
  }

  while (std::getline(file, line)) {
    std::istringstream iss(line);
    std::string type;
    iss >> type;

    if (type == "v") {
      Vertex vertex;
      if (iss >> vertex.x >> vertex.y >> vertex.z) {
        vertex.u = 1;
        vertex.v = 0;
        vertices.push_back(vertex);
      } else {
        try {
          throw std::runtime_error("Error reading vertex coordinates.");
        } catch (std::exception& e) {
          status = 2;
        }
        break;
      }
    } else if (type == "f") {
      Triangle triangle;
      if (iss >> triangle.vx >> triangle.vy >> triangle.vz) {
        triangle.vx--;
        triangle.vy--;
        triangle.vz--;
        triangles.push_back(triangle);
        if (!status) {
          if (std::fabs(vertices[triangle.vx].u) < 1e-4) {
            if (std::fabs(vertices[triangle.vy].u - 0.5) < 1e-4) {
              vertices[triangle.vz].u = 1;
            } else {
              vertices[triangle.vz].u = 0.5;
              vertices[triangle.vz].v = 1;
              vertices[triangle.vy].u = 1;
            }
          } else if (std::fabs(vertices[triangle.vy].u) < 1e-4) {
            if (std::fabs(vertices[triangle.vx].u - 0.5) < 1e-4) {
              vertices[triangle.vz].u = 1;
            } else {
              vertices[triangle.vz].u = 0.5;
              vertices[triangle.vz].v = 1;
              vertices[triangle.vx].u = 1;
            }
          } else if (std::fabs(vertices[triangle.vz].u) < 1e-4) {
            if (std::fabs(vertices[triangle.vy].u - 0.5) < 1e-4) {
              vertices[triangle.vx].u = 1;
            } else {
              vertices[triangle.vx].u = 0.5;
              vertices[triangle.vx].v = 1;
              vertices[triangle.vy].u = 1;
            }
          } else if (std::fabs(vertices[triangle.vz].u - 0.5) < 1e-4) {
            if (std::fabs(vertices[triangle.vy].u) < 1e-4) {
              vertices[triangle.vx].u = 1;
            } else {
              vertices[triangle.vx].u = 0;
              vertices[triangle.vy].u = 1;
            }
          } else if (std::fabs(vertices[triangle.vx].u - 0.5) < 1e-4) {
            if (std::fabs(vertices[triangle.vy].u) < 1e-4) {
              vertices[triangle.vz].u = 1;
            } else {
              vertices[triangle.vz].u = 0;
              vertices[triangle.vy].u = 1;
            }
          } else if (std::fabs(vertices[triangle.vy].u - 0.5) < 1e-4) {
            if (std::fabs(vertices[triangle.vx].u) < 1e-4) {
              vertices[triangle.vy].u = 1;
            } else {
              vertices[triangle.vz].u = 0.5;
              vertices[triangle.vz].v = 1;
            }
          } else if (std::fabs(vertices[triangle.vx].u - 1) < 1e-4) {
            vertices[triangle.vy].u = 0;
            vertices[triangle.vz].u = 0.5;
            vertices[triangle.vz].v = 1;
          }
          if (!status) {
            Line line;
            line.a = triangle.vx;
            line.b = triangle.vz;
            lines.push_back(line);

            line.a = triangle.vx;
            line.b = triangle.vy;
            lines.push_back(line);

            line.a = triangle.vy;
            line.b = triangle.vz;
            lines.push_back(line);
          }
        }

      } else {
        try {
          throw std::runtime_error("Error reading coordinates.");
        } catch (std::exception& e) {
          status = 2;
        }
        break;
      }
    }
  }

  file.close();
  return status;
}
}  // namespace s21
