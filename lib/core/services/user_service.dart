import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../views/home/models/user_model.dart';

class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get currentUserId {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    return user.uid;
  }

  CollectionReference get usersCollection =>
      firestore.collection('users').doc(currentUserId).collection('people');

  DocumentSnapshot? _lastDocument;
  String? _paginationUserId;

  void resetPagination() {
    _lastDocument = null;
    _paginationUserId = null;
  }

  Future<List<UserModel>> getUsers({int page = 0, int pageSize = 20}) async {
    final userId = currentUserId;
    if (page == 0 || _paginationUserId != userId) {
      resetPagination();
      _paginationUserId = userId;
    }

    Query query = usersCollection
        .orderBy('createdAt', descending: true)
        .limit(pageSize);

    if (page > 0) {
      if (_lastDocument == null) {
        return [];
      }
      query = query.startAfterDocument(_lastDocument!);
    }

    final QuerySnapshot querySnapshot = await query.get();
    final docs = querySnapshot.docs;

    if (docs.isEmpty) {
      return [];
    }

    _lastDocument = docs.last;

    return docs.map((doc) {
      return UserModel.fromJson({
        ...doc.data() as Map<String, dynamic>,
        'id': doc.id,
      });
    }).toList();
  }

  Future<UserModel?> getUserById(String id) async {
    final DocumentSnapshot doc = await usersCollection.doc(id).get();

    if (!doc.exists) {
      return null;
    }

    return UserModel.fromJson({
      ...doc.data() as Map<String, dynamic>,
      'id': doc.id,
    });
  }

  Future<UserModel> addUser(UserModel user) async {
    final data = user.toJson()..remove('imageUrl');
    final DocumentReference docRef = await usersCollection.add(data);

    return UserModel(
      id: docRef.id,
      name: user.name,
      phone: user.phone,
      age: user.age,
      imageUrl: user.imageUrl,
      createdAt: user.createdAt,
    );
  }

  Future<UserModel> updateUser(UserModel user) async {
    final data = user.toJson()..remove('imageUrl');
    await usersCollection.doc(user.id).update(data);

    return user;
  }

  Future<void> deleteUser(String id) async {
    await usersCollection.doc(id).delete();
  }

  Stream<List<UserModel>> watchUsers() {
    return usersCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            return UserModel.fromJson({
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            });
          }).toList(),
        );
  }

  Future<int> getUserCount() async {
    final AggregateQuerySnapshot snapshot = await usersCollection.count().get();

    return snapshot.count ?? 0;
  }
}
