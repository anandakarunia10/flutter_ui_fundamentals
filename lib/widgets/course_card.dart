import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final isFav = provider.isFavorite(course.code);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(course.status).withValues(alpha: 0.2),
          child: Text(
            course.code.substring(
              0,
              course.code.length > 3 ? 3 : course.code.length,
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getStatusColor(course.status),
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          '${course.credits} SKS • Status: ${course.status}',
          style: const TextStyle(fontSize: 13),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol Favorit
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.grey,
              ),
              onPressed: () => provider.toggleFavorite(course.code),
            ),
            // Tombol Edit (Tahap 14)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditDialog(context, course),
            ),
            // Tombol Delete (Tahap 15)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _showDeleteDialog(context, course),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'done':
        return Colors.green;
      case 'active':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  // Dialog Edit Course (Tahap 14)
  void _showEditDialog(BuildContext context, Course course) {
    final titleController = TextEditingController(text: course.title);
    final creditsController =
        TextEditingController(text: course.credits.toString());
    String selectedStatus = course.status;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Course (${course.code})'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration:
                          const InputDecoration(labelText: 'Judul Course'),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Wajib diisi' : null,
                    ),
                    TextFormField(
                      controller: creditsController,
                      decoration: const InputDecoration(labelText: 'SKS'),
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Wajib diisi';
                        if (int.tryParse(val) == null) return 'Harus angka';
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: selectedStatus,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: const [
                        DropdownMenuItem(
                          value: 'planned',
                          child: Text('Planned'),
                        ),
                        DropdownMenuItem(
                          value: 'active',
                          child: Text('Active'),
                        ),
                        DropdownMenuItem(
                          value: 'done',
                          child: Text('Done'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => selectedStatus = val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    final updated = Course(
                      id: course.id,
                      code: course.code,
                      title: titleController.text.trim(),
                      credits: int.parse(creditsController.text.trim()),
                      status: selectedStatus,
                    );

                    final provider =
                        Provider.of<CourseProvider>(context, listen: false);
                    final success =
                        await provider.updateCourse(course.id!, updated);

                    if (!dialogContext.mounted) return;
                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Course berhasil diperbarui!'
                              : 'Gagal memperbarui course.',
                        ),
                        backgroundColor:
                            success ? Colors.green : Colors.red,
                      ),
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Dialog Delete Course (Tahap 15)
  void _showDeleteDialog(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Course'),
          content: Text('Apakah Anda yakin ingin menghapus "${course.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final provider =
                    Provider.of<CourseProvider>(context, listen: false);
                final success =
                    await provider.deleteCourse(course.id!, course.code);

                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Course berhasil dihapus!'
                          : 'Gagal menghapus course.',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              },
              child:
                  const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}