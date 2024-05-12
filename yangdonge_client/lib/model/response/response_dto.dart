class ResponseDto {
  final String code, message;

  ResponseDto.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        message = json['message'];
}
