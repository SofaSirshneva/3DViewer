#ifndef CPP4_3DVIEWER_V2_0_SRC_VIEW_MODELFACADE_H_
#define CPP4_3DVIEWER_V2_0_SRC_VIEW_MODELFACADE_H_

#include "modelview.h"

namespace s21 {

class ModelFacade {
 private:
  ModelView& modelView_;

 public:
  ModelFacade(ModelView& modelView) : modelView_(modelView) {}

  void applyTranslation(float x, float y, float z) {
    modelView_.translation(x, y, z);
  }

  void applyRotation(float x, float y, float z) {
    modelView_.rotation(x, y, z);
  }

  void applyScaling(float x, float y, float z) { modelView_.scaling(x, y, z); }

  void loadFile(const QString& path) { modelView_.loadFile(path); }
};

}  // namespace s21

#endif  // CPP4_3DVIEWER_V2_0_SRC_VIEW_MODELFACADE_H_
