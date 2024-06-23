import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

class InitializationHelper {

  // https://davidserrano.io/admob-ump-sdk-in-flutter-implement-your-gdpr-dialog

  // In this method, we request the consent status, and if a form is available we will proceed to display it.
  // The isConsentFormAvailable() method will only return true in cases where there is a form to display,
  // if the user is outside of the countries subject to the GDPR this method will return false,
  // although this behavior may vary depending on how you have configured the message.

  // void initialize() {
  //   final params = ConsentRequestParameters();
  //   ConsentInformation.instance.requestConsentInfoUpdate(params, () async {
  //     if (await ConsentInformation.instance.isConsentFormAvailable()) {
  //       // Here we'll load the consent form
  //     }
  //   }, (error) {
  //     // Manage error
  //   });
  // }

  // We are now going to also use a Completer in the initialize() method, and also manage the initialization of the components:

  Future<FormError?> initialize() async {
    final completer = Completer<FormError?>();

    // ################################################################
    // for real
    // final params = ConsentRequestParameters();
    // ################################################################
    // for debug
    // reset
    ConsentInformation.instance.reset();

    // debug setting
    ConsentDebugSettings debugSettings = ConsentDebugSettings(
    // pretend to eea nations to see consent
    debugGeography: DebugGeography.debugGeographyEea,
    // pretend to not eea nations to hide consent
    // debugGeography: DebugGeography.debugGeographyNotEea,
    testIdentifiers: ['411F25A5-7B0C-44D1-9994-FFF224BCF57B'],
    );

    // use debug setting set params
    ConsentRequestParameters params = ConsentRequestParameters(
        consentDebugSettings: debugSettings);
    // debug end
    // ################################################################

    ConsentInformation.instance.requestConsentInfoUpdate(params, () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        await _loadConsentForm();
      } else {
        // There is no message to display,
        // so initialize the components here.
        await _initialize();
      }

      completer.complete();
    }, (error) {
      completer.complete(error);
    });

    return completer.future;
  }

  Future<bool> changePrivacyPreference() async {
    final completer = Completer<bool>();

    ConsentInformation.instance
        .requestConsentInfoUpdate(ConsentRequestParameters(), () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()){
        ConsentForm.loadConsentForm((consentForm) {
          consentForm.show((formError) async {
            await _initialize();
            completer.complete(true);
          });
        }, (formError) {
          completer.complete(false);
        });
      } else {
        completer.complete(false);
      }
    }, (error) {
      completer.complete(false);
    });

    return completer.future;
  }


  // Now we will create a private method that loads and displays the message:
  // old version

  // void _loadConsentForm() {
  //   ConsentForm.loadConsentForm((consentForm) async {
  //     final status = await ConsentInformation.instance.getConsentStatus();
  //     if (status == ConsentStatus.required) {
  //       consentForm.show((formError) {
  //         // Call this method again, if the user has already selected an
  //         // option the message will not be displayed again.
  //         _loadConsentForm();
  //       });
  //     }
  //   }, (FormError? error) {
  //     // Handle error
  //   });
  // }

  // If you've noticed, this library doesn't use Futures to do asynchronous work
  // but instead uses callbacks. This is not a very "Flutter" way of doing things,
  // so we're going to "Flutterize" it using a Completer. In addition,
  // we are going to add another method that will be in charge of
  // initializing the consent-dependent components:

  // final version
  Future<FormError?> _loadConsentForm() async {
    final completer = Completer<FormError?>();

    ConsentForm.loadConsentForm((ConsentForm consentForm) async {
      final status = await ConsentInformation.instance.getConsentStatus();
      if (status == ConsentStatus.required) {
        consentForm.show((formError) {
          completer.complete(_loadConsentForm());
        });
      } else {
        // The user has chosen an option,
        // it's time to initialize the ads component.
        await _initialize();
        completer.complete();
      }
    }, (FormError? error) {
      completer.complete(error);
    });

    return completer.future;
  }

  Future<void> _initialize() async {
    await MobileAds.instance.initialize();

    /**
     * Here you can place any other initialization of any
     * other component that depends on consent management,
     * for example the initialization of Google Analytics
     * or Google Crashlytics would go here.
     */
  }


}