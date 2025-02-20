import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/theme_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:provider/provider.dart';

class DesktopLogin extends StatelessWidget {
  const DesktopLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 40, bottom: 40, left: 80, right: 80),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(context.read<ThemeProvider>().isDarkMode
                    ? 'assets/images/banner-dark.png'
                    : 'assets/images/banner.png'),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Gap(MediaQuery.of(context).size.height / 4),
                        TabBar(
                          labelColor: AppUtils.mainBlue(context),
                          unselectedLabelColor: AppUtils.mainBlack(context),
                          indicatorColor: Colors.blue,
                          labelStyle: const TextStyle(fontSize: 18),
                          tabs: const [
                            Tab(text: "Sign in"),
                            Tab(text: "Sign up"),
                          ],
                        ),
                        const Gap(20),
                        Expanded(
                          child: TabBarView(
                            children: [
                              const SignInTab(),
                              const SignUpTab(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                            height: 200,
                            width: 200,
                            fit: BoxFit.contain,
                            image: AssetImage(
                                'assets/images/alib-hd-shaddow.png')),
                        Text(
                          "WELCOME",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "This platform was designed under the visionary leadership of Francis Flynn Chacha",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Powered by Labs"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (context.watch<AuthProvider>().success)
            Positioned(
                top: 20,
                right: 20,
                child: SuccessWidget(
                    message: context.watch<AuthProvider>().message))
          else if (context.watch<AuthProvider>().error)
            Positioned(
              top: 20,
              right: 20,
              child:
                  FailedWidget(message: context.watch<AuthProvider>().message),
            )
        ],
      ),
    );
  }
}

class SignInTab extends StatefulWidget {
  const SignInTab({super.key});

  @override
  State<SignInTab> createState() => _SignInTabState();
}

class _SignInTabState extends State<SignInTab> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? emailError;
  String? passwordError;

  void _clearEmailError() => setState(() => emailError = null);
  void _clearPasswordError() => setState(() => passwordError = null);

  @override
  void initState() {
    super.initState();
    emailController.addListener(_clearEmailError);
    passwordController.addListener(_clearPasswordError);
  }

  void _validateAndSubmit() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      emailError = null;
      passwordError = null;
    });

    var isValid = true;

    if (email.isEmpty) {
      setState(() => emailError = 'Email is required');
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() => emailError = 'Invalid email format');
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() => passwordError = 'Password is required');
      isValid = false;
    }

    if (isValid) {
      context.read<AuthProvider>().login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Use your email and password to sign in"),
        const Gap(10),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            floatingLabelStyle: TextStyle(color: AppUtils.mainBlack(context)),
            prefixIcon: const Icon(FluentIcons.mail_24_regular),
            labelText: 'Email',
            errorText: emailError,
            border: _errorBorder(emailError),
            focusedBorder: _focusedBorder(emailError),
          ),
        ),
        const Gap(20),
        TextField(
          controller: passwordController,
          obscureText: !context.watch<TogglesProvider>().showPassword,
          decoration: InputDecoration(
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
        const Gap(20),
        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return ElevatedButton(
              onPressed: authProvider.isLoading ? null : _validateAndSubmit,
              style: _buttonStyle(authProvider.isLoading),
              child: authProvider.isLoading
                  ? _loadingIndicator()
                  : const Text('Sign In',
                      style: TextStyle(color: Colors.white)),
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

class SignUpTab extends StatefulWidget {
  const SignUpTab({super.key});

  @override
  State<SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<SignUpTab> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController regNoController = TextEditingController();

  String? usernameError;
  String? emailError;
  String? passwordError;
  String? phoneError;
  String? regNoError;
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
    passwordController.addListener(_updatePasswordCriteria);
    _addControllerListeners();
  }

  void _addControllerListeners() {
    usernameController.addListener(() => _clearError('username'));
    emailController.addListener(() => _clearError('email'));
    passwordController.addListener(() => _clearError('password'));
    phoneController.addListener(() => _clearError('phone'));
    regNoController.addListener(() => _clearError('regNo'));
  }

  void _clearError(String field) {
    setState(() {
      switch (field) {
        case 'username':
          usernameError = null;
          break;
        case 'email':
          emailError = null;
          break;
        case 'password':
          passwordError = null;
          break;
        case 'phone':
          phoneError = null;
          break;
        case 'regNo':
          regNoError = null;
          break;
      }
    });
  }

  void _updatePasswordCriteria() {
    final password = passwordController.text;
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
      'username': usernameController.text.trim(),
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'phone': phoneController.text.trim(),
      'regNo': regNoController.text.trim(),
    };

    setState(() {
      usernameError =
          emailError = passwordError = phoneError = regNoError = null;
    });

    var isValid = true;

    if (fields['username']!.isEmpty) {
      setState(() => usernameError = 'Username required');
      isValid = false;
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(fields['username']!)) {
      setState(() => usernameError = 'No special characters allowed');
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

    if (fields['phone']!.isEmpty) {
      setState(() => phoneError = 'Phone required');
      isValid = false;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(fields['phone']!)) {
      setState(() => phoneError = 'Must be numeric');
      isValid = false;
    }

    if (fields['regNo']!.isEmpty) {
      setState(() => regNoError = 'Registration number required');
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
      context.read<AuthProvider>().register(
          fields['username']!,
          fields['email']!,
          fields['password']!,
          fields['phone']!,
          fields['regNo']!,
          'test.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Use your Registration Number to create an account"),
        const Gap(10),
        TextField(
          controller: usernameController,
          decoration: _inputDecoration(
            label: 'Username',
            error: usernameError,
            icon: FluentIcons.person_24_regular,
          ),
        ),
        const Gap(10),
        TextField(
          controller: emailController,
          decoration: _inputDecoration(
            label: 'Email',
            error: emailError,
            icon: FluentIcons.book_24_regular,
          ),
        ),
        const Gap(10),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: _inputDecoration(
            label: 'Phone Number',
            error: phoneError,
            icon: FluentIcons.clipboard_24_regular,
          ),
        ),
        const Gap(20),
        TextField(
          controller: regNoController,
          decoration: _inputDecoration(
            label: 'Registration Number',
            error: regNoError,
            icon: FluentIcons.mail_24_regular,
          ),
        ),
        const Gap(20),
        TextField(
          controller: passwordController,
          obscureText: !context.watch<TogglesProvider>().showPassword,
          decoration: InputDecoration(
            prefixIcon: const Icon(FluentIcons.lock_closed_24_regular),
            floatingLabelStyle: TextStyle(color: AppUtils.mainBlack(context)),
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
        const Gap(10),
        _buildPasswordStrengthIndicator(),
        const Gap(10),
        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return ElevatedButton(
              onPressed: authProvider.isLoading ? null : _validateAndSubmit,
              style: _buttonStyle(authProvider.isLoading),
              child: authProvider.isLoading
                  ? _loadingIndicator()
                  : const Text('Sign Up',
                      style: TextStyle(color: Colors.white)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: _passwordCriteria.entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  entry.value
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: entry.value ? Colors.green : Colors.grey,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 12,
                    color: entry.value ? Colors.green : Colors.grey,
                    decoration: entry.value ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        const Gap(8),
        LinearProgressIndicator(
          value: _passwordStrength,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            _passwordStrength >= 0.8
                ? Colors.green
                : _passwordStrength >= 0.5
                    ? Colors.orange
                    : Colors.red,
          ),
        ),
        const Gap(4),
        Text(
          'Password Strength: ${(_passwordStrength * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: _passwordStrength >= 0.8
                ? Colors.green
                : _passwordStrength >= 0.5
                    ? Colors.orange
                    : Colors.red,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String? error,
    required IconData icon,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      labelText: label,
      errorText: error,
      border: _errorBorder(error),
      floatingLabelStyle: TextStyle(color: AppUtils.mainBlack(context)),
      focusedBorder: _focusedBorder(error),
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
