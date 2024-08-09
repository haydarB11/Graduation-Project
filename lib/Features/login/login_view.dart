import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:shamseenfactory/Features/home/presentaion/view/home_view.dart';
import 'package:shamseenfactory/Features/login/anmi.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/app_router.dart';
import 'package:http/http.dart' as http;
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/cache/cache_helper.dart';

class LoginHomePage extends StatefulWidget {
  @override
  _LoginHomePageState createState() => _LoginHomePageState();
}

class _LoginHomePageState extends State<LoginHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage; // Add this line
  String? _emailError;
  String? _passwordError;
  bool _isPasswordVisible = false;
  String _managerName = '';
  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final success = await _performLogin();

      if (success) {
        print("tm");
        print(_managerName);
        GoRouter.of(context).pushReplacement(AppRouter.kHomeView);
      } else {
        // Handle login failure (show error message)
      }
    }
  }

 
  Future<bool> _performLogin() async {
    final url = Uri.parse('$baseUrl/managers/login');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = '''{
    "user": "${_emailController.text}",
    "password": "${_passwordController.text}"
  }''';

    final response = await http.post(url, headers: headers, body: body);
    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      print("kkkkkkk");
      final token = parseTokenFromResponse(response.body);
      final parsedJson = json.decode(response.body);
      final managerData = parsedJson['data']['data'];
      setState(() {
        _managerName = managerData['name_en'];
      });
      await CasheHelper.setData(key: Constants.ktoken, value: token);
      await CasheHelper.setData(
          key: Constants.kManagerName, value: _managerName);
      await CasheHelper.setData(
          key: Constants.kManagerID, value: managerData['id']);

      return true;
    } else {
      final messageApi = jsonDecode(response.body);
      setState(() {
        // _errorMessage = 'Invalid email or password';// Set error message

        if (messageApi['data'] == "User Not Found") {
          _errorMessage = "User Not Found";
        } else {
          _errorMessage = "Invalid password";
        }
      });
      print('Request failed with status: ${response.statusCode}');
      print('Error message: ${response.reasonPhrase}');
      return false;
    }
  }

  // Future<void> _storeToken(String token) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString('auth_token', token);
  // }

  String parseTokenFromResponse(String responseBody) {
    // Parse the JSON response and extract the token
    final parsedJson = json.decode(responseBody);
    final token = parsedJson['data']['token'];
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: hBackgroundColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInDown(
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  SizedBox(height: 10),
                  FadeInDown(
                    child: Text(
                      "Welcome Back",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildTextField(
                              "Email", false, _emailController, _emailError),
                          SizedBox(height: 20),
                          _buildPasswordField(
                              _passwordController, _passwordError),
                          SizedBox(height: 20),
                          _buildLoginButton(context),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, bool isPassword,
      TextEditingController controller, String? errorText) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          errorText: errorText,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a valid $hintText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller, String? errorText) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          errorText: errorText,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            child: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a valid password';
          } else if (value.length < 1) {
            return 'password too short ';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: SpinKitSpinningLines(
          size: 35,
          color: hBackgroundColor,
        ),
      ); // Show loading indicator
    } else {
      return FadeInDown(
        child: Column(
          children: [
            if (_errorMessage != null) // Display error message if available
              Text(
                _errorMessage!,
                style: Styles.textStyle18
                    .copyWith(color: Colors.red.withOpacity(0.5)),
              ),
            const SizedBox(
              height: deafultpadding * 2,
            ),
            GestureDetector(
              onTap: _login,
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: kBlueLightColor,
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
