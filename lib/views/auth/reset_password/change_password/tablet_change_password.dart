import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/theme_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:provider/provider.dart';

class TabletChangePassword extends StatefulWidget {
  const TabletChangePassword({super.key});

  @override
  State<TabletChangePassword> createState() => _TabletChangePasswordState();
}

class _TabletChangePasswordState extends State<TabletChangePassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? otpError;
  bool isRequestOTPSuccessful = false;

  void _handleOTPSuccess() {
    setState(() {
      isRequestOTPSuccessful = true;
    });
  }

  void _handleChangePasswordSuccess() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(context.read<ThemeProvider>().isDarkMode
                ? 'assets/images/banner-dark.png'
                : 'assets/images/banner.png'),
          ),
        ),
        child: Center(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.65,
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 80, right: 80),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppUtils.mainBlack(context).withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(10, 5),
                  )
                ],
                color: AppUtils.mainWhite(context),
                borderRadius: BorderRadius.circular(5),
              ),
              child: isRequestOTPSuccessful
                  ? ChangePasswordWidget(
                      onChangeSuccess: _handleChangePasswordSuccess,
                    )
                  : RequestOTPWidget(onOTPSuccess: _handleOTPSuccess)),
        ),
      ),
      if (context.watch<AuthProvider>().success)
        Positioned(
            top: 20,
            right: 20,
            child:
                SuccessWidget(message: context.watch<AuthProvider>().message))
      else if (context.watch<AuthProvider>().error)
        Positioned(
          top: 20,
          right: 20,
          child: FailedWidget(message: context.watch<AuthProvider>().message),
        )
    ]));
  }
}

class ChangePasswordWidget extends StatefulWidget {
  final VoidCallback onChangeSuccess;

  const ChangePasswordWidget({super.key, required this.onChangeSuccess});

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? otpError;

  double _passwordStrength = 0.0;

  final Map<String, bool> _passwordCriteria = {
    '8+ Characters': false,
    'Uppercase Letter': false,
    'Lowercase Letter': false,
    'Number': false,
    'Special Character': false,
  };

  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(_updatePasswordCriteria);
    _addControllerListeners();
  }

  void _addControllerListeners() {
    otpController.addListener(() => _clearError('otp'));
    emailController.addListener(() => _clearError('email'));
    newPasswordController.addListener(() => _clearError('password'));
  }

  void _clearError(String field) {
    setState(() {
      switch (field) {
        case 'otp':
          otpError = null;
          break;
        case 'email':
          emailError = null;
          break;
        case 'password':
          passwordError = null;
          break;
      }
    });
  }

  void _updatePasswordCriteria() {
    final password = newPasswordController.text;
    setState(() {
      _passwordStrength = _calculateStrength(password);
      _passwordCriteria['8+ Characters'] = password.length >= 8;
      _passwordCriteria['Uppercase Letter'] =
          password.contains(RegExp(r'[A-Z]'));
      _passwordCriteria['Lowercase Letter'] =
          password.contains(RegExp(r'[a-z]'));
      _passwordCriteria['Number'] = password.contains(RegExp(r'[0-9]'));
      _passwordCriteria['Special Character'] =
          password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  double _calculateStrength(String password) {
    int met = 0;
    if (password.length >= 8) met++;
    if (password.contains(RegExp(r'[A-Z]'))) met++;
    if (password.contains(RegExp(r'[a-z]'))) met++;
    if (password.contains(RegExp(r'[0-9]'))) met++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) met++;
    return met / 5;
  }

  void _validateAndSubmit() {
    final fields = {
      'otp': otpController.text.trim(),
      'email': emailController.text.trim(),
      'password': newPasswordController.text.trim(),
    };

    setState(() {
      otpError = emailError = passwordError = null;
    });

    var isValid = true;

    if (fields['otp']!.isEmpty) {
      setState(() => otpError = 'OTP is required');
      isValid = false;
    } else if (fields['otp']!.length < 6 || fields['otp']!.length > 6) {
      setState(() => otpError = 'OTP must be 6 digits');
      isValid = false;
    }

    if (fields['email']!.isEmpty) {
      setState(() => emailError = 'Email required');
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(fields['email']!)) {
      setState(() => emailError = 'Invalid email format');
      isValid = false;
    }

    if (fields['password']!.isEmpty) {
      setState(() => passwordError = 'Password required');
      isValid = false;
    } else if (_passwordStrength < 0.6) {
      setState(() => passwordError = 'Password too weak');
      isValid = false;
    }

    if (isValid) {
      context
          .read<AuthProvider>()
          .resetPassword(fields['email']!, fields['otp']!, fields['password']!);
      Future.delayed(const Duration(seconds: 3), () {
        widget.onChangeSuccess();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 40,
          child: Image(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/alib-hd-shaddow.png')),
        ),
        Text("Change your Password",
            style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: AppUtils.mainBlue(context),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppUtils.mainBlue(context))),
        Text(
            "Use the OTP sent to your registered email address to change your password.",
            style: TextStyle(fontSize: 14, color: AppUtils.mainBlack(context))),
        TextField(
          controller: emailController,
          cursorColor: AppUtils.mainBlue(context),
          decoration: InputDecoration(
            floatingLabelStyle: TextStyle(color: AppUtils.mainBlack(context)),
            prefixIcon: const Icon(FluentIcons.mail_24_regular),
            labelText: 'Email',
            errorText: emailError,
            border: _errorBorder(emailError),
            focusedBorder: _focusedBorder(emailError),
          ),
        ),
        TextField(
          controller: otpController,
          cursorColor: AppUtils.mainBlue(context),
          decoration: InputDecoration(
            floatingLabelStyle: TextStyle(color: AppUtils.mainBlack(context)),
            prefixIcon: const Icon(FluentIcons.mail_24_regular),
            border: _errorBorder(otpError),
            focusedBorder: _focusedBorder(otpError),
            labelText: 'One Time Pin(OTP)',
          ),
        ),
        TextField(
          controller: newPasswordController,
          obscureText: !context.watch<TogglesProvider>().showPassword,
          decoration: InputDecoration(
            floatingLabelStyle: TextStyle(color: AppUtils.mainBlack(context)),
            prefixIcon: const Icon(FluentIcons.lock_closed_24_regular),
            suffixIcon: GestureDetector(
              onTap: () => context.read<TogglesProvider>().togglePassword(),
              child: Icon(context.watch<TogglesProvider>().showPassword
                  ? FluentIcons.eye_24_regular
                  : FluentIcons.eye_off_24_regular),
            ),
            labelText: 'Password',
            errorText: passwordError,
            border: _errorBorder(passwordError),
            focusedBorder: _focusedBorder(passwordError),
          ),
        ),
        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authProvider.isLoading ? null : _validateAndSubmit,
                style: _buttonStyle(authProvider.isLoading),
                child: authProvider.isLoading
                    ? _loadingIndicator()
                    : const Text('Change Password',
                        style: TextStyle(color: Colors.white)),
              ),
            );
          },
        ),
      ],
    );
  }

  OutlineInputBorder _errorBorder(String? error) => OutlineInputBorder(
        borderSide: BorderSide(
          color: error != null ? Colors.red : const Color(0xFFD4D4D4),
        ),
      );

  OutlineInputBorder _focusedBorder(String? error) => OutlineInputBorder(
        borderSide: BorderSide(
          color: error != null ? Colors.red : AppUtils.mainBlue(context),
        ),
      );

  ButtonStyle _buttonStyle(bool isLoading) => ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
            isLoading ? Colors.grey : AppUtils.mainBlue(context)),
        padding:
            const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
      );

  Widget _loadingIndicator() => const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
      );
}

