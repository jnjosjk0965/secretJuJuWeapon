import 'package:yangdonge_client/model/response/response_dto.dart';

class SignInResponse extends ResponseDto {
  final String? accessToken;

  SignInResponse.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        super.fromJson(json);
}
