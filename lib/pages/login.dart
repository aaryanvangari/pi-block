import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/components/pi_validators.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/provider/auth_provider.dart';
import 'package:pi_block/widgets/logo.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordController = TextEditingController();
  final _serverUrlController = TextEditingController();
  bool loading = false;
  bool passwordVisible = false;
  PiValidators piValidators = PiValidators();

  void doLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      Uri url = Uri.parse(_serverUrlController.text);
      setState(() {
        loading = true;
      });
      await auth.login(url, _passwordController.text);
      setState(() {
        loading = false;
      });
      if (!mounted) return;
      context.go("/home");
    } catch (e) {
      if (!mounted) return;
      PiUtils.handleGeneralException(context, e);
    }
  }

  void clearPassword() {
    _passwordController.clear();
  }

  void clearServerUrl() {
    _serverUrlController.clear();
  }

  void clearInputs() {
    clearPassword();
    clearServerUrl();
  }

  @override
  void initState() {
    // clearInputs();
    super.initState();
    passwordVisible = true;
  }

  // cleanup
  @override
  void dispose() {
    _passwordController.dispose();
    _serverUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/");
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LogoWidget(type: "login"),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Login to Pi-Hole instance",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    child: Builder(
                      builder: (context) {
                        return Column(
                          children: [
                            Tooltip(
                              message:
                                  "Pi-Hole server url. \nExamples \nhttps://pihole.example.com \nhttp://pihole.local \nhttp://192.168.1.2:8053",
                              padding: EdgeInsets.all(10.0),
                              margin: EdgeInsets.all(20),
                              verticalOffset: 10,
                              preferBelow: false,
                              child: TextFormField(
                                controller: _serverUrlController,
                                validator: (value) => piValidators.serverUrlValidator(value),
                                onChanged: (value) {
                                  Form.of(context).validate();
                                },
                                decoration: InputDecoration(
                                  labelText: "Pi-Hole Server Url",
                                  border: KInputStyle.inputBorder,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: clearServerUrl,
                                    icon: Icon(Icons.clear),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Tooltip(
                              message:
                                  "API Token which is used for FTLCONF_webserver_api_password in environment file",
                              padding: EdgeInsets.all(10.0),
                              margin: EdgeInsets.all(20),
                              verticalOffset: 10,
                              preferBelow: false,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: passwordVisible,
                                enableSuggestions: false,
                                autocorrect: false,
                                validator: (value) => piValidators.apiTokenValidator(value),
                                onChanged: (value) {
                                  Form.of(context).validate();
                                },
                                decoration: InputDecoration(
                                  labelText: "API Token",
                                  border: KInputStyle.inputBorder,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                            SizedBox(height: 20),
                            FilledButton(
                              onPressed: () {
                                if (Form.of(context).validate()) {
                                  doLogin();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Login"),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
