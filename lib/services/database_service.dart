// lib/core/services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/trip_model.dart';
import '../../models/expense_model.dart';
import '../../models/destination_model.dart';
import '../../models/review_model.dart';
import '../../models/alert_model.dart';

class DatabaseService {
  static Database? _database;
  static final DatabaseService instance = DatabaseService._();

  DatabaseService._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'visit_srilanka.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create trips table
    await db.execute('''
      CREATE TABLE trips(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        destination TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        duration INTEGER NOT NULL,
        cities TEXT NOT NULL,
        isSynced INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create expenses table
    await db.execute('''
      CREATE TABLE expenses(
        id TEXT PRIMARY KEY,
        tripId TEXT NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        currency TEXT NOT NULL,
        amountInLKR REAL NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        isSynced INTEGER DEFAULT 0,
        FOREIGN KEY (tripId) REFERENCES trips (id) ON DELETE CASCADE
      )
    ''');

    // Create destinations table
    await db.execute('''
      CREATE TABLE destinations(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        province TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        imageUrl TEXT,
        bestTimeToVisit TEXT,
        isSaved INTEGER DEFAULT 0
      )
    ''');

    // Create reviews table
    await db.execute('''
      CREATE TABLE reviews(
        id TEXT PRIMARY KEY,
        destinationId TEXT NOT NULL,
        userName TEXT NOT NULL,
        rating REAL NOT NULL,
        comment TEXT,
        date TEXT NOT NULL,
        isSynced INTEGER DEFAULT 0,
        FOREIGN KEY (destinationId) REFERENCES destinations (id) ON DELETE CASCADE
      )
    ''');

    // Create alerts table
    await db.execute('''
      CREATE TABLE alerts(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        type TEXT NOT NULL,
        location TEXT NOT NULL,
        validFrom TEXT NOT NULL,
        validTo TEXT NOT NULL,
        severity TEXT NOT NULL,
        isActive INTEGER DEFAULT 1
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_trips_date ON trips(startDate)');
    await db.execute('CREATE INDEX idx_expenses_trip ON expenses(tripId)');
    await db.execute(
      'CREATE INDEX idx_reviews_destination ON reviews(destinationId)',
    );
    await db.execute('CREATE INDEX idx_alerts_location ON alerts(location)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Example: Add new column in future version
      // await db.execute('ALTER TABLE trips ADD COLUMN newColumn TEXT');
    }
  }

  // ==========================================
  // TRIP CRUD OPERATIONS
  // ==========================================

  Future<int> insertTrip(TripModel trip) async {
    final db = await database;
    return await db.insert(
      'trips',
      trip.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TripModel>> getAllTrips() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'trips',
      orderBy: 'startDate DESC',
    );
    return List.generate(maps.length, (i) => TripModel.fromMap(maps[i]));
  }

  Future<TripModel?> getTripById(String id) async {
    final db = await database;
    final maps = await db.query('trips', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return TripModel.fromMap(maps.first);
  }

  Future<List<TripModel>> getUpcomingTrips() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final maps = await db.query(
      'trips',
      where: 'startDate >= ?',
      whereArgs: [now],
      orderBy: 'startDate ASC',
    );
    return List.generate(maps.length, (i) => TripModel.fromMap(maps[i]));
  }

  Future<List<TripModel>> getPastTrips() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final maps = await db.query(
      'trips',
      where: 'endDate < ?',
      whereArgs: [now],
      orderBy: 'endDate DESC',
    );
    return List.generate(maps.length, (i) => TripModel.fromMap(maps[i]));
  }

  Future<int> updateTrip(TripModel trip) async {
    final db = await database;
    return await db.update(
      'trips',
      trip.toMap(),
      where: 'id = ?',
      whereArgs: [trip.id],
    );
  }

