import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../data/bible_books.dart';
import '../services/reading_service.dart';

Future<bool?> showReadingRecordDialog(
  BuildContext context, {
  String? recordId,
  Map<String, dynamic>? initialData,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) =>
        _ReadingRecordDialog(recordId: recordId, initialData: initialData),
  );
}

class _ReadingRecordDialog extends StatefulWidget {
  final String? recordId;
  final Map<String, dynamic>? initialData;

  const _ReadingRecordDialog({this.recordId, this.initialData});

  @override
  State<_ReadingRecordDialog> createState() => _ReadingRecordDialogState();
}

class _ReadingRecordDialogState extends State<_ReadingRecordDialog> {
  final TextEditingController _chapterController = TextEditingController();
  final TextEditingController _startVerseController = TextEditingController();
  final TextEditingController _endVerseController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _selectedTestament;
  String? _selectedBook;
  String? _errorText;
  bool _saving = false;

  List<String> get _availableBooks {
    if (_selectedTestament == null) return const [];

    return BibleBooks.booksFor(_selectedTestament!);
  }

  @override
  void initState() {
    super.initState();

    final data = widget.initialData;
    if (data == null) {
      final now = DateTime.now();
      _dateController.text =
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
      return;
    }

    _selectedTestament = data['testamento'] as String?;
    _selectedBook = data['libro'] as String?;
    _chapterController.text = '${data['capitulo'] ?? ''}';
    _startVerseController.text = '${data['versiculoInicio'] ?? ''}';
    _endVerseController.text = '${data['versiculoFin'] ?? ''}';

    final fecha = data['fechaLectura'];
    if (fecha != null) {
      final date = fecha is DateTime ? fecha : (fecha as dynamic).toDate();
      _dateController.text =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  @override
  void dispose() {
    _chapterController.dispose();
    _startVerseController.dispose();
    _endVerseController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      _dateController.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    });
  }

  DateTime? _parseDate() {
    final parts = _dateController.text.split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return null;

    return DateTime(year, month, day);
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    final chapter = int.tryParse(_chapterController.text);
    final startVerse = int.tryParse(_startVerseController.text);
    final endVerse = int.tryParse(_endVerseController.text);
    final fechaLectura = _parseDate();

    if (fechaLectura == null) {
      setState(() => _errorText = 'Selecciona una fecha válida.');
      return;
    }

    if (_selectedTestament == null ||
        _selectedBook == null ||
        chapter == null ||
        startVerse == null ||
        endVerse == null) {
      setState(() {
        _errorText =
            'Completa testamento, libro, cap\u00edtulo y vers\u00edculos.';
      });
      return;
    }

    final validationError = BibleBooks.validateReference(
      bookName: _selectedBook!,
      chapter: chapter,
      startVerse: startVerse,
      endVerse: endVerse,
    );

    if (validationError != null) {
      setState(() => _errorText = validationError);
      return;
    }

    setState(() {
      _saving = true;
      _errorText = null;
    });

    try {
      await ReadingService().saveReading(
        id: widget.recordId,
        testamento: _selectedTestament!,
        libro: _selectedBook!,
        capitulo: chapter,
        versiculoInicio: startVerse,
        versiculoFin: endVerse,
        fechaLectura: fechaLectura,
      );

      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _saving = false;
        _errorText = 'No se pudo guardar el registro. Int\u00e9ntalo de nuevo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 26),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Registro de lectura b\u00edblica',
                style: AppTextStyles.body.copyWith(fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              child: IgnorePointer(
                child: TextField(
                  controller: _dateController,
                  style: AppTextStyles.body.copyWith(fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Fecha',
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _Selector(
              hint: 'Testamento',
              value: _selectedTestament,
              items: const [BibleBooks.oldTestament, BibleBooks.newTestament],
              onChanged: (value) {
                setState(() {
                  _selectedTestament = value;
                  _selectedBook = null;
                  _errorText = null;
                });
              },
            ),
            const SizedBox(height: 8),
            _Selector(
              hint: 'Libro',
              value: _selectedBook,
              items: _availableBooks,
              onChanged: _selectedTestament == null
                  ? null
                  : (value) {
                      setState(() {
                        _selectedBook = value;
                        _errorText = null;
                      });
                    },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _NumberField(
                    controller: _chapterController,
                    hint: 'Cap\u00edtulo',
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _NumberField(
                    controller: _startVerseController,
                    hint: 'V. Inicio',
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _NumberField(
                    controller: _endVerseController,
                    hint: 'V. Fin',
                  ),
                ),
              ],
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorText!,
                style: AppTextStyles.body.copyWith(
                  color: Colors.red.shade700,
                  fontSize: 14,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    child: Text(
                      'Cancelar',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(42),
                      backgroundColor: AppColors.background,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: Text(
                      _saving ? 'Guardando...' : 'Guardar',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Selector extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const _Selector({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      hint: Text(hint, style: AppTextStyles.body.copyWith(fontSize: 15)),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(fontSize: 16),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.border),
      decoration: _fieldDecoration(),
    );
  }
}

class _NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _NumberField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      style: AppTextStyles.body.copyWith(fontSize: 15),
      decoration: _fieldDecoration(hintText: hint),
    );
  }
}

InputDecoration _fieldDecoration({String? hintText}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: AppTextStyles.body.copyWith(fontSize: 14),
    filled: true,
    fillColor: AppColors.card,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primaryLight),
    ),
  );
}
