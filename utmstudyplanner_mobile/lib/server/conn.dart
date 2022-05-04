import 'package:mysql1/mysql1.dart';

class Mysql {
  Mysql();
  Future<MySqlConnection> getConnection() async {

    //  HOST: localhost OR if you are using a physical device,
    //  check your IPv4 address via ipconfig
    //  then change host to your IPV4 address.

    try{
      var settings = ConnectionSettings(
          host: '192.168.145.78',
          port: 3306,
          user: 'root',
          password: '',
          db: 'utmstudyplanner'
      );
      return await MySqlConnection.connect(settings);
    } catch (e) {
      //TODO error throw
      rethrow;
    }


  }
}