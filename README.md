# shamseenfactory

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:
 Future<void> fetchSp() async {
    final sellPoint = await DriversApi.fetchAllSellPoints();
    if (mounted) {
      setState(() {
        _sellPoint = sellPoint;
        print(_sellPoint);
      });
    }
  }
for this error lientException (Connection closed before full header was received)

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
