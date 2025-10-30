import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // MediaType을 위해 추가

class SignupController extends ChangeNotifier {
  // 입력 필드 컨트롤러
  final TextEditingController idController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  bool isPasswordMatch = true; // 패스워드 일치 여부

  final String serverIp = "http://10.100.201.87:8080"; // 서버 주소 변경 필요
  // final String serverIp = "http://192.168.219.103:8080"; // 서버 주소 변경 필요

  // 패스워드 일치 여부 검사
  void validatePassword() {
    isPasswordMatch = passwordController.text == passwordConfirmController.text;
    notifyListeners();
  }

  // 다이얼로그 표시
  void showDialogMessage(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  // 토스트 메시지 표시
  void showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // 아이디 중복 체크 기능
  Future<void> checkDuplicateId(BuildContext context) async {
    String inputId = idController.text.trim();
    if (inputId.isEmpty) {
      showDialogMessage(context, "오류", "아이디를 입력하세요.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("$serverIp/member/check-mid?mid=$inputId"),
      );

      if (response.statusCode == 200) {
        showDialogMessage(context, "사용 가능", "이 아이디는 사용할 수 있습니다.");
      } else if (response.statusCode == 409) {
        showDialogMessage(context, "중복된 아이디", "이미 사용 중인 아이디입니다.");
      } else {
        showDialogMessage(context, "오류", "서버 응답 오류: ${response.statusCode}");
      }
    } catch (e) {
      showDialogMessage(context, "오류", "네트워크 오류 발생: $e");
    }
  }

  // 회원 가입 요청
  Future<void> signup(BuildContext context) async {
    if (!isPasswordMatch) {
      showDialogMessage(context, "오류", "패스워드가 일치해야 합니다.");
      return;
    }

    String inputId = idController.text.trim();
    String inputPw = passwordController.text.trim();

    if (inputId.isEmpty || inputPw.isEmpty) {
      showToast(context, "아이디와 비밀번호를 입력하세요.");
      return;
    }

    Map<String, String> userData = {"mid": inputId, "mpw": inputPw};

    // ----- 여기부터 수정됨 -----
    try {
      // 1. Multipart 요청 객체 생성
      var uri = Uri.parse("$serverIp/member/register");
      var request = http.MultipartRequest("POST", uri);

      // 2. JSON 데이터를 'user' 파트로 추가
      // Spring의 @RequestPart("user")와 이름이 일치해야 합니다.
      request.files.add(
        http.MultipartFile.fromString(
          'user', // 서버에서 받는 @RequestPart의 이름
          jsonEncode(userData),
          contentType: MediaType('application', 'json'), // 이 파트의 MIME 타입
        ),
      );

      // 3. (선택) 이미지 파일 파트
      // 이 함수에서는 이미지를 보내지 않으므로 추가하지 않습니다.
      // 서버에서 required=false이므로 문제 없습니다.

      // 4. 요청 전송 및 응답 수신
      var streamedResponse = await request.send();

      // 5. StreamedResponse를 http.Response로 변환
      final response = await http.Response.fromStream(streamedResponse);

      // ----- 여기부터 기존 코드와 동일 -----
      if (response.statusCode == 200) {
        showToast(context, "회원 가입 성공!");
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, "/main");
        });
      } else {
        // UTF-8 디코딩을 추가하여 한글 깨짐 방지
        final responseBody = utf8.decode(response.bodyBytes);
        showToast(context, "회원 가입 실패: $responseBody");
      }
    } catch (e) {
      showToast(context, "오류 발생: $e");
    }
  }
}