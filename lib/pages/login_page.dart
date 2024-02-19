import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/providers/authn.dart';

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data, BuildContext context) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        await Provider.of<Authn>(context, listen: false)
            .signInUser(data.name.toString(), data.password.toString());
        print('Berhasil SignUp');
      } catch (e) {
        return e.toString();
      }

      return null;
    });
  }

  Future<String?> _signupUser(SignupData data, BuildContext context) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        await Provider.of<Authn>(context, listen: false)
            .signUpUser(data.name.toString(), data.password.toString());
      } catch (e) {
        return e.toString();
      }
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentContex = context;
    return FlutterLogin(
      title: 'ECORP',
      // logo: const AssetImage('assets/logo.png'),
      onLogin: (data) => _authUser(data, currentContex),
      onSignup: (data) => _signupUser(data, currentContex),
      onSubmitAnimationCompleted: () {
        Provider.of<Authn>(context, listen: false).tempData();
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (context) => const HomePage(),
        // ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
