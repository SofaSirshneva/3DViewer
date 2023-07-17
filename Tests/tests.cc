#include <gtest/gtest.h>

#include "modelcore.h"

TEST(Viewer, test_1) {
  s21::ModelCore* model;
  model = &s21::ModelCore::GetInstance();
  int status = model->Parser("./objects/bunny.obj");
  EXPECT_EQ(status, 0);
  EXPECT_EQ(model->GetVertices().size(), 35947);
  EXPECT_EQ(model->GetTriangles().size(), 69451);
  EXPECT_EQ(model->GetLines().size(), 208353);
}

int main(int argc, char** argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}