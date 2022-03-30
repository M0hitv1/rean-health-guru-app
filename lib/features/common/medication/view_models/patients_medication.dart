import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/features/common/medication/models/DrugOrderIdPojo.dart';
import 'package:paitent/features/common/medication/models/DrugsLibraryPojo.dart';
import 'package:paitent/features/common/medication/models/GetMedicationStockImages.dart';
import 'package:paitent/features/common/medication/models/GetMyMedicationsResponse.dart';
import 'package:paitent/features/common/medication/models/MyCurrentMedication.dart';
import 'package:paitent/features/common/medication/models/MyMedicationSummaryRespose.dart';
import 'package:paitent/features/misc/models/BaseResponse.dart';
import 'package:paitent/infra/networking/ApiProvider.dart';
import 'package:paitent/infra/utils/StringUtility.dart';
import 'package:paitent/infra/view_models/base_model.dart';

class PatientMedicationViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  Future<MyCurrentMedication> getMyCurrentMedications() async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get(
        '/clinical/medications/search?patientUserId=' + patientUserId,
        header: map);

    setBusy(false);
    // Convert and return
    return MyCurrentMedication.fromJson(response);
  }

  Future<GetMyMedicationsResponse> getMyMedications(String date) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get(
        '/clinical/medication-consumptions/schedule-for-day/' +
            patientUserId +
            '/' +
            date,
        header: map);

    setBusy(false);
    // Convert and return
    return GetMyMedicationsResponse.fromJson(response);
  }

  Future<BaseResponse> markMedicationsAsTaken(String consumptionId) async {
    // Get user profile for id
    //setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final body = <String, String>{};

    final response = await apiProvider.put(
        '/clinical/medication-consumptions/mark-as-taken/' + consumptionId,
        header: map,
        body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> markMedicationsAsMissed(String consumptionId) async {
    // Get user profile for id
    //setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final body = <String, String>{};

    final response = await apiProvider.put(
        '/clinical/medication-consumptions/mark-as-missed/' + consumptionId,
        header: map,
        body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<MyMedicationSummaryRespose> getMyMedicationSummary() async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get(
        '/clinical/medication-consumptions/summary-for-calendar-months/' +
            patientUserId,
        header: map);

    setBusy(false);
    // Convert and return
    return MyMedicationSummaryRespose.fromJson(response);
  }

  Future<DrugsLibraryPojo> getDrugsByKeyword(String searchKeyword) async {
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;
    final response = await apiProvider.get(
        '/clinical/drugs/search?name=' + searchKeyword,
        header: map); //4c47a191-9cb6-4377-b828-83eb9ab48d0a
    debugPrint(response.toString());
    // Convert and return
    return DrugsLibraryPojo.fromJson(response);
  }

  Future<BaseResponse> addMedicationforVisit(Map body) async {
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post('/clinical/medications',
        body: body, header: map); //4c47a191-9cb6-4377-b828-83eb9ab48d0a

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> addDrugToLibrary(Map body) async {
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;
    final response =
        await apiProvider.post('/clinical/drugs', body: body, header: map);
    debugPrint(response.toString());
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<DrugOrderIdPojo> createDrugOrderIdForVisit(Map body) async {
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post('/drug-order',
        body: body, header: map); //4c47a191-9cb6-4377-b828-83eb9ab48d0a

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return DrugOrderIdPojo.fromJson(response);
  }

  Future<GetMedicationStockImages> getMedicationStockImages() async {
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;
    final response = await apiProvider.get('/clinical/medications/stock-images',
        header: map); //4c47a191-9cb6-4377-b828-83eb9ab48d0a
    debugPrint(response.toString());
    // Convert and return
    return GetMedicationStockImages.fromJson(response);
  }
}