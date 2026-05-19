import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String adminEmail = 'admin@gmail.com';

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool laAdminEmail(String? email) {
    if (email == null) return false;
    return email.trim().toLowerCase() == adminEmail.toLowerCase();
  }

  String chuanHoaSoDienThoaiVN(String input) {
    String value = input.trim();

    value = value.replaceAll(' ', '');
    value = value.replaceAll('-', '');
    value = value.replaceAll('.', '');

    if (value.startsWith('+84')) {
      return value;
    }

    if (value.startsWith('84')) {
      return '+$value';
    }

    if (value.startsWith('0')) {
      return '+84${value.substring(1)}';
    }

    return value;
  }

  bool laSoDienThoaiHopLe(String phone) {
    final normalized = chuanHoaSoDienThoaiVN(phone);
    final regex = RegExp(r'^\+84[0-9]{9}$');
    return regex.hasMatch(normalized);
  }

  String layThongBaoLoiFirebase(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email này đã được đăng ký';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'weak-password':
        return 'Mật khẩu quá yếu, vui lòng nhập ít nhất 6 ký tự';
      case 'user-not-found':
        return 'Tài khoản không tồn tại';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email hoặc mật khẩu không đúng';
      case 'network-request-failed':
        return 'Không có kết nối mạng';
      case 'requires-recent-login':
        return 'Bạn cần đăng nhập lại để thực hiện thao tác này';
      case 'too-many-requests':
        return 'Bạn thao tác quá nhiều lần. Vui lòng thử lại sau';
      default:
        return e.message ?? 'Có lỗi xảy ra';
    }
  }

  Future<UserCredential> dangKy({
    required String email,
    required String matKhau,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: matKhau.trim(),
    );

    await credential.user?.sendEmailVerification();

    return credential;
  }

  Future<UserCredential> dangNhap({
    required String email,
    required String matKhau,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: matKhau.trim(),
    );
  }

  Future<void> dangXuat() async {
    await _auth.signOut();
  }

  Future<void> guiEmailXacMinh() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Không tìm thấy người dùng hiện tại',
      );
    }

    await user.reload();

    final freshUser = _auth.currentUser;

    if (freshUser?.emailVerified == true) {
      return;
    }

    await freshUser?.sendEmailVerification();
  }

  Future<bool> kiemTraEmailDaXacMinh() async {
    final user = _auth.currentUser;

    if (user == null) return false;

    await user.reload();

    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> doiMatKhau({
    required String matKhauHienTai,
    required String matKhauMoi,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Không tìm thấy người dùng hiện tại',
      );
    }

    final email = user.email;

    if (email == null || email.isEmpty) {
      throw FirebaseAuthException(
        code: 'email-not-found',
        message: 'Tài khoản hiện tại không dùng email/password',
      );
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: matKhauHienTai,
    );

    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(matKhauMoi);
  }

  Future<void> luuThongTinKhachHang({
    required String uid,
    required String email,
    required String hoTen,
    required String soDienThoai,
    required String ngaySinh,
    required String quocGia,
    required String tinhThanh,
    required String zipCode,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email.trim(),
      'hoTen': hoTen.trim(),
      'soDienThoai': chuanHoaSoDienThoaiVN(soDienThoai),
      'ngaySinh': ngaySinh.trim(),
      'quocGia': quocGia.trim(),
      'tinhThanh': tinhThanh.trim(),
      'zipCode': zipCode.trim(),
      'vaiTro': 'KHACH_HANG',
      'trangThai': 'ACTIVE',
      'emailVerified': _auth.currentUser?.emailVerified ?? false,
      'phoneVerified': false,
      'profileCompleted': true,
      'ngayTao': FieldValue.serverTimestamp(),
      'ngayCapNhat': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> taoThongTinAdminNeuChuaCo({
    required String uid,
    required String email,
  }) async {
    final docRef = _firestore.collection('users').doc(uid);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.set({
        'email': email.trim(),
        'vaiTro': 'ADMIN',
        'trangThai': 'ACTIVE',
        'emailVerified': _auth.currentUser?.emailVerified ?? false,
        'profileCompleted': true,
        'ngayCapNhat': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }

    await docRef.set({
      'uid': uid,
      'email': email.trim(),
      'hoTen': 'Admin',
      'soDienThoai': '',
      'ngaySinh': '',
      'quocGia': '',
      'tinhThanh': '',
      'zipCode': '',
      'vaiTro': 'ADMIN',
      'trangThai': 'ACTIVE',
      'emailVerified': _auth.currentUser?.emailVerified ?? false,
      'phoneVerified': false,
      'profileCompleted': true,
      'ngayTao': FieldValue.serverTimestamp(),
      'ngayCapNhat': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> layThongTinUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) return null;

    return doc.data();
  }

  Future<void> capNhatThongTinUser({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    final updateData = Map<String, dynamic>.from(data);

    updateData['ngayCapNhat'] = FieldValue.serverTimestamp();

    if (updateData.containsKey('soDienThoai')) {
      updateData['soDienThoai'] = chuanHoaSoDienThoaiVN(
        updateData['soDienThoai'].toString(),
      );
    }

    await _firestore
        .collection('users')
        .doc(uid)
        .set(updateData, SetOptions(merge: true));
  }

  String? get uid => _auth.currentUser!.uid;
}
