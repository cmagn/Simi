import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import '../models/user.dart';

class UserFormView extends StatefulWidget {
  final User? user;

  const UserFormView({Key? key, this.user}) : super(key: key);

  @override
  State createState() => _UserFormViewState();
}

class _UserFormViewState extends State {
  final _formKey = GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.user != null) {
      _emailController.text = widget.user!.email;
      _passwordController.text = widget.user!.password;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future _saveUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = User(
        id: widget.user?.id,
        email: _emailController.text.trim(),
        roles: 'USER',
        password: _passwordController.text.trim(),
      );

      final controller = Provider.of(context, listen: false);
      
      final bool success;
      if (widget.user == null) {
        success = await controller.addUser(user);
      } else {
        success = await controller.updateUser(user);
      }

      setState(() => _isSaving = false);

      if (success) {
        _showSuccessMessage();
        Navigator.pop(context);
      } else {
        _showErrorMessage(controller.error);
      }
    } catch (e) {
      setState(() => _isSaving = false);
      _showErrorMessage('Erreur inattendue: $e');
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.user == null 
            ? 'User ajouté avec succès ✓'
            : 'User modifié avec succès ✓',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showErrorMessage(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur: $error'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Fermer',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user == null ? 'Nouveau User' : 'Modifier User',
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormHeader(),
              const SizedBox(height: 24),
              _buildEmailField(),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 20),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          widget.user == null ? Icons.person_add : Icons.edit,
          size: 48,
          color: Colors.blue.shade700,
        ),
        const SizedBox(height: 12),
        Text(
          widget.user == null 
            ? 'Ajouter un nouveau user'
            : 'Modifier les informations du user',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Veuillez remplir tous les champs obligatoires',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'E-mail *',
        hintText: 'Ex: google@gmail.com',
        prefixIcon: const Icon(Icons.person, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Le prénom est requis';
        }
        if (value.trim().length < 2) {
          return 'Le prénom doit contenir au moins 2 caractères';
        }
        return null;
      },
      onChanged: (_) {
        if (_formKey.currentState?.validate() ?? false) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        prefixIcon: const Icon(Icons.family_restroom, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Le nom de famille est requis';
        }
        if (value.trim().length < 2) {
          return 'Le nom doit contenir au moins 2 caractères';
        }
        return null;
      },
      onChanged: (_) {
        if (_formKey.currentState?.validate() ?? false) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildActionButtons() {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    return Column(
      children: [
        ElevatedButton(
          onPressed: (_isSaving || !isValid) ? null : _saveUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            minimumSize: const Size(double.infinity, 52),
          ),
          child: _isSaving
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.user == null 
                        ? Icons.person_add_alt_1 
                        : Icons.save,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.user == null 
                        ? 'Ajouter le user'
                        : 'Enregistrer les modifications',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade400),
            foregroundColor: Colors.grey.shade700,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(double.infinity, 52),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back, size: 20),
              SizedBox(width: 12),
              Text(
                'Annuler',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}