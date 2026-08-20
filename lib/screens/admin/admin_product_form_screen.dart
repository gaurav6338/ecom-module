import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/app_colors.dart';

class AdminProductFormScreen extends StatefulWidget {
  final Product? existingProduct;

  const AdminProductFormScreen({super.key, this.existingProduct});

  @override
  State<AdminProductFormScreen> createState() => _AdminProductFormScreenState();
}

class _AdminProductFormScreenState extends State<AdminProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _discountCtrl;
  late TextEditingController _stockCtrl;
  late TextEditingController _imageCtrl;
  String _category = 'Electronics';
  bool _isFeatured = false;
  bool _isTrending = false;
  bool _isBestSeller = false;
  bool _isSaving = false;

  final List<String> _categories = [
    'Electronics',
    'Fashion',
    'Footwear',
    'Audio',
    'Watches',
    'Home & Kitchen',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.existingProduct;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _priceCtrl = TextEditingController(text: p != null ? '${p.price}' : '');
    _discountCtrl = TextEditingController(text: p != null ? '${p.discountPercentage}' : '10');
    _stockCtrl = TextEditingController(text: p != null ? '${p.stock}' : '25');
    _imageCtrl = TextEditingController(
      text: p?.imageUrl ?? 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop&q=80',
    );
    if (p != null) {
      _category = p.category;
      _isFeatured = p.isFeatured;
      _isTrending = p.isTrending;
      _isBestSeller = p.isBestSeller;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _discountCtrl.dispose();
    _stockCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    final price = double.tryParse(_priceCtrl.text) ?? 0.0;
    final discount = double.tryParse(_discountCtrl.text) ?? 0.0;
    final originalPrice = discount > 0 ? price / (1 - (discount / 100)) : price;

    final newProduct = Product(
      id: widget.existingProduct?.id ?? 'p_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: price,
      originalPrice: originalPrice,
      discountPercentage: discount,
      rating: widget.existingProduct?.rating ?? 4.8,
      reviewCount: widget.existingProduct?.reviewCount ?? 15,
      stock: int.tryParse(_stockCtrl.text) ?? 10,
      category: _category,
      imageUrl: _imageCtrl.text.trim(),
      images: widget.existingProduct?.images.isNotEmpty == true
          ? widget.existingProduct!.images
          : [_imageCtrl.text.trim()],
      sizes: widget.existingProduct?.sizes ?? ['S', 'M', 'L'],
      colors: widget.existingProduct?.colors ?? ['Black', 'Silver'],
      isFeatured: _isFeatured,
      isTrending: _isTrending,
      isBestSeller: _isBestSeller,
    );

    if (widget.existingProduct == null) {
      await productProvider.addProduct(newProduct);
    } else {
      await productProvider.updateProduct(newProduct);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.existingProduct == null ? 'Product added successfully!' : 'Product updated successfully!',
        ),
        backgroundColor: AppColors.secondary,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingProduct != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Product' : 'Add New Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              CustomTextField(
                label: 'Product Name',
                hint: 'e.g. Pro Headphones X1',
                controller: _nameCtrl,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Description',
                hint: 'Enter detailed product specifications...',
                controller: _descCtrl,
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Price (₹)',
                      hint: '14999',
                      controller: _priceCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'Discount (%)',
                      hint: '20',
                      controller: _discountCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'Stock Quantity',
                      hint: '50',
                      controller: _stockCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Product Image URL',
                controller: _imageCtrl,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Image Preview Box
              if (_imageCtrl.text.isNotEmpty)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _imageCtrl.text,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Flags Switch List
              SwitchListTile(
                title: const Text('Mark as Featured Product'),
                value: _isFeatured,
                activeColor: AppColors.primary,
                onChanged: (val) => setState(() => _isFeatured = val),
              ),
              SwitchListTile(
                title: const Text('Mark as Trending Deal'),
                value: _isTrending,
                activeColor: AppColors.primary,
                onChanged: (val) => setState(() => _isTrending = val),
              ),
              SwitchListTile(
                title: const Text('Mark as Best Seller'),
                value: _isBestSeller,
                activeColor: AppColors.primary,
                onChanged: (val) => setState(() => _isBestSeller = val),
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: isEdit ? 'Update Product' : 'Save New Product',
                isLoading: _isSaving,
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
