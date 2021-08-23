class MarketFilterLists {
  /// CLOTHING FILTERS
  /// Clothing 'department' filter
  static String? clothingDepartment = 'Any';
  static List<String> clothingDepartmentList = [
    'Any',
    'Boys\' Fashion',
    'Girls\' Fashion',
    'Men\'s Fashion',
    'Women\'s Fashion',
  ];

  /// Cloth 'sizes' filter
  static String? clothSizes = 'Any';
  static List<String> clothSizesList = [
    'Any',
    'XS',
    'S',
    'M',
    'L',
    'XL',
    '2XL',
    '3XL',
    '4XL',
    '5XL'
  ];

  /// LAPTOP FILTERS
  ///
  /// Laptop RAM capacities
  static String? laptopRAMCapacity = 'Any';
  static List<String> laptopRAMCapacityList = [
    'Any',
    '2 GB',
    '3 GB',
    '4 GB',
    '6 GB',
    '8 GB',
    '12 GB',
    '16 GB',
    '24 GB',
    '32 GB',
    '64 GB & Above',
  ];

  /// Operating System for Laptop
  static String? operatingSys = 'Any';
  static List<String> operatingSysList = [
    'Any',
    'Windows',
    'Chrome OS',
    'Macintosh OS',
  ];

  /// Computer Graphics Processor
  static String? comGraphicsProcessor = 'Any';
  static List<String> comGraphicsProcessorList = [
    'Any',
    'NVIDIA GeForce',
    'Intel HD Graphics',
    'AMD Radeon R5',
    'Intel UHD Graphics',
    'AMD Radeon R7',
    'NVIDIA Quadro NVS',
    'AMD Radeon HD',
    'Intel Iris Graphics',
    'NVIDIA GeForce GT',
    'NVIDIA GeForce GTX',
  ];

  /// Computer Processor Type
  static String? comProcessorType = 'Any';
  static List<String> comProcessorTypeList = [
    'Any',
    'Intel Core i5',
    'Intel Celeron',
    'Intel Core i3',
    'Intel Core i7',
    'AMD A-Series',
    'Intel Pentium',
    'AMD E-Series',
    'Intel Atom',
    'Intel Core 2 Duo',
    'AMD A6',
    'AMD Athlon',
    'Intel Core M',
    'AMD A4',
  ];

  /// Computer Graphics Card Type
  static String comGraphicsCardType = 'Any';
  static List<String> comGraphicsCardTypeList = [
    'Any',
    'Integrated',
    'Dedicated',
  ];

  /// PHONE FILTERS
  ///
  /// Phone Filter for phone operating system
  static String? phoneOperatingSys = 'Any';
  static List<String> phoneOperatingSysList = [
    'Any',
    'Android',
    'iOS',
    'Blackberry',
    'Windows',
  ];

  /// Phone filter for internal storage
  static String? phoneInternalStorage = 'Any';
  static List<String> phoneInternalStorageList = [
    'Any',
    'Under 4 GB',
    '4 GB',
    '8 GB',
    '16 GB',
    '32 GB',
    '64 GB',
    '128 GB',
    '256 GB & above'
  ];

  /// Phone filter for display sizes
  static String? phoneDisplaySize = 'Any';
  static List<String> phoneDisplaySizeList = [
    'Any',
    'Up to 3.9 in',
    '4 to 4.4 in',
    '4.5 to 4.9 in',
    '5 to 5.4 in',
    '5.5 in & above'
  ];
}
