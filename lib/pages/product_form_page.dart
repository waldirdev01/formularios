import 'package:flutter/material.dart';
import 'package:formularios/models/product.dart';
import 'package:formularios/models/product_list.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descritionFocus = FocusNode();
  final _urlFocus = FocusNode();
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _urlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final argument = ModalRoute.of(context)?.settings.arguments;
      if (argument != null) {
        final product = argument as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _urlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descritionFocus.dispose();
    _urlFocus.removeListener(updateImage);
    _urlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  Future<void> _submitForm() async {
    final _isValid = _formKey.currentState?.validate() ?? false;
    if (!_isValid) {
      return;
    }
    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ProductList>(context, listen: false)
          .saveProduct(_formData);
      Navigator.of(context).pop();
    } catch (erro) {
      await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Erro inexperado! Tente mais tarde.'),
                content: Text(erro.toString()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Sair'))
                ],
              ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpeg') ||
        url.toLowerCase().endsWith('.jpg');
    return isValidUrl && endsWithFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Formulário de produto'),
          actions: [IconButton(onPressed: _submitForm, icon: Icon(Icons.save))],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _formData['name']?.toString(),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocus);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (_name) {
                          final name = _name ?? '';
                          if (name.trim().isEmpty) {
                            return 'Nome é obrigatório';
                          }
                          if (name.trim().length < 3) {
                            return 'O nome precisa ter no mínimo 3 letras.';
                          }
                          return null;
                        },
                        onSaved: (name) => _formData['name'] = name ?? '',
                      ),
                      TextFormField(
                        initialValue: _formData['price']?.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Preço',
                        ),
                        focusNode: _priceFocus,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (_price) {
                          final stringPrice = _price ?? '';
                          final price = double.tryParse(stringPrice) ?? -1;
                          if (price <= 0) {
                            return 'Informe um preço válido';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descritionFocus);
                        },
                        onSaved: (price) =>
                            _formData['price'] = double.parse(price ?? '0'),
                      ),
                      TextFormField(
                        initialValue: _formData['description']?.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                        ),
                        focusNode: _descritionFocus,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        validator: (_description) {
                          final description = _description ?? '';
                          if (description.trim().isEmpty) {
                            return 'A descrição é obrigatória';
                          }
                          if (description.trim().length < 5) {
                            return 'A descrição precisa ter no mínimo 5 letras.';
                          }
                          return null;
                        },
                        onSaved: (description) => _formData['description'] =
                            description ?? 'não passou a descrição',
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _urlController,
                              decoration: const InputDecoration(
                                labelText: 'Url da imagem',
                              ),
                              focusNode: _urlFocus,
                              keyboardType: TextInputType.url,
                              onFieldSubmitted: (_) => _submitForm(),
                              validator: (_urlImage) {
                                final urlImage = _urlImage ?? '';
                                if (!isValidImageUrl(urlImage)) {
                                  return 'Informe uma url válida';
                                }
                                return null;
                              },
                              onSaved: (urlImage) => _formData['urlImage'] =
                                  urlImage ?? 'não passou a url',
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10, left: 10),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                            ),
                            child: _urlController.text.isEmpty
                                ? Text('Informe a url')
                                : Image.network(
                                    _urlController.text,
                                    fit: BoxFit.cover,
                                  ),
                          )
                        ],
                      ),
                    ],
                  ),
                )));
  }
}
