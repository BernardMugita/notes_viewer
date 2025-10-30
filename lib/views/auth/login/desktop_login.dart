import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // New import for FilteringTextInputFormatter
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/theme_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    // color: Colors.red, // Remove this after testing
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      // Added Center widget
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min, // Added this
                          children: [
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
                            SizedBox(
                              // Changed from Expanded to SizedBox with fixed height
                              height: MediaQuery.of(context).size.height /
                                  2.5, // Adjust this height as needed
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
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min, // Added this
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
                          "Arifu Library, a plattform built by students for students.",
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
        const Gap(20),
        TextField(
          controller: passwordController,
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
        const Gap(20),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Divider(
              color: AppUtils.mainBlue(context),
            ),
            Positioned(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppUtils.mainBlue(context)),
                child: Text(
                  "Or",
                  style: TextStyle(color: AppUtils.mainWhite(context)),
                ),
              ),
            )
          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Forgot your Password?"),
            TextButton(
              onPressed: () {
                if (context.mounted) {
                  context.go('/reset_password');
                }
              },
              child: Text(
                "Reset Password",
                style: TextStyle(
                    color: AppUtils.mainBlue(context),
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        )
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
  final TextEditingController regYearController = TextEditingController();
  final TextEditingController yearController = TextEditingController(); // New
  final TextEditingController semesterController =
      TextEditingController(); // New

  String? usernameError;
  String? emailError;
  String? passwordError;
  String? phoneError;
  String? regNoError;
  String? regYearError;
  String? yearError; // New
  String? semesterError; // New
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
    regYearController.addListener(() => _clearError('regYear'));
    yearController.addListener(() => _clearError('year')); // New
    semesterController.addListener(() => _clearError('semester')); // New
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
        case 'regYear':
          regYearError = null;
          break;
        case 'year': // New
          yearError = null;
          break;
        case 'semester': // New
          semesterError = null;
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
      'regYear': regYearController.text.trim(),
      'year': yearController.text.trim(), // New
      'semester': semesterController.text.trim(), // New
    };

    setState(() {
      usernameError = emailError = passwordError = phoneError = regNoError =
          regYearError = yearError = semesterError = null; // Updated
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
    } else {
      // Validate registration number format: CODE/Student_number/reg_year
      List<String> regNoParts = fields['regNo']!.split('/');

      if (regNoParts.length != 3) {
        setState(() =>
            regNoError = 'Invalid format. Expected: H31/Student_number/year');
        isValid = false;
      } else {
        String code = regNoParts[0];
        String studentNumber = regNoParts[1];
        String regYearFromRegNo = regNoParts[2];

        // Validate code is H31
        if (code != 'H31') {
          setState(
              () => regNoError = 'Registration number must start with H31');
          isValid = false;
        }
        // Validate student number is not empty and is numeric
        else if (studentNumber.isEmpty || int.tryParse(studentNumber) == null) {
          setState(() => regNoError = 'Invalid student number');
          isValid = false;
        }
        // Validate year is either 2024 or 2025
        else if (regYearFromRegNo != '2024' && regYearFromRegNo != '2025') {
          setState(() =>
              regNoError = 'Registration year must be either 2024 or 2025');
          isValid = false;
        }
        // Check if reg_year matches the year in reg_no
        else if (fields['regYear']!.isNotEmpty &&
            fields['regYear'] != regYearFromRegNo) {
          setState(() => regNoError =
              'Registration year does not match the year in registration number');
          isValid = false;
        }
      }
    }

    if (fields['regYear']!.isEmpty) {
      setState(() => regYearError = 'Registration year required');
      isValid = false;
    } else if (fields['regYear'] != '2024' && fields['regYear'] != '2025') {
      setState(
          () => regYearError = 'Registration year must be either 2024 or 2025');
      isValid = false;
    } else {
      if (fields['regNo']!.isNotEmpty) {
        List<String> regNoParts = fields['regNo']!.split('/');

        if (regNoParts.length == 3) {
          String regYearFromRegNo = regNoParts[2];

          if (fields['regYear'] != regYearFromRegNo) {
            setState(() => regYearError =
                'Registration year does not match the year in registration number');
            isValid = false;
          }
        }
      }
    }

    // New validation for year
    if (fields['year']!.isEmpty) {
      setState(() => yearError = 'Year required');
      isValid = false;
    } else {
      final year = int.tryParse(fields['year']!);
      if (year == null || year < 1 || year > 5) {
        setState(() => yearError = 'Year must be between 1 and 5');
        isValid = false;
      }
    }

    // New validation for semester
    if (fields['semester']!.isEmpty) {
      setState(() => semesterError = 'Semester required');
      isValid = false;
    } else {
      final semester = int.tryParse(fields['semester']!);
      if (semester == null || (semester != 1 && semester != 2)) {
        setState(() => semesterError = 'Semester must be 1 or 2');
        isValid = false;
      }
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
            fields['regYear']!,
            'test.jpg',
            int.parse(fields['year']!),
            // New
            int.parse(fields['semester']!), // New
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Use your Registration Number to create an account"),
          const Gap(10),
          Wrap(
            spacing: 10, // Horizontal space between items
            runSpacing: 10, // Vertical space between rows
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: TextField(
                  cursorColor: AppUtils.mainBlue(context),
                  controller: usernameController,
                  decoration: _inputDecoration(
                    label: 'Username',
                    error: usernameError,
                    icon: FluentIcons.person_24_regular,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: TextField(
                  cursorColor: AppUtils.mainBlue(context),
                  controller: emailController,
                  decoration: _inputDecoration(
                    label: 'Email',
                    error: emailError,
                    icon: FluentIcons.book_24_regular,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: TextField(
                  cursorColor: AppUtils.mainBlue(context),
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration(
                    label: 'Phone Number',
                    error: phoneError,
                    icon: FluentIcons.clipboard_24_regular,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: TextField(
                  cursorColor: AppUtils.mainBlue(context),
                  controller: regNoController,
                  decoration: _inputDecoration(
                    label: 'Registration Number',
                    error: regNoError,
                    icon: FluentIcons.mail_24_regular,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: TextField(
                  cursorColor: AppUtils.mainBlue(context),
                  controller: regYearController,
                  decoration: _inputDecoration(
                    label: 'Registration Year',
                    error: regYearError,
                    icon: FluentIcons.mail_24_regular,
                  ),
                ),
              ),
              // New Year field
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: TextField(
                  cursorColor: AppUtils.mainBlue(context),
                  controller: yearController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDecoration(
                    label: 'Year (1-5)',
                    error: yearError,
                    icon: FluentIcons.calendar_ltr_24_regular,
                  ),
                ),
              ),
              // New Semester field
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: TextField(
                  cursorColor: AppUtils.mainBlue(context),
                  controller: semesterController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDecoration(
                    label: 'Semester (1 or 2)',
                    error: semesterError,
                    icon: FluentIcons.calendar_day_24_regular,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: TextField(
                  cursorColor: AppUtils.mainBlue(context),
                  controller: passwordController,
                  obscureText: !context.watch<TogglesProvider>().showPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(FluentIcons.lock_closed_24_regular),
                    floatingLabelStyle:
                        TextStyle(color: AppUtils.mainBlack(context)),
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          context.read<TogglesProvider>().togglePassword(),
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
              ),
            ],
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
      ),
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
