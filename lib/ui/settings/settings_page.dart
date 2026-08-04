
import 'package:async_preferences/async_preferences.dart';
import 'package:harmonypracticereal/core/consent/consent_service.dart';
import 'package:harmonypracticereal/core/theme/theme_mode_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _initializationHelper = InitializationHelper();
  late final Future<bool> _future ;

  @override
  void initState(){
    super.initState();

    _future = _isUnderGdpr();
  }

  Future<bool> _isUnderGdpr() async {
    final preferences = AsyncPreferences();
    return await preferences.getInt('IABTCF_gdprApplies') == 1;
  }

  /// 테마 선택 섹션.
  ///
  /// 헤더 모양('Privacy' 와 같은 padding·primaryColor·bold)과 ListTile 계열
  /// 항목이라는 점을 아래 기존 섹션과 맞췄다. 페이지의 나머지는 건드리지 않았다.
  ///
  /// [Consumer] 를 쓰는 이유: 선택이 바뀌면 이 섹션만 다시 그리면 되고,
  /// 실제 테마 적용은 `app.dart` 의 MaterialApp 이 맡는다.
  Widget _themeSection(BuildContext context) {
    return Consumer<ThemeModeController>(
      builder: (context, themeModeController, _) => Column(
        mainAxisSize: MainAxisSize.min,
        // ListView 의 다른 항목처럼 가로를 꽉 채워야 헤더가 왼쪽에 붙는다.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 12.0,
              right: 16.0,
              bottom: 12.0,
            ),
            child: Text(
              '화면 테마',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 선택 상태와 콜백은 RadioGroup 이 쥔다. RadioListTile 자체의
          // groupValue/onChanged 는 Flutter 3.32 에서 deprecated 되었고
          // analysis_options 가 deprecated_member_use 를 warning 으로
          // 올려 두었으므로 쓰지 않는다.
          RadioGroup<ThemeMode>(
            groupValue: themeModeController.themeMode,
            onChanged: (mode) {
              if (mode != null) {
                themeModeController.setThemeMode(mode);
              }
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  title: Text('라이트 모드'),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  title: Text('다크 모드'),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  title: Text('시스템 설정 따름'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('설정'),
        ),
        body: FutureBuilder<bool>(
            future: _future,
            builder: (context, snapshot) {
              return ListView(
                children: [
                  _themeSection(context),
                  const Divider(
                    indent: 12.0,
                    endIndent: 12.0,
                  ),
                  //   Container(
                  //   padding: const EdgeInsets.only(
                  //     left: 16.0,
                  //     top:12.0,
                  //     right:16.0,
                  //     bottom: 12.0,
                  //   ),
                  //   child: Text(
                  //     '프리미엄',
                  //     style: TextStyle(
                  //       color: Theme.of(context).primaryColor,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  //   ListTile(
                  //     title: const Text('광고 제거'),
                  //     leading: const Icon(Icons.attach_money_rounded),
                  //     visualDensity: VisualDensity.compact,
                  //     onTap: (){
                  //
                  //     },
                  //   ),
                  //   ListTile(
                  //     title: const Text('구매 내역 복원'),
                  //     leading: const Icon(Icons.restart_alt_rounded),
                  //     visualDensity: VisualDensity.compact,
                  //     onTap: (){
                  //
                  //     },
                  //   ),
                  //   // if (snapshot.hasData && snapshot.data == true)
                  //   const Divider(
                  //     indent: 12.0,
                  //     endIndent: 12.0,
                  //   ),
                  // 이하는 유럽 정책 대응을 위한 부분으로 영어로 작성함
                  Container(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      top: 12.0,
                      right: 16.0,
                      bottom: 12.0,
                    ),
                    child: Text(
                      'Privacy',
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // ListTile(
                  //   title: const Text('Privacy Policy'),
                  //   leading: const Icon(Icons.privacy_tip_rounded),
                  //   visualDensity: VisualDensity.compact,
                  //   onTap: (){
                  //
                  //   },
                  // ),
                  if (snapshot.hasData && snapshot.data == true)
                    const Divider(
                      indent: 12.0,
                      endIndent: 12.0,
                    ),
                  if (snapshot.hasData && snapshot.data == true)
                    ListTile(
                      title: const Text('Change privacy preferences'),
                      leading: const Icon(Icons.privacy_tip_rounded),
                      onTap: () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);

                        final didChangePreferences =
                        await _initializationHelper.changePrivacyPreference();

                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              didChangePreferences ?
                              'Your privacy choices have been updated'
                                  : 'An error occurred while trying to change your '
                                  'privacy preferences',

                            ),
                          ),
                        );
                      },
                    )

                ],
              );
            }
        )
    );
  }
}
