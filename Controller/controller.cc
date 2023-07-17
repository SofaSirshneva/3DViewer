#include "controller.h"

namespace s21 {
std::vector<Vertex>& Controller::GetVertices() noexcept {
  return model_->GetVertices();
}

std::vector<Triangle> Controller::GetTriangles() noexcept {
  return model_->GetTriangles();
}

std::vector<Line> Controller::GetLines() noexcept { return model_->GetLines(); }

int Controller::Parser(const std::string& path) { return model_->Parser(path); }

void Controller::PerformTranslation(std::vector<Vertex>& vertices, float a,
                                    float b, float c) {
  TransformationStrategy* translation_strategy = new TranslationStrategy();
  model_->SetTransformationStrategy(translation_strategy);
  model_->TransformVertices(vertices, a, b, c);
  delete translation_strategy;
}

void Controller::PerformRotation(std::vector<Vertex>& vertices, float a,
                                 float b, float c) {
  TransformationStrategy* rotation_strategy = new RotationStrategy();
  model_->SetTransformationStrategy(rotation_strategy);
  model_->TransformVertices(vertices, a, b, c);
  delete rotation_strategy;
}

void Controller::PerformScaling(std::vector<Vertex>& vertices, float a, float b,
                                float c) {
  TransformationStrategy* scaling_strategy = new ScalingStrategy();
  model_->SetTransformationStrategy(scaling_strategy);
  model_->TransformVertices(vertices, a, b, c);
  delete scaling_strategy;
}
}  // namespace s21
