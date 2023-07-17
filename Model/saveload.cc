#include "saveload.h"

namespace s21 {

void SaveLoad::save(QString _path, int type_cum, int tex_or_line,
                    int skelet_model, int vex_model, float cum_axis_x,
                    float cum_axis_y, float cum_axis_z, float bold_lines,
                    float bold_points, float rotate_x, float rotate_y,
                    float rotate_z, float translation_x, float translation_y,
                    float translation_z, float scale_x, float scale_y,
                    float scale_z, QColor dot_color, QColor model_color,
                    QColor bgk_color, QString path) {
  using std::ofstream;
  _path = _path.remove(0, 7);
  ofstream save_file(_path.toStdString());

  save_file << type_cum << " " << tex_or_line << " " << skelet_model << " "
            << vex_model << " " << cum_axis_x << " " << cum_axis_y << " "
            << cum_axis_z << " " << bold_lines << " " << bold_points << " "
            << rotate_x << " " << rotate_y << " " << rotate_z << " "
            << translation_x << " " << translation_y << " " << translation_z
            << " " << scale_x << " " << scale_y << " " << scale_z << " "
            << dot_color.name().toStdString() << " "
            << model_color.name().toStdString() << " "
            << bgk_color.name().toStdString() << " " << path.toStdString()
            << " ";
  save_file.close();
}

void SaveLoad::load(QString path) {
  path = path.remove(0, 7);
  using std::ifstream;
  std::ifstream file(path.toStdString());
  std::string item;
  std::vector<std::string> elems;
  while (std::getline(file, item, ' ')) {
    elems.push_back(item);
  }

  if (elems.size() == 22) {
    int i = 0;
    _type_cum = std::atoi(elems[i++].c_str());
    _tex_or_line = std::atoi(elems[i++].c_str());
    _skelet_model = std::atoi(elems[i++].c_str());
    _vex_model = std::atoi(elems[i++].c_str());
    _cum_axis_x = std::atof(elems[i++].c_str());
    _cum_axis_y = std::atof(elems[i++].c_str());
    _cum_axis_z = std::atof(elems[i++].c_str());
    _bold_lines = std::atof(elems[i++].c_str());
    _bold_points = std::atof(elems[i++].c_str());
    _rotate_x = std::atof(elems[i++].c_str());
    _rotate_y = std::atof(elems[i++].c_str());
    _rotate_z = std::atof(elems[i++].c_str());
    _translation_x = std::atof(elems[i++].c_str());
    _translation_y = std::atof(elems[i++].c_str());
    _translation_z = std::atof(elems[i++].c_str());
    _scale_x = std::atof(elems[i++].c_str());
    _scale_y = std::atof(elems[i++].c_str());
    _scale_z = std::atof(elems[i++].c_str());
    _dot_color = QColor::fromString(QString::fromStdString(elems[i++]));
    _model_color = QColor::fromString(QString::fromStdString(elems[i++]));
    _bgk_color = QColor::fromString(QString::fromStdString(elems[i++]));
    _path = QString::fromStdString(elems[i++]);
  }
}

int SaveLoad::get_skelet_model() { return _skelet_model; }

int SaveLoad::get_vex_model() { return _vex_model; }

int SaveLoad::get_type_cum() { return _type_cum; }

int SaveLoad::get_tex_or_line() { return _tex_or_line; }

float SaveLoad::get_cum_axis_x() { return _cum_axis_x; }

float SaveLoad::get_cum_axis_y() { return _cum_axis_y; }

float SaveLoad::get_cum_axis_z() { return _cum_axis_z; }

float SaveLoad::get_bold_lines() { return _bold_lines; }

float SaveLoad::get_bold_points() { return _bold_points; }

float SaveLoad::get_rotate_x() { return _rotate_x; }

float SaveLoad::get_rotate_y() { return _rotate_y; }

float SaveLoad::get_rotate_z() { return _rotate_z; }

float SaveLoad::get_translation_x() { return _translation_x; }

float SaveLoad::get_translation_y() { return _translation_y; }

float SaveLoad::get_translation_z() { return _translation_z; }

float SaveLoad::get_scale_x() { return _scale_x; }

float SaveLoad::get_scale_y() { return _scale_y; }

float SaveLoad::get_scale_z() { return _scale_z; }

QColor SaveLoad::get_dot_color() { return _dot_color; }

QColor SaveLoad::get_model_color() { return _model_color; }

QColor SaveLoad::get_bgk_color() { return _bgk_color; }

QString SaveLoad::get_path() { return _path; }
}  // namespace s21
