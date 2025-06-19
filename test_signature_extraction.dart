import 'dart:convert';

void main() {
  // Test the exact JSON structure from the backend
  String jsonString = '''
  {
    "status": "Success",
    "code": 202001,
    "data": {
        "nJwX3s5LvQ6qjVOOUkN5jva93sBgdtJ1PrwgX4fMYR+hehjTsybfsPnfhtejhD8ezh7F9BfSI51DfFL2yAeWGuMWCj4AcolpAlcOmkO4HMs5ZTXZ5FnbP6j5MwAECW5cyzjXNRYx4dcT0jkTTQQBpnimafT9OTsGARsHElOo8gvvu6LEcRc80UMfkb4XV9Uw+CObsHw+JWIAv0E0dxRRMbAOrTCx2eqx/bPOcsa5TKseU9A3drO08VgcRT+85JJ8XkupTsjZA9h4h1tIxyOyGaspC+Jwsh3k669r3YcR8ptTz8AEwr08h3tlk2+mWOadG1oCDFICSZ+deMux/lix4w==": ""
    },
    "message": "You need to setup a PIN first before use your account"
  }
  ''';

  Map<String, dynamic> responseData = jsonDecode(jsonString);
  print('Full response: $responseData');
  print('Response data type: ${responseData.runtimeType}');

  if (responseData.containsKey('data')) {
    final dataField = responseData['data'];
    print('Data field: $dataField');
    print('Data field type: ${dataField.runtimeType}');

    if (dataField is Map<String, dynamic>) {
      print('Data field keys: ${dataField.keys.toList()}');
      String signature = dataField.keys.first;
      print('Extracted signature: "$signature"');
      print('Signature length: ${signature.length}');
    }
  }
}
