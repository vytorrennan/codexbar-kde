#include <QQmlExtensionPlugin>
#include <qqml.h>
#include <QQmlParserStatus>
#include <QProcess>
#include <QFile>
#include <QUrl>
#include <QTimer>
#include <QDebug>
#include <QFontInfo>
#include <QGuiApplication>
#include <QClipboard>

class Native : public QObject {
  Q_OBJECT
public:
  using QObject::QObject;
  Q_INVOKABLE QString localFile(const QUrl &url) const { return url.isLocalFile() ? url.toLocalFile() : QString(); }
  Q_INVOKABLE void copyText(const QString &text) { QGuiApplication::clipboard()->setText(text); }
  Q_INVOKABLE bool execArgv(const QStringList &args) {
    return !args.isEmpty() && QProcess::startDetached(args.first(), args.mid(1));
  }
  Q_INVOKABLE QString resolveFont(const QString &family) const {
    QFont font = QGuiApplication::font();
    font.setFamily(family);
    return QFontInfo(font).family();
  }
};

class StdioCollector : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString text READ text NOTIFY textChanged)
  Q_PROPERTY(bool waitForEnd MEMBER m_waitForEnd)
public:
  using QObject::QObject;
  QString text() const { return m_text; }
  void finish(const QString &value) { m_text = value; emit textChanged(); emit streamFinished(); }
signals:
  void textChanged();
  void streamFinished();
private:
  QString m_text;
  bool m_waitForEnd = true;
};

class Process : public QObject, public QQmlParserStatus {
  Q_OBJECT
  Q_INTERFACES(QQmlParserStatus)
  Q_PROPERTY(QStringList command MEMBER m_command)
  Q_PROPERTY(bool running READ running WRITE setRunning NOTIFY runningChanged)
  Q_PROPERTY(StdioCollector *stdout MEMBER m_stdout)
public:
  explicit Process(QObject *parent = nullptr) : QObject(parent) {
    connect(&m_process, &QProcess::readyReadStandardOutput, this, [this] { m_output += m_process.readAllStandardOutput(); });
    connect(&m_process, &QProcess::finished, this, [this](int code, QProcess::ExitStatus status) { finish(true, code, int(status)); });
    connect(&m_process, &QProcess::errorOccurred, this, [this](QProcess::ProcessError error) {
      if (error == QProcess::FailedToStart) { qWarning() << "CodexBar process:" << m_process.errorString(); finish(); }
    });
    m_timeout.setSingleShot(true);
    connect(&m_timeout, &QTimer::timeout, &m_process, &QProcess::kill);
  }
  ~Process() override {
    m_process.disconnect(this);
    if (m_process.state() != QProcess::NotRunning) { m_process.kill(); m_process.waitForFinished(1000); }
  }
  void classBegin() override { }
  void componentComplete() override { m_complete = true; if (m_running) start(); }
  bool running() const { return m_running; }
  void setRunning(bool value) {
    if (m_running == value) return;
    m_running = value; emit runningChanged();
    if (m_complete && value) start();
    else if (!value && m_process.state() != QProcess::NotRunning) m_process.kill();
  }
signals:
  void runningChanged();
  void exited(int exitCode, int exitStatus);
private:
  void start() {
    m_output.clear();
    if (m_command.isEmpty()) { QTimer::singleShot(0, this, [this] { finish(); }); return; }
    m_process.start(m_command.first(), m_command.mid(1));
    m_timeout.start(120000);
  }
  void finish(bool didExit = false, int code = -1, int status = 0) {
    if (!m_running) return;
    m_timeout.stop(); m_output += m_process.readAllStandardOutput();
    m_running = false;
    if (didExit) emit exited(code, status);
    emit runningChanged();
    if (m_stdout) m_stdout->finish(QString::fromUtf8(m_output));
  }
  QStringList m_command;
  StdioCollector *m_stdout = nullptr;
  QProcess m_process;
  QTimer m_timeout;
  QByteArray m_output;
  bool m_running = false, m_complete = false;
};

class FileView : public QObject, public QQmlParserStatus {
  Q_OBJECT
  Q_INTERFACES(QQmlParserStatus)
  Q_PROPERTY(QString path MEMBER m_path)
  Q_PROPERTY(bool printErrors MEMBER m_printErrors)
public:
  using QObject::QObject;
  void classBegin() override { }
  void componentComplete() override { reload(); }
  Q_INVOKABLE QString text() const { return m_text; }
  Q_INVOKABLE void reload() {
    QUrl url(m_path);
    QFile file(url.isLocalFile() ? url.toLocalFile() : m_path);
    if (!file.open(QIODevice::ReadOnly)) { if (m_printErrors) qWarning() << "CodexBar file:" << file.errorString() << m_path; return; }
    m_text = QString::fromUtf8(file.readAll()); emit loaded();
  }
signals:
  void loaded();
private:
  QString m_path, m_text;
  bool m_printErrors = true;
};

class IoPlugin : public QQmlExtensionPlugin {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
  void registerTypes(const char *uri) override {
    qmlRegisterType<Process>(uri, 1, 0, "Process");
    qmlRegisterType<StdioCollector>(uri, 1, 0, "StdioCollector");
    qmlRegisterType<FileView>(uri, 1, 0, "FileView");
    qmlRegisterSingletonType<Native>(uri, 1, 0, "Native", [](QQmlEngine *, QJSEngine *) -> QObject * { return new Native; });
  }
};
#include "io.moc"
