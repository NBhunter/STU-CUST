import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> verifyPhoneNumber(String phoneNumber) async {
  await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      // Auto-retrieve the SMS code on Android
      // (not necessary on iOS as auto-retrieval is handled by the OS)
      await _auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      // Handle verification failure
    },
    codeSent: (String verificationId, int? resendToken) {
      // Save the verification ID somewhere
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Handle timeout
    },
  );
}

void signInWithPhoneNumber(String verificationId, String smsCode) async {
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
    verificationId: verificationId,
    smsCode: smsCode,
  );
  await _auth.signInWithCredential(credential);
}
