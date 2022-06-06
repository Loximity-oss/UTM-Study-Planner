import 'package:mysql_client/mysql_client.dart';

class Mysql {
  Mysql();

  Future<IResultSet> execQuery(String query) async {
    final conn = await MySQLConnection.createConnection(
        host: "10.0.2.2",
        port: 3306,
        userName: "UTM",
        password: "RPTqW41r8loMOa1a",
        databaseName: 'utm_study_planner',
        secure: false //XAMPP MariaDB version >10. issue in library.
        );

    // try connecting to DB.
    // if true, connection is successful.
    // if false, connection failed and pass to alertDialog.

    try {
      await conn.connect();
      var result = await conn.execute(query);
      conn.close();
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
