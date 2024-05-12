import 'package:yangdonge_client/model/response/response_dto.dart';

class UserCheckResponse extends ResponseDto {
  final String isJoin;

  UserCheckResponse.fromJson(Map<String, dynamic> json)
      : isJoin = json['isJoin'],
        super.fromJson(json);
}
