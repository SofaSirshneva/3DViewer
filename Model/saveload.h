#ifndef CPP4_3DVIEWER_V2_0_SRC_MODEL_SAVELOAD_H_
#define CPP4_3DVIEWER_V2_0_SRC_MODEL_SAVELOAD_H_
#include <QObject>
#include <QQuickItem>
#include <fstream>
#include <string>

namespace s21 {
class SaveLoad : public QObject {
  Q_OBJECT
 public:
  SaveLoad() = default;

 public slots:
  void save(QString _path, int type_cum, int tex_or_line, int skelet_model,
            int vex_model, float cum_axis_x, float cum_axis_y, float cum_axis_z,
            float bold_lines, float bold_points, float rotate_x, float rotate_y,
            float rotate_z, float translation_x, float translation_y,
            float translation_z, float scale_x, float scale_y, float scale_z,
            QColor dot_color, QColor model_color, QColor bgk_color,
            QString path);
  void load(QString path);
  int get_skelet_model();
  int get_vex_model();
  int get_type_cum();
  int get_tex_or_line();
  float get_cum_axis_x();
  float get_cum_axis_y();
  float get_cum_axis_z();
  float get_bold_lines();
  float get_bold_points();
  float get_rotate_x();
  float get_rotate_y();
  float get_rotate_z();
  float get_translation_x();
  float get_translation_y();
  float get_translation_z();
  float get_scale_x();
  float get_scale_y();
  float get_scale_z();
  QColor get_dot_color();
  QColor get_model_color();
  QColor get_bgk_color();
  QString get_path();

 private:
  int _skelet_model;
  int _vex_model;
  int _type_cum;
  int _tex_or_line;
  float _cum_axis_x;
  float _cum_axis_y;
  float _cum_axis_z;
  float _bold_lines;
  float _bold_points;
  float _rotate_x = 0.0;
  float _rotate_y = 0.0;
  float _rotate_z = 0.0;
  float _translation_x = 0.0;
  float _translation_y = 0.0;
  float _translation_z = 0.0;
  float _scale_x = 0.0;
  float _scale_y = 0.0;
  float _scale_z = 0.0;
  QColor _dot_color;
  QColor _model_color;
  QColor _bgk_color;
  QString _path;
};
}  // namespace s21

#endif  // CPP4_3DVIEWER_V2_0_SRC_MODEL_SAVELOAD_H_
