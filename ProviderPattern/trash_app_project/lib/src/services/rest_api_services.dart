import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class NaverMapAPI {
  Future<Uint8List> getStaticMapImage(double longitude, double latitude) async {
    http.Response response = await http.get(
      Uri(
          scheme: 'https',
          host: 'naveropenapi.apigw.ntruss.com',
          path: 'map-static/v2/raster',
          queryParameters: {
            'w': '300',
            'h': '300',
            'center': '${longitude},${latitude}',
            'level': '16',
            'scale': '2',
            'markers': 'type:d|size:mid|pos:${longitude} ${latitude}',
            'public_transit': 'true',
          }),
      headers: {
        'Accept': 'application/json',
        'X-NCP-APIGW-API-KEY-ID': Config.config['NAVER_MAP_API']
            ['X-NCP-APIGW-API-KEY-ID'],
        'X-NCP-APIGW-API-KEY': Config.config['NAVER_MAP_API']
            ['X-NCP-APIGW-API-KEY'],
      },
    );

    Uint8List uint8list = response.bodyBytes;

    return uint8list;
  }
}
