import 'package:flutter_riverpod/flutter_riverpod.dart';

final masterDataViewModelProvider = NotifierProvider<MasterDataViewModel, MasterDataState>(
  MasterDataViewModel.new,
);

class MasterDataState {
  final List<String> brands;
  final List<String> manufacturers;
  final List<String> usageTypes;
  final List<String> units;
  final List<String> packageTypes;
  final List<String> categories;
  final List<String> subcategories;

  MasterDataState({
    this.brands = const [],
    this.manufacturers = const [],
    this.usageTypes = const [],
    this.units = const [],
    this.packageTypes = const [],
    this.categories = const [],
    this.subcategories = const [],
  });

  MasterDataState copyWith({
    List<String>? brands,
    List<String>? manufacturers,
    List<String>? usageTypes,
    List<String>? units,
    List<String>? packageTypes,
    List<String>? categories,
    List<String>? subcategories,
  }) {
    return MasterDataState(
      brands: brands ?? this.brands,
      manufacturers: manufacturers ?? this.manufacturers,
      usageTypes: usageTypes ?? this.usageTypes,
      units: units ?? this.units,
      packageTypes: packageTypes ?? this.packageTypes,
      categories: categories ?? this.categories,
      subcategories: subcategories ?? this.subcategories,
    );
  }
}

class MasterDataViewModel extends Notifier<MasterDataState> {
  @override
  MasterDataState build() {
    return MasterDataState(
      brands: ['Allergan', 'Bella Medical', 'McKesson', 'Regimen MD', 'Candela', 'Galderma', 'Merz', 'Nestle', 'Loreal', 'Unilever', 'Johnson & Johnson'],
      manufacturers: ['Allergan PLC', 'Nestle Pakistan', 'Loreal Paris Factory', 'ABC Medical Industries', 'XYZ Pharmaceuticals'],
      usageTypes: ['Treatment', 'Retailer', 'Both'],
      units: ['Gram', 'ML', 'MG', 'Piece', 'KG', 'Liter', 'Tablet', 'Capsule', 'Unit', 'Syringe', 'Vial'],
      packageTypes: ['Box', 'Pack', 'Bottle', 'Carton', 'Tube', 'Bag', 'Case', 'Tray', 'Custom'],
      categories: ['Injectables', 'Skincare', 'Equipment', 'Consumables', 'Medications'],
      subcategories: ['Neurotoxins', 'Fillers', 'Cleansers', 'Moisturizers', 'Lasers', 'Syringes', 'Needles', 'Gauze'],
    );
  }

  void addBrand(String name) {
    if (name.isNotEmpty && !state.brands.contains(name)) {
      state = state.copyWith(brands: [...state.brands, name]);
    }
  }

  void addManufacturer(String name) {
    if (name.isNotEmpty && !state.manufacturers.contains(name)) {
      state = state.copyWith(manufacturers: [...state.manufacturers, name]);
    }
  }

  void addUsageType(String name) {
    if (name.isNotEmpty && !state.usageTypes.contains(name)) {
      state = state.copyWith(usageTypes: [...state.usageTypes, name]);
    }
  }

  void addUnit(String name) {
    if (name.isNotEmpty && !state.units.contains(name)) {
      state = state.copyWith(units: [...state.units, name]);
    }
  }

  void addPackageType(String name) {
    if (name.isNotEmpty && !state.packageTypes.contains(name)) {
      state = state.copyWith(packageTypes: [...state.packageTypes, name]);
    }
  }

  void addCategory(String name) {
    if (name.isNotEmpty && !state.categories.contains(name)) {
      state = state.copyWith(categories: [...state.categories, name]);
    }
  }

  void addSubcategory(String name) {
    if (name.isNotEmpty && !state.subcategories.contains(name)) {
      state = state.copyWith(subcategories: [...state.subcategories, name]);
    }
  }
}
