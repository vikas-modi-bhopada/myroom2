class RoomDetails {
  String _state;
  String _city;
  String _colony;
  String _furnishingStatus;
  String _tenantType;
  String _propertyType;
  String _room;
  List<dynamic> _facilities;
  String _monthlyRent;
  String _depositAmount;
  String _noOfBedRooms;
  String _noOFMembers;
  String _noOfBathRooms;
  String _buildArea;

  String _ownerName;
  String _ownerContactNo;
  String _ownerAddress;

  String getOwnerName() {
    return _ownerName;
  }

  String getOwnerContactNo() {
    return _ownerContactNo;
  }

  String getOwnerAddress() {
    return _ownerAddress;
  }

  void setOwnerName(String ownerName) {
    _ownerName = ownerName;
  }

  void setOwnerContactNO(String ownerContactNo) {
    _ownerContactNo = ownerContactNo;
  }

  void setOwnerAddress(String ownerAddress) {
    _ownerAddress = ownerAddress;
  }

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

  List<dynamic> getFacilityList() {
    return _facilities;
  }

  void setFacilities(List<dynamic> facilities) {
    _facilities = facilities;
  }

  void setPropertyType(String propertyType) {
    _propertyType = propertyType;
  }

  String getfurnishingStatus() {
    return _furnishingStatus;
  }

  String gettenantType() {
    return _tenantType;
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
          _tenantType = value;
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
