import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/views/widgets/app_drawer.dart';
import 'package:shop/models/providers/product.dart';
import 'package:shop/models/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const String routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceNode = FocusNode();
  final _titleNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageNode = FocusNode();
  final _imageController = TextEditingController();
  var _runOneTime = true;
  String? productId;
  var _isLoading = false;

  // ignore: prefer_final_fields
  var _existingProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initialValues = {
    'title': '',
    'descripion': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_runOneTime) {
      try {
        var _args = ModalRoute.of(context)!.settings.arguments;
        if (_args != null) {
          productId = _args as String;
        }

        _existingProduct = Provider.of<Products>(context, listen: false)
            .findProductById(productId!);
        _initialValues = {
          'title': _existingProduct.title,
          'descripion': _existingProduct.description,
          'price': _existingProduct.price.toString(),
          'imageUrl': '',
        };
        _imageController.text = _existingProduct.imageUrl;
      } finally {
        // I Think It Can Be Romoved
        super.didChangeDependencies();
        _runOneTime = false;
        // ignore: control_flow_in_finally
        return;
      }
    }
    super.didChangeDependencies();
    _runOneTime = false;
  }

  @override
  void dispose() {
    _imageNode.removeListener(_updateImageUrl);
    _priceNode.dispose();
    _titleNode.dispose();
    _descriptionNode.dispose();
    _imageController.dispose();
    _imageNode.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (productId != null) {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(productId, _existingProduct);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('${_existingProduct.title} Editted in DataBase Sucessfully'),
        ));
      } else {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_existingProduct);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('${_existingProduct.title} added To DataBase Sucessfully'),
        ));
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Product Not Added to DataBase'),
            actions: [
              TextButton(
                  child: const Text('Okey'),
                  onPressed: () {
                    setState(() {
                      Navigator.of(ctx).pop();
                    });
                  }),
            ]),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product '),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveForm,
            ),
          ],
        ),
        drawer: const MyAppDrawer(),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(_existingProduct.id),
                      TextFormField(
                        initialValue: _initialValues['title'],
                        decoration:
                            const InputDecoration(labelText: 'Enter Title'),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        focusNode: _titleNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceNode);
                        },
                        onSaved: (value) {
                          _existingProduct = Product(
                            id: _existingProduct.id,
                            title: value!,
                            description: _existingProduct.description,
                            price: _existingProduct.price,
                            imageUrl: _existingProduct.imageUrl,
                            favourite: _existingProduct.favourite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Entre Title First';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initialValues['price'],
                        decoration:
                            const InputDecoration(labelText: 'Enter Price'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _priceNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descriptionNode);
                        },
                        onSaved: (value) {
                          _existingProduct = Product(
                            id: _existingProduct.id,
                            title: _existingProduct.title,
                            description: _existingProduct.description,
                            price: double.parse(value!),
                            imageUrl: _existingProduct.imageUrl,
                            favourite: _existingProduct.favourite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Price Can`t be Empty';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Enter Valied ammount';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Amount Can`t be Less than or 0';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initialValues['descripion'],

                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        // keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.newline,
                        focusNode: _descriptionNode,
                        onSaved: (value) {
                          _existingProduct = Product(
                            id: _existingProduct.id,
                            title: _existingProduct.title,
                            description: value!,
                            price: _existingProduct.price,
                            imageUrl: _existingProduct.imageUrl,
                            favourite: _existingProduct.favourite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter description';
                          }
                          return null;
                        },
                        maxLines: 3,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: FittedBox(
                              child: _imageController.text.isEmpty
                                  ? const Text(
                                      'Enter Url !',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : Image.network(
                                      _imageController.text,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Colors.black54,
                                  style: BorderStyle.solid),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              // initialValue: _initialValues['imageUrl'],
                              decoration:
                                  const InputDecoration(labelText: 'Image Url'),
                              textInputAction: TextInputAction.done,
                              controller: _imageController,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              focusNode: _imageNode,
                              onSaved: (value) {
                                _existingProduct = Product(
                                  id: _existingProduct.id,
                                  title: _existingProduct.title,
                                  description: _existingProduct.description,
                                  price: _existingProduct.price,
                                  imageUrl: value!,
                                  favourite: _existingProduct.favourite,
                                );
                              },
                              keyboardType: TextInputType.url,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Image Url First';
                                }
                                if (!value.startsWith('http:') &&
                                    !value.startsWith('https:')) {
                                  return 'Enter Valid URL';
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ));
  }
}
