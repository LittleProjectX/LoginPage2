import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:whatsapp/models/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  String? token = '';
  String? userId = '';

  updateData(String getToken, String uId) {
    token = getToken;
    userId = uId;
    notifyListeners();
  }

  List<Product> _allData = [];
  List<Product> get allData => _allData;

  get jmlhData => _allData.length;
  Uri mainUrl =
      Uri.parse('https://whatsapp-47f11-default-rtdb.firebaseio.com/');

  Future<void> addProduct(String nama, String gaji) async {
    Uri url = Uri.parse('$mainUrl/Product.json?auth=$token');
    DateTime dateNow = DateTime.now();

    try {
      var hasilResp = await http.post(url,
          body: json.encode({
            'nama': nama,
            'gaji': gaji,
            'createdAt': dateNow.toString(),
            'updateAt': dateNow.toString(),
            'userId': userId
          }));
      if (hasilResp.statusCode >= 200 && hasilResp.statusCode < 300) {
        _allData.add(Product(
            id: json.decode(hasilResp.body)['name'],
            nama: nama,
            gaji: gaji,
            createdAt: dateNow,
            updateAt: dateNow));
        notifyListeners();
        print('Berhasil Menambahkan');
      } else {
        print(hasilResp.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  initstate() {
    _allData = [];
    Uri url = Uri.parse(
        '$mainUrl/Product.json?auth=$token&orderBy="userId"&equalTo="$userId"');

    try {
      http.get(url).then((response) {
        if (response.statusCode == 200) {
          var hasilRes = json.decode(response.body);
          if (hasilRes != null && hasilRes is Map<String, dynamic>) {
            hasilRes.forEach((key, value) {
              String createString = value['createdAt'];
              String updateString = value['updateAt'];

              _allData.add(Product(
                id: key,
                nama: value['nama'],
                gaji: value['gaji'],
                createdAt: DateTime.parse(createString),
                updateAt: DateTime.parse(updateString),
              ));
            });
            print('Berhasil ditambahkan');
          } else {
            print('Tidak ada data');
          }
        } else {
          print('Gagal mengambil data: ${response.reasonPhrase}');
        }
        notifyListeners();
      }).catchError((error) {
        print('Terjadi kesalahan: $error');
      });
    } catch (e) {
      print('Terjadi kesalahan: $e');
      rethrow;
    }
  }

  Future<void> deleteprod(String id) {
    Uri url = Uri.parse('$mainUrl/Product/$id.json?auth=$token');

    return http.delete(url).then((respon) {
      _allData.removeWhere((element) => element.id == id);
      notifyListeners();
    });
  }

  Product selectById(String id) =>
      _allData.firstWhere((element) => element.id == id);

  Future<void> editProduct(String id, nama, gaji) async {
    Uri url = Uri.parse('$mainUrl/Product/$id.json?auth=$token');
    DateTime DateNow = DateTime.now();

    try {
      var hasilRes = await http.patch(url,
          body: json.encode(
              {'nama': nama, 'gaji': gaji, 'updateAt': DateNow.toString()}));
      if (hasilRes.statusCode >= 200 && hasilRes.statusCode < 300) {
        Product edit = _allData.firstWhere((element) => element.id == id);
        edit.nama = nama;
        edit.gaji = gaji;
        edit.updateAt = DateNow;
        notifyListeners();
      } else {
        throw (hasilRes.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
