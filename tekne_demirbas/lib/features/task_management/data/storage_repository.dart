import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepository(ref.watch(firebaseStorageProvider));
});

class StorageRepository {
  StorageRepository(this._storage);

  final FirebaseStorage _storage;

  /// Resim yükleme
  Future<String> uploadImage(File imageFile, String taskId, int imageIndex) async {
    try {
      final fileName = 'tasks/$taskId/images/image_$imageIndex.jpg';
      final ref = _storage.ref().child(fileName);
      
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Resim yüklenirken hata oluştu: $e');
    }
  }

  /// Video yükleme
  Future<String> uploadVideo(File videoFile, String taskId) async {
    try {
      final fileName = 'tasks/$taskId/video/video.mp4';
      final ref = _storage.ref().child(fileName);
      
      await ref.putFile(videoFile);
      final downloadUrl = await ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Video yüklenirken hata oluştu: $e');
    }
  }

  /// Birden fazla resim yükleme
  Future<List<String>> uploadImages(List<File> imageFiles, String taskId) async {
    final List<String> urls = [];
    
    for (int i = 0; i < imageFiles.length; i++) {
      final url = await uploadImage(imageFiles[i], taskId, i);
      urls.add(url);
    }
    
    return urls;
  }

  /// Dosya silme
  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      throw Exception('Dosya silinirken hata oluştu: $e');
    }
  }

  /// Görev klasöründeki tüm dosyaları silme
  Future<void> deleteTaskFiles(String taskId) async {
    try {
      final imagesRef = _storage.ref().child('tasks/$taskId/images');
      final videoRef = _storage.ref().child('tasks/$taskId/video');
      
      // Tüm resimleri sil
      final imagesList = await imagesRef.listAll();
      for (var item in imagesList.items) {
        await item.delete();
      }
      
      // Videoyu sil
      try {
        await videoRef.child('video.mp4').delete();
      } catch (_) {
        // Video yoksa hata verme
      }
    } catch (e) {
      throw Exception('Görev dosyaları silinirken hata oluştu: $e');
    }
  }
}
