class SchoolData {
  final String schoolName;
  final String promoter;
  final String driver;
  final num cash;
  final num bill;
  final num expenses;
  final num returns;
  final String previousInventoryDate;
  final num previousInventoryTotal;
  final String currentInventoryDate;
  final num currentInventoryTotal;
  final num difference;
  final num doctorReturns;
  final num mangerReturns;
  final num externalBill;
  final num sentBills;
  final num receivedBills;
  final num ex_eco;
  final num store;
  final num storeSat;

  SchoolData(
      {required this.schoolName,
      required this.promoter,
      required this.driver,
      required this.cash,
      required this.bill,
      required this.expenses,
      required this.returns,
      required this.receivedBills,
      required this.sentBills,
      required this.previousInventoryDate,
      required this.previousInventoryTotal,
      required this.currentInventoryDate,
      required this.currentInventoryTotal,
      required this.difference,
      required this.doctorReturns,
      required this.mangerReturns,
      required this.externalBill,
      required this.ex_eco,
      required this.store,
      required this.storeSat});

  factory SchoolData.fromJson(Map<String, dynamic> json) {
    return SchoolData(
      schoolName: json['school_name'] ?? "",
      promoter: json['promoter'] ?? "",
      driver: json['driver'] ?? "",
      cash: json['cash'] ?? 0,
      bill: json['bill'] ?? 0,
      expenses: json['expenses'] ?? 0,
      returns: json['returns'] ?? 0,
      receivedBills: json['received_bills'] ?? 0,
      sentBills: json['sent_bills'] ?? 0,
      previousInventoryDate: json['previous_inventory_date'] ?? "",
      previousInventoryTotal: json['previous_inventory_total'] ?? 0,
      currentInventoryDate: json['current_inventory_date'] ?? "",
      currentInventoryTotal: json['current_inventory_total'] ?? 0,
      difference: json['difference'] ?? 0,
      doctorReturns: json['expens_doctor'] ?? 0,
      mangerReturns: json['expens_manager'] ?? 0,
      externalBill: json['external'] ?? 0,
      ex_eco: json['ex_eco'],
      store: json['store'],
      storeSat: json['storeSat'],
    );
  }
}
