import 'package:flutter/material.dart';
import 'package:extended_keyboard/extended_keyboard.dart';
import '../widgets/custom_number_keyboard.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const LoginPage({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _isAgreed = false;
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _codeFocusNode = FocusNode();
  bool _isPhoneInput = true;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(_onFocusChange);
    _codeFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _phoneFocusNode.removeListener(_onFocusChange);
    _codeFocusNode.removeListener(_onFocusChange);
    _phoneFocusNode.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isKeyboardVisible = _phoneFocusNode.hasFocus || _codeFocusNode.hasFocus;
      _isPhoneInput = _phoneFocusNode.hasFocus;
    });
  }

  void _onKeyPressed(String key) {
    if (_isPhoneInput) {
      _phoneController.text += key;
    } else {
      _codeController.text += key;
    }
  }

  void _onBackspace() {
    if (_isPhoneInput) {
      if (_phoneController.text.isNotEmpty) {
        _phoneController.text = _phoneController.text.substring(
          0,
          _phoneController.text.length - 1,
        );
      }
    } else {
      if (_codeController.text.isNotEmpty) {
        _codeController.text = _codeController.text.substring(
          0,
          _codeController.text.length - 1,
        );
      }
    }
  }

  void _login() {
    if (_phoneController.text.isEmpty || _codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入手机号和验证码')),
      );
      return;
    }

    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请阅读并同意服务协议和隐私政策')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          onThemeToggle: widget.onThemeToggle,
          isDarkMode: widget.isDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo和标题
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '天时子平',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '天时\n子平',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              // 手机号输入框
              TextField(
                controller: _phoneController,
                focusNode: _phoneFocusNode,
                readOnly: true,
                showCursor: true,
                decoration: const InputDecoration(
                  hintText: '输入手机号码',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 验证码输入框
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _codeController,
                      focusNode: _codeFocusNode,
                      readOnly: true,
                      showCursor: true,
                      decoration: const InputDecoration(
                        hintText: '验证码',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      // 获取验证码逻辑
                    },
                    child: Text(
                      '获取验证码',
                      style: TextStyle(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 协议选项
              Row(
                children: [
                  Checkbox(
                    value: _isAgreed,
                    onChanged: (value) {
                      setState(() {
                        _isAgreed = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: '我已阅读并同意天时子平/八字',
                        children: [
                          TextSpan(
                            text: '服务协议',
                            style: TextStyle(
                              color: theme.primaryColor,
                            ),
                          ),
                          const TextSpan(text: ' 和 '),
                          TextSpan(
                            text: '隐私政策',
                            style: TextStyle(
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // 自定义数字键盘
              CustomNumberKeyboard(
                isVisible: _isKeyboardVisible,
                onKeyPressed: _onKeyPressed,
                onBackspace: _onBackspace,
                onConfirm: _login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
