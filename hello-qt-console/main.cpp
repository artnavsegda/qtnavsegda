//#include <QCoreApplication>
#include <QTextStream>
#include <QString>

int main(int argc, char *argv[])
{
//    QCoreApplication a(argc, argv);

    QString str = "Hello world\n";

    QTextStream(stdout) << str;

//    return a.exec();
    return 0;
}
