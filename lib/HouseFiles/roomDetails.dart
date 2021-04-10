class RoomDetails {
  String _state;
  String _city;
  String _colony;
  
  String _furnishingStatus;
  String _preferedType;
  String _propertyType;
  String _room;
  List<String> _facilities;
  String _monthlyRent;
  String _depositAmount;
  String _noOfBedRooms;
  String _noOFMembers;
  String _noOfBathRooms;
  String _buildArea;

  void setbuildArea(String buildArea) {
    _buildArea = buildArea;
  }

  String getBuildArea() {
    return _buildArea;
  }

  void setNoOFBedRooms(String noOfBedRooms) {
    _noOfBedRooms = noOfBedRooms;
  }

  String getNoOfBedRooms() {
    return _noOfBedRooms;
  }

  void setNoOfMemebers(String noOFMembers) {
    _noOFMembers = noOFMembers;
  }

  String getNoOfMemebers() {
    return _noOFMembers;
  }

  void setNoOfBathRooms(String noOfBathRooms) {
    _noOfBathRooms = noOfBathRooms;
  }

  String getNoOfBathRooms() {
    return _noOfBathRooms;
  }

  String getDepositAmout() {
    return _depositAmount;
  }

  void setDepositAmount(String depositAmount) {
    _depositAmount = depositAmount;
  }

  String getMonthlyRent() {
    return _monthlyRent;
  }

  void setMonthlyRent(String monthlyRent) {
    _monthlyRent = monthlyRent;
  }

  List<String> getFacilityList() {
    return _facilities;
  }

  void setFacilities(List<String> facilities) {
    _facilities = facilities;
  }

  void setPropertyType(String propertyType) {
    _propertyType = propertyType;
  }

  

  String getfurnishingStatus() {
    return _furnishingStatus;
  }

  String getpreferedType() {
    return _preferedType;
  }

  String getpropertyType() {
    return _propertyType;
  }

  String getroom() {
    return _room;
  }

  void setBathroomFurnishStatusPreferedTypePropertyTypeRoom(Map map) {
    map.forEach((key, value) {
      switch (key) {
        case "bathroom":
          _noOfBathRooms = value;
          break;
        case "furnishingStatus":
          _furnishingStatus = value;
          break;
        case "preferedType":
          _preferedType = value;
          break;
        case "propertyType":
          _propertyType = value;
          break;
        case "room":
          _room = value;
          break;
      }
    });
  }

  String getState() {
    return _state;
  }

  String getCity() {
    return _city;
  }

  String getColony() {
    return _colony;
  }

  void setStateCityColony(Map map) {
    map.forEach((key, value) {
      switch (key) {
        case 'city':
          _city = value;
          print(_city);
          break;
        case 'society':
          _colony = value;
          print(_colony);
          break;
        case 'state':
          _state = value;
          print(_state);
          break;
      }
    });
  }
}
