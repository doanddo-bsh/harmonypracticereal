// ignore_for_file: file_names

import 'package:async_preferences/async_preferences.dart';
import 'initialization_helper.dart';
import 'package:flutter/material.dart';


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
