import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../model/food_item.dart';

class FoodController with ChangeNotifier {
  final List<FoodItem> _items = [];
  bool _isLoading = false;

  List<FoodItem> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchFoodData() async {
    _isLoading = true;
    notifyListeners();

    //serviceKey	인증키
    // numOfRows	한 페이지 결과 수
    // pageNo	페이지 번호
    // resultType	JSON방식 호출
    const keyId = '8f10b60b60704d02b15a';
    const serviceId = 'COOKRCP01';
    const dataType = 'json';
    const startIdx = '1';
    const endIdx = '100';

    //서비스 URL	http://openapi.foodsafetykorea.go.kr/api/인증키/COOKRCP01/json /1/999
    // The comment indicates a path-based URL, not query parameters.
    final uri = Uri.parse(
        'http://openapi.foodsafetykorea.go.kr/api/$keyId/$serviceId/$dataType/$startIdx/$endIdx');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        //서버에서 받은 바이트 데이터를 UTF-8로 디코딩한 후, JSON 파싱.
        // response.body 대신 bodyBytes를 쓰는 이유: 한글이나 특수문자 인코딩 오류 방지
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        // The service is COOKRCP01, so the root key should be 'COOKRCP01', not 'getFoodKr'.
        final dynamic foodData = decoded['COOKRCP01'];

        // The list of items is under the 'row' key.
        if (foodData is Map<String, dynamic> && foodData['row'] is List) {
          final List<dynamic> itemList = foodData['row'];
          _items.clear();
          _items.addAll(itemList.map((e) => FoodItem.fromJson(e)).toList());
        } else {
          // Check for an error message from the API
          if (foodData is Map<String, dynamic> && foodData['RESULT'] is Map) {
            final result = foodData['RESULT'];
            // API 결과가 성공(INFO-000)이 아닌 경우 에러 메시지 출력
            if (result['CODE'] != 'INFO-000') {
              debugPrint('API Error: ${result['MSG']} (${result['CODE']})');
            } else if (foodData['row'] == null) {
              debugPrint('데이터가 없습니다.');
              _items.clear();
            }
          } else {
            debugPrint('데이터 구조가 예상과 다릅니다: ${jsonEncode(foodData)}');
          }
        }
      } else {
        debugPrint('서버 오류: ${response.statusCode}');
        debugPrint('응답 본문: ${response.body}');
      }
    } catch (e) {
      debugPrint('데이터 로딩 실패: $e');
    }

    _isLoading = false;
    //ChangeNotifier를 통해 UI에 변경을 알림.
    notifyListeners();
  }
}