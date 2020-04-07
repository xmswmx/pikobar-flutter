import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/collections.dart';

class ProfileRepository {
  String status, verificationid;

  Future<void> sendCodeToPhoneNumber(
      String id,
      phoneNumber,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed,
      PhoneCodeSent codeSent) async {
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {};

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: Dictionary.inaCode + phoneNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<void> linkCredential(
      String id, phoneNumber, AuthCredential credential) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    List<UserInfo> providerList = user.providerData;
    if (providerList.length > 2) {
      await user.unlinkFromProvider(credential.providerId);
    }
    await user.linkWithCredential(credential);
    await saveToCollection(id, phoneNumber);
  }

  Future<void> saveToCollection(String id, phoneNumber) async {
    Firestore.instance
        .collection(Collections.users)
        .document(id)
        .updateData({'phone_number': Dictionary.inaCode + phoneNumber});
  }

  Future<void> signInWithPhoneNumber(
      String smsCode, verificationID, id, phoneNumber) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationID,
      smsCode: smsCode,
    );
    await linkCredential(id, phoneNumber, credential);
  }
}