// Future<void> _fetchBillsByDateAndSchool(DateTime selectedDate) async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     var request = http.Request(
  //       'POST',
  //       Uri.parse('$baseUrl/bill/schools/get-all'),
  //     );

  //     final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');
  //     final String formattedDate = formatter.format(selectedDate);
  //     print('$formattedDate');
  //     request.headers.addAll({'Content-Type': 'application/json'});
  //     request.body = '{"date":"$formattedDate","type":"${widget.type}" }';
  //     //formattedDate
  //     //  DateFormat('yyyy-MM-dd').format(selectedDate)
  //     http.StreamedResponse response = await request.send();
  //     print("shool bills");
  //     print(request.body);

  //     if (mounted) {
  //       if (response.statusCode == 200) {
  //         var responseBody = await response.stream.bytesToString();
  //         var jsonData = json.decode(responseBody);

  //         List<School> fetchedSchools = [];
  //         for (var schoolData in jsonData['data']) {
  //           fetchedSchools.add(School.fromJson(schoolData));
  //         }

  //         if (mounted) {
  //           setState(() {
  //             _schools = fetchedSchools;
  //             _filteredSchools = _schools;
  //             _isLoading = false;
  //           });
  //         }
  //       } else {
  //         print(response.reasonPhrase);
  //         ErrorSnackbar.show(context, 'Error: ${response.reasonPhrase}');
  //       }
  //     }
  //   } catch (error) {
  //     print('Error fetching data: $error');
  //     ErrorSnackbar.show(context, 'An error occurred. Please try again later.');
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }
