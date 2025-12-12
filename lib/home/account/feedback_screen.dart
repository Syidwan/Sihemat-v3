import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  
  String _feedbackType = 'Saran';
  int _rating = 0;
  bool _isSubmitting = false;

  final List<String> _feedbackTypes = [
    'Saran',
    'Keluhan',
    'Bug/Error',
    'Fitur Baru',
    'Lainnya',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (!_formKey.currentState!.validate()) return;
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan beri rating terlebih dahulu'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isSubmitting = false);
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 24),
              const Text(
                'Terima Kasih!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Umpan balik Anda sangat berarti bagi kami untuk terus meningkatkan layanan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Kembali', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Umpan Balik'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: const Color(0xFFE53935),
              child: Column(
                children: [
                  const Icon(Icons.feedback_outlined, size: 60, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    'Bagaimana pengalaman Anda?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ceritakan pendapat Anda untuk membantu kami berkembang',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ),

            // Rating
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  const Text('Beri Rating', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => _rating = index + 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            size: 40,
                            color: index < _rating ? Colors.amber : Colors.grey.shade400,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getRatingText(),
                    style: TextStyle(
                      color: _rating > 0 ? Colors.amber.shade700 : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Feedback Form
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Jenis Umpan Balik', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _feedbackTypes.map((type) {
                        final isSelected = _feedbackType == type;
                        return ChoiceChip(
                          label: Text(type),
                          selected: isSelected,
                          selectedColor: const Color(0xFFE53935),
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                          onSelected: (_) => setState(() => _feedbackType = type),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    const Text('Pesan', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _messageController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan Anda di sini...',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Pesan tidak boleh kosong';
                        if (value.length < 10) return 'Pesan minimal 10 karakter';
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                              )
                            : const Text('Kirim Umpan Balik', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Contact info
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.support_agent, color: Colors.blue.shade700, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Butuh bantuan langsung?', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Hubungi: 0800-123-4567', style: TextStyle(color: Colors.blue.shade700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _getRatingText() {
    switch (_rating) {
      case 1: return 'Sangat Buruk 😞';
      case 2: return 'Buruk 😕';
      case 3: return 'Cukup 😐';
      case 4: return 'Bagus 🙂';
      case 5: return 'Sangat Bagus! 😍';
      default: return 'Ketuk bintang untuk memberi rating';
    }
  }
}
