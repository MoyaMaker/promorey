import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Image picker removed — Firebase Storage requires paid plan
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:promorey/providers/auth_provider.dart';
import 'package:promorey/providers/promotion_provider.dart';
import 'package:promorey/services/firestore_service.dart';
import 'package:promorey/utils/validators.dart';
import 'package:promorey/widgets/error_text.dart';

class PromotionFormScreen extends StatefulWidget {
  final String? promotionId;
  const PromotionFormScreen({super.key, this.promotionId});

  @override
  State<PromotionFormScreen> createState() => _PromotionFormScreenState();
}

class _PromotionFormScreenState extends State<PromotionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _date = DateTime.now();
  bool _isActive = true;
  bool _isLoading = false;

  bool get isEditing => widget.promotionId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadPromotion();
    }
  }

  Future<void> _loadPromotion() async {
    setState(() => _isLoading = true);
    final firestore = FirestoreService();
    final promotion = await firestore.getPromotionById(widget.promotionId!);
    if (promotion != null && mounted) {
      _titleController.text = promotion.title;
      _descriptionController.text = promotion.description;
      _date = promotion.date;
      _isActive = promotion.isActive;
      // _existingImageUrl removed — Firebase Storage requires paid plan
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<PromotionProvider>();
    final userId = context.read<AuthProvider>().user!.uid;

    bool success;
    if (isEditing) {
      success = await provider.updatePromotion(
        id: widget.promotionId!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        date: _date,
        // imagePath, existingImageUrl, removeImage removed
        isActive: _isActive,
        userId: userId,
      );
    } else {
      success = await provider.createPromotion(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        date: _date,
        // imagePath removed
        isActive: _isActive,
        userId: userId,
      );
    }
    if (success && mounted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEditing ? '¡Promoción actualizada!' : '¡Promoción creada!')),
        );
      }
      context.pop();
    } else if (!success && mounted) {
      if (provider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.error!)),
        );
        provider.clearError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(isEditing ? 'Editar promoción' : 'Nueva promoción')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final provider = context.watch<PromotionProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar promoción' : 'Nueva promoción')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => Validators.required(v, 'El título'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 4,
                validator: (v) => Validators.required(v, 'La descripción'),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Fecha'),
                  child: Text(DateFormat.yMMMd().format(_date)),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Activo'),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
              const SizedBox(height: 16),
              // Image picker & preview removed — Firebase Storage requires paid plan
              ErrorText(error: provider.error),
              const SizedBox(height: 32),
              SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: provider.isLoading ? null : _submit,
                  child: provider.isLoading
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(isEditing ? 'Guardar cambios' : 'Crear promoción'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