  Future<int> deleteTrip(String id) async {
    final db = await database;
    // Delete associated expenses first
    await db.delete('expenses', where: 'tripId = ?', whereArgs: [id]);
    // Then delete the trip
    return await db.delete('trips', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<TripModel>> getUnsyncedTrips() async {
    final db = await database;
    final maps = await db.query('trips', where: 'isSynced = ?', whereArgs: [0]);
    return List.generate(maps.length, (i) => TripModel.fromMap(maps[i]));
  }

  // ==========================================
  // EXPENSE CRUD OPERATIONS
  // ==========================================

  Future<int> insertExpense(ExpenseModel expense) async {
    final db = await database;
    return await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ExpenseModel>> getAllExpenses() async {
    final db = await database;
    final maps = await db.query('expenses', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => ExpenseModel.fromMap(maps[i]));
  }

  Future<List<ExpenseModel>> getExpensesByTrip(String tripId) async {
    final db = await database;
    final maps = await db.query(
      'expenses',
      where: 'tripId = ?',
      whereArgs: [tripId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => ExpenseModel.fromMap(maps[i]));
  }

  Future<ExpenseModel?> getExpenseById(String id) async {
    final db = await database;
    final maps = await db.query('expenses', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return ExpenseModel.fromMap(maps.first);
  }

  Future<int> updateExpense(ExpenseModel expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(String id) async {
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getTripTotalExpenses(String tripId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amountInLKR) as total FROM expenses WHERE tripId = ?',
      [tripId],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<Map<String, double>> getTripExpensesByCategory(String tripId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT category, SUM(amountInLKR) as total FROM expenses WHERE tripId = ? GROUP BY category',
      [tripId],
    );
    Map<String, double> categoryTotals = {};
    for (var row in result) {
      categoryTotals[row['category'] as String] = (row['total'] as num)
          .toDouble();
    }
    return categoryTotals;
  }

  // ==========================================
  // DESTINATION CRUD OPERATIONS
  // ==========================================

  Future<int> insertDestination(DestinationModel destination) async {
    final db = await database;
    return await db.insert(
      'destinations',
      destination.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DestinationModel>> getAllDestinations() async {
    final db = await database;
    final maps = await db.query('destinations', orderBy: 'name ASC');
    return List.generate(maps.length, (i) => DestinationModel.fromMap(maps[i]));
  }

  Future<DestinationModel?> getDestinationById(String id) async {
    final db = await database;
    final maps = await db.query(
      'destinations',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return DestinationModel.fromMap(maps.first);
  }

  Future<List<DestinationModel>> getDestinationsByProvince(
    String province,
  ) async {
    final db = await database;
    final maps = await db.query(
      'destinations',
      where: 'province = ?',
      whereArgs: [province],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => DestinationModel.fromMap(maps[i]));
  }

  Future<List<DestinationModel>> getDestinationsByCategory(
    String category,
  ) async {
    final db = await database;
    final maps = await db.query(
      'destinations',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => DestinationModel.fromMap(maps[i]));
  }

  Future<List<DestinationModel>> getSavedDestinations() async {
    final db = await database;
    final maps = await db.query(
      'destinations',
      where: 'isSaved = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => DestinationModel.fromMap(maps[i]));
  }

  Future<int> updateDestination(DestinationModel destination) async {
    final db = await database;
    return await db.update(
      'destinations',
      destination.toMap(),
      where: 'id = ?',
      whereArgs: [destination.id],
    );
  }

  Future<int> deleteDestination(String id) async {
    final db = await database;
    return await db.delete('destinations', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // REVIEW CRUD OPERATIONS
  // ==========================================

  Future<int> insertReview(ReviewModel review) async {
    final db = await database;
    return await db.insert(
      'reviews',
      review.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ReviewModel>> getAllReviews() async {
    final db = await database;
    final maps = await db.query('reviews', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => ReviewModel.fromMap(maps[i]));
  }

  Future<List<ReviewModel>> getReviewsByDestination(
    String destinationId,
  ) async {
    final db = await database;
    final maps = await db.query(
      'reviews',
      where: 'destinationId = ?',
      whereArgs: [destinationId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => ReviewModel.fromMap(maps[i]));
  }

  Future<int> updateReview(ReviewModel review) async {
    final db = await database;
    return await db.update(
      'reviews',
      review.toMap(),
      where: 'id = ?',
      whereArgs: [review.id],
    );
  }

  Future<int> deleteReview(String id) async {
    final db = await database;
    return await db.delete('reviews', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getDestinationAverageRating(String destinationId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT AVG(rating) as average FROM reviews WHERE destinationId = ?',
      [destinationId],
    );
    return (result.first['average'] as num?)?.toDouble() ?? 0.0;
  }

  // ==========================================
  // ALERT CRUD OPERATIONS
  // ==========================================

  Future<int> insertAlert(AlertModel alert) async {
    final db = await database;
    return await db.insert(
      'alerts',
      alert.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AlertModel>> getAllAlerts() async {
    final db = await database;
    final maps = await db.query(
      'alerts',
      where: 'isActive = ?',
      whereArgs: [1],
      orderBy: 'validFrom DESC',
    );
    return List.generate(maps.length, (i) => AlertModel.fromMap(maps[i]));
  }

  Future<List<AlertModel>> getAlertsByLocation(String location) async {
    final db = await database;
    final maps = await db.query(
      'alerts',
      where: 'location LIKE ? AND isActive = ?',
      whereArgs: ['%$location%', 1],
      orderBy: 'validFrom DESC',
    );
    return List.generate(maps.length, (i) => AlertModel.fromMap(maps[i]));
  }

  Future<List<AlertModel>> getActiveAlerts() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final maps = await db.query(
      'alerts',
      where: 'isActive = ? AND validFrom <= ? AND validTo >= ?',
      whereArgs: [1, now, now],
      orderBy: 'validFrom DESC',
    );
    return List.generate(maps.length, (i) => AlertModel.fromMap(maps[i]));
  }

  Future<int> updateAlert(AlertModel alert) async {
    final db = await database;
    return await db.update(
      'alerts',
      alert.toMap(),
      where: 'id = ?',
      whereArgs: [alert.id],
    );
  }

  Future<int> deleteAlert(String id) async {
    final db = await database;
    return await db.delete('alerts', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAlerts() async {
    final db = await database;
    await db.delete('alerts');
  }

  // ==========================================
  // UTILITY METHODS
  // ==========================================

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('trips');
    await db.delete('expenses');
    await db.delete('destinations');
    await db.delete('reviews');
    await db.delete('alerts');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
