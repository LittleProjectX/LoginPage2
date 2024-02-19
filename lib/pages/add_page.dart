import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/providers/products.dart';
import 'package:whatsapp/widgets/tf_field.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});
  static const nameRoute = '/addpage';

  @override
  Widget build(BuildContext context) {
    final provItem = Provider.of<Products>(context, listen: false);
    TextEditingController namaController = TextEditingController();
    TextEditingController gajiController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Data'),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              TfField(
                title: 'Nama Pegawai',
                itemController: namaController,
              ),
              const SizedBox(
                height: 10,
              ),
              TfField(
                title: 'Gaji',
                itemController: gajiController,
              ),
              const Spacer(),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      provItem
                          .addProduct(namaController.text, gajiController.text)
                          .then((value) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Berhasil Menambahkan'),
                          duration: Duration(milliseconds: 500),
                        ));
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('TAMBAH')),
              )
            ],
          ),
        ));
  }
}
