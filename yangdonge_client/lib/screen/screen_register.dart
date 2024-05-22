import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _certiCodeController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _certiCodeFocusNode = FocusNode();

  bool _showCertiCodeInput = false;
  bool _isValidDomain = false;
  final bool _certiCodeSent = false;
  final bool _isAllFilled = false;

  @override
  void dispose() {
    _emailController.dispose();
    _certiCodeController.dispose();
    _emailFocusNode.dispose();
    _certiCodeFocusNode.dispose();
    super.dispose();
  }

  void _showCertiCodeInputField() {
    setState(() {
      _showCertiCodeInput = true;
    });
    _certiCodeFocusNode.requestFocus();
  }

  void _verifyCode() {
    //  send request email and certiCode
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // email input field
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextField(
                      controller: _emailController,
                      onChanged: (email) {},
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        label: const Text("이메일"),
                        helperText: '',
                        suffixIcon: _showCertiCodeInput
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: _showCertiCodeInputField,
                              ),
                      ),
                      onEditingComplete: _showCertiCodeInputField,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.18,
                  height: MediaQuery.of(context).size.width * 0.08,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () async {
                        // 이메일 체크
                        if (_emailController.text
                            .endsWith("@m365.dongyang.ac.kr")) {
                          setState(() {
                            _isValidDomain = true;
                          });

                          // 이메일 전송
                          // 만약 _isValidDomain이 false이면 유효한 이메일을 입력하세요
                          // true라면 이메일 전송
                        }
                      },
                      child: const Text('인증')),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_showCertiCodeInput) const CertificationNumberInput(),
            const RegisterButton(),
          ],
        ),
      ),
    );
  }
}

class CertificationNumberInput extends StatelessWidget {
  const CertificationNumberInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextField(
        onChanged: (certificationNumber) {},
        obscureText: true,
        decoration: const InputDecoration(
          label: Text("인증번호"),
          helperText: '',
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.width * 0.08,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('회원가입이 완료되었습니다.')));
          Navigator.pop(context);
        },
        child: const Text("회원가입"),
      ),
    );
  }
}
