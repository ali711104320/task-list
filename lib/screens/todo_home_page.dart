import 'package:flutter/material.dart';
import 'package:todo_list/utils/colors.dart';
import '../models/task.dart';
import '../services/database_helper.dart';
import '../widgets/task_card.dart';
import '../widgets/search_field.dart';

class ToDoHomePage extends StatefulWidget {
  @override
  _ToDoHomePageState createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDetailsController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  int? _editingIndex;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _searchController.addListener(_filterTasks);
  }

  Future<void> _loadTasks() async {
    final tasks = await DatabaseHelper.instance.fetchTasks();
    setState(() {
      _tasks = tasks;
      _filteredTasks = tasks;
    });
  }

  void _filterTasks() {
    setState(() {
      _filteredTasks = _tasks
          .where((task) => task.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _addOrUpdateTask() async {
    if (_taskNameController.text.trim().isNotEmpty) {
      final task = Task(
        id: _editingIndex != null ? _tasks[_editingIndex!].id : null,
        name: _taskNameController.text.trim(),
        details: _taskDetailsController.text.trim(),
        isFavorite: false,
      );

      if (_editingIndex == null) {
        await DatabaseHelper.instance.insertTask(task);
        _showAddTaskSnackbar(context); // عرض Snackbar عند إضافة مهمة جديدة
      } else {
        await DatabaseHelper.instance.updateTask(task);
        _editingIndex = null;
        _showEditTaskSnackbar(context); // عرض Snackbar عند تعديل مهمة
      }

      _taskNameController.clear();
      _taskDetailsController.clear();
      _loadTasks();
    }
  }

  void _editTask(int index) {
    setState(() {
      _taskNameController.text = _tasks[index].name;
      _taskDetailsController.text = _tasks[index].details;
      _editingIndex = index;
    });
    _openAddTaskDialog();
  }

  void _removeTask(int index) async {
    await DatabaseHelper.instance.deleteTask(_tasks[index].id!);
    _loadTasks();
  }

  void _toggleFavorite(int index) async {
    setState(() {
      _tasks[index].isFavorite = !_tasks[index].isFavorite;
    });
    await DatabaseHelper.instance.updateTask(_tasks[index]);
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filteredTasks = _tasks;
      }
    });
  }

  void _openAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // إضافة حواف دائرية
          ),
          backgroundColor:
              AppColors.backgroundColor, // تغيير خلفية النافذة المنبثقة
          title: Text(
            _editingIndex == null ? 'Add a new task' : 'Edit task',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: 350), // تحديد الحد الأقصى للعرض
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0), // إضافة مسافة عمودية
                child: Wrap(
                  spacing: 16, // المسافة الأفقية بين الحقول
                  runSpacing: 16, // المسافة العمودية بين الحقول
                  children: [
                    TextField(
                      controller: _taskNameController,
                      decoration: InputDecoration(
                        labelText: 'task name',
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                        hintText: 'Enter task name',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12), // حواف مستديرة
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.accentColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                    TextField(
                      controller: _taskDetailsController,
                      decoration: InputDecoration(
                        labelText: 'Mission details',
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                        hintText: 'Enter task details',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.accentColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addOrUpdateTask();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _editingIndex == null ? 'Add' : 'Edit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'cancellation',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // دالة لعرض Snackbar عند إضافة مهمة جديدة
  void _showAddTaskSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task added successfully!',
          style: TextStyle(color: AppColors.textWhite, fontSize: 16),
        ),
        backgroundColor: AppColors.successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // دالة لعرض Snackbar عند تعديل مهمة
  void _showEditTaskSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'The task has been modified successfully!',
          style: TextStyle(color: AppColors.backgroundDark, fontSize: 16),
        ),
        backgroundColor: AppColors.activeColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? SearchField(controller: _searchController)
            : Text('Task-List'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: Stack(
        children: [
          // الصورة التي ستغطي الشاشة بأكملها
          Positioned.fill(
            child: Image.asset(
              'assets/images/logo24.png', // مسار الصورة
              fit: BoxFit.cover, // الصورة ستغطي كامل المساحة
            ),
          ),
          // باقي المحتوى على الشاشة يمكن إضافته هنا

          // المحتوى فوق الصورة
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredTasks.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _filteredTasks[index].isFavorite
                                ? Colors
                                    .red // إذا كانت المهمة مفضلة، الإطار أحمر
                                : Colors.blue, // إذا لم تكن مفضلة، الإطار أزرق
                            width: 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(12), // حواف دائرية
                        ),
                        margin: EdgeInsets.symmetric(
                            vertical: 8), // مسافة بين العناصر
                        child: TaskCard(
                          task: _filteredTasks[index],
                          onEdit: () => _editTask(index),
                          onDelete: () => _removeTask(index),
                          onToggleFavorite: () => _toggleFavorite(index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskDialog,
        backgroundColor: AppColors.buttonColor,
        child: Icon(
          Icons.add_circle, // أيقونة مميزة من نوع add_circle
          size: 40, // حجم الأيقونة
          color: Colors.white, // لون الأيقونة
        ),
      ),
    );
  }
}
