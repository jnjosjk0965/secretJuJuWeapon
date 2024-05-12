import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  //final TextEditingController _certificationCodeController = TextEditingController();

  //bool _isValidDomain = false;
  //final bool _certificationCodeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
      ),
      body: Column(
        children: [
          EmailInput(
            emailController: _emailController,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                // 이메일 체크
                if (_emailController.text.endsWith("@m365.dongyang.ac.kr")) {
                  setState(() {
                    //_isValidDomain = true;
                  });

                  // 이메일 전송
                }
              },
              child: const Text('인증')),
          const CertificationNumberInput(),
          const RegisterButton(),
        ],
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  final TextEditingController emailController;
  const EmailInput({
    super.key,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextField(
        controller: emailController,
        onChanged: (email) {},
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          label: Text("이메일"),
          helperText: '',
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

class PasswordConfirmInput extends StatelessWidget {
  const PasswordConfirmInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextField(
        onChanged: (password) {},
        obscureText: true,
        decoration: const InputDecoration(
          label: Text("비밀번호 확인"),
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
      height: MediaQuery.of(context).size.width * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
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