class RequestOTPWidget extends StatefulWidget {
  final VoidCallback onOTPSuccess;

  const RequestOTPWidget({super.key, required this.onOTPSuccess});

  @override
  State<RequestOTPWidget> createState() => _RequestOTPWidgetState();
}

class _RequestOTPWidgetState extends State<RequestOTPWidget> {
  TextEditingController emailController = TextEditingController();

  String? emailError;

  bool isRequestOTPSuccessful = false;

  void _clearEmailError() => setState(() => emailError = null);
  @override
  void initState() {
    super.initState();
    emailController.addListener(_clearEmailError);
  }

  void _validateAndSubmit() {
    final email = emailController.text.trim();

    setState(() {
      emailError = null;
    });

    var isValid = true;

    if (email.isEmpty) {
      setState(() => emailError = 'Email is required');
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() => emailError = 'Invalid email format');
      isValid = false;
    }

    if (isValid) {
      context.read<AuthProvider>().requestResetPasswordOTP(email);
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          widget.onOTPSuccess();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 40,
          child: Image(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/alib-hd-shaddow.png')),
        ),
        Text("Request OTP",
            style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: AppUtils.mainBlue(context),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppUtils.mainBlue(context))),
        Text("Enter the email your account is registered with below.",
            style: TextStyle(fontSize: 14, color: AppUtils.mainBlack(context))),
        TextField(
          controller: emailController,
          cursorColor: AppUtils.mainBlue(context),
          decoration: InputDecoration(
            floatingLabelStyle: TextStyle(color: AppUtils.mainBlack(context)),
            prefixIcon: const Icon(FluentIcons.mail_24_regular),
            labelText: 'Email',
            errorText: emailError,
            border: _errorBorder(emailError),
            focusedBorder: _focusedBorder(emailError),
          ),
        ),
        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authProvider.isLoading ? null : _validateAndSubmit,
                style: _buttonStyle(authProvider.isLoading),
                child: authProvider.isLoading
                    ? _loadingIndicator()
                    : const Text('Request OTP',
                        style: TextStyle(color: Colors.white)),
              ),
            );
          },
        ),
      ],
    );
  }

  OutlineInputBorder _errorBorder(String? error) => OutlineInputBorder(
        borderSide: BorderSide(
          color: error != null ? Colors.red : const Color(0xFFD4D4D4),
        ),
      );

  OutlineInputBorder _focusedBorder(String? error) => OutlineInputBorder(
        borderSide: BorderSide(
          color: error != null ? Colors.red : AppUtils.mainBlue(context),
        ),
      );

  ButtonStyle _buttonStyle(bool isLoading) => ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
            isLoading ? Colors.grey : AppUtils.mainBlue(context)),
        padding:
            const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
      );

  Widget _loadingIndicator() => const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
      );
}
