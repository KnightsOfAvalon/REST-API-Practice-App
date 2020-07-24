import 'dart:convert';

import 'package:rest_api_project/models/api_response.dart';
import 'package:rest_api_project/models/note_for_listing.dart';
import 'package:http/http.dart' as http;

class NotesService {

  static const API = "http://api.notes.programmingaddict.com";
  static const headers = {
    // The API Key has been removed to protect sensitive data
    'apiKey': "GENERATE YOUR UNIQUE KEY AT http://api.notes.programmingaddict.com/swagger/index.html"
  };

  Future<APIResponse<List<NoteForListing>>> getNotesList() {
    return http.get(API + "/notes", headers: headers)
      .then((data) {
        if (data.statusCode == 200) {
          final jsonData = jsonDecode(data.body);
          final notes = <NoteForListing>[];
          for (var item in jsonData) {
            final note = NoteForListing(
              noteID: item["noteID"],
              noteTitle: item["noteTitle"],
              createDateTime: DateTime.parse(item["createDateTime"]),
              latestEditDateTime: item["latestEditDateTime"] != null ? DateTime.parse(item["latestEditDateTime"]) : null,
            );
            notes.add(note);
          }
          return APIResponse<List<NoteForListing>>(
            data: notes,
          );
        }
        return APIResponse<List<NoteForListing>>(
          error: true,
          errorMessage: "Whoops! An error occurred!",
        );
      })
      .catchError((_) => APIResponse<List<NoteForListing>>(
        error: true,
        errorMessage: "Whoops! An error occurred!",)
      );
  }
}