#include <QtQuick3D/qquick3d.h>

#include <QApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtGui>

#include "gifcreator.h"
#include "gradienttex.h"
#include "modelinstance.h"
#include "modelview.h"
#include "saveload.h"

int main(int argc, char *argv[]) {
  s21::SaveLoad save_load;
  s21::ModelCore &model = s21::ModelCore::GetInstance();
  s21::Controller controller(&model);
  s21::ModelView view(&controller);
  s21::GradientTex texture;
  s21::ModelInstance instance(&view);
  QGuiApplication app(argc, argv);
  s21::GifCreator gif;
  qmlRegisterType<s21::ModelView>("models", 1, 0, "ModelView");
  qmlRegisterType<s21::GradientTex>("gradientTex", 1, 0, "GradientTex");
  QSurfaceFormat::setDefaultFormat(QQuick3D::idealSurfaceFormat(3));
  QQmlApplicationEngine engine;
  QQmlContext *context = engine.rootContext();
  context->setContextProperty("model_context", &view);
  context->setContextProperty("inst", &instance);
  context->setContextProperty("save_load", &save_load);
  context->setContextProperty("gif_creator", &gif);
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
  if (engine.rootObjects().isEmpty()) return -1;
  return app.exec();
}
