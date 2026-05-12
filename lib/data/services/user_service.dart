import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference get usersCollection => firestore.collection('users');

  Future<List<UserModel>> getUsers({int page = 0, int pageSize = 20}) async {
    final QuerySnapshot querySnapshot = await usersCollection
        .orderBy('createdAt', descending: true)
        .limit(pageSize)
        .get();

    final List<QueryDocumentSnapshot> docs = querySnapshot.docs;
    final startIndex = page * pageSize;
    if (startIndex >= docs.length) return [];

    final endIndex = (startIndex + pageSize > docs.length) ? docs.length : startIndex + pageSize;
    final pageDocs = docs.sublist(startIndex, endIndex);

    return pageDocs
        .map((doc) => UserModel.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .toList();
  }

  Future<UserModel?> getUserById(String id) async {
    final DocumentSnapshot doc = await usersCollection.doc(id).get();
    if (!doc.exists) return null;
    return UserModel.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
  }

  Future<UserModel> addUser(UserModel user) async {
    final DocumentReference docRef = await usersCollection.add(user.toJson());
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
    await usersCollection.doc(user.id).update(user.toJson());
    return user;
  }

  Future<void> deleteUser(String id) async {
    await usersCollection.doc(id).delete();
  }

  Stream<List<UserModel>> watchUsers() {
    return usersCollection.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
              .toList(),
        );
  }

  Future<int> getUserCount() async {
    final AggregateQuerySnapshot snapshot = await usersCollection.count().get();
    return snapshot.count ?? 0;
  }
}