class Routes {
  static const String _baseUrl = 'https://onsaemiro.site/api';

  /// 로그인 api (POST)
  /// => 사용자 로그인 코드
  /// <= 사용자 id, 중증도, Access&Refresh 토큰
  static const String login = '$_baseUrl/member/auth/login/user';

  /// 토큰 리프레시 api (POST)
  /// => 사용자 리프레시 토큰
  /// <= 새로운 Access & Refresh 토큰
  static const String refresh = '$_baseUrl/member/auth/newtoken';

  /// 카테고리 조회 api (GET)
  /// =>
  /// <= 개수(count), 카테고리 정보(data)
  static const String getCategory = '$_baseUrl/survey/category/get';
  /// 카테고리&중증도 질문 조회 api (GET)
  /// => /{카테고리 id}/level/{중증도} (url에 덧붙이는 방식)
  /// <= 개수와 질문 정보
  static const String getsurvey = '$_baseUrl/survey/get/category';

  /// 설문 답변 저장 api (POST)
  /// => 설문 id(surveyId), 카테고리 id(categoryId), 답변 id(answerId), 사용자 id(userId)
  /// <= 성공여부
  static const String sendAnswer = '$_baseUrl/survey/answer/add';

  /// 요구사항 저장 api (POST - multipart/form-data)
  /// => 요구사항(description), 사용자 id(userId), 이미지(images)
  /// <= 성공여부
  static const String sendRequest = '$_baseUrl/request/add';

}