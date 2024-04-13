// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


contract Management {


    // model a user   ayesha,20,f,none,false,false,dhk
    struct User {
        uint256 id;
        string name;
        uint256 age;
        string gender;
        string vaccine_status;
        bool is_dead;
        bool hasCovid;
        string district;
   }

  mapping( uint256 => User ) public users;
  
  
// stores each district inforation
  struct DistrictCount {
    uint256 count;
    uint256 median;
    uint256[] age;
  }

  mapping ( string => DistrictCount) public districtCount; 
  string[] public keyNames;
  

//groups the patientt
  struct Patients {
    uint256 count;
    uint256 percentage;
  }

  mapping (string => Patients) public covidPatients;



   // store user count
   uint256 public userCount;

   uint256 public deadCount;
   uint256 public covidCount;
   uint256 public deathRate;
   uint256 public dayCount = 1;
   string public highestDistrict;
   
   
  
	//register with user info
   function addUser(string memory name, uint256 age, string memory gender, string memory vaccine_status, bool is_dead, bool hasCovid, string memory district) public {
    userCount++;
    users[userCount] = User(userCount, name, age, gender,vaccine_status, is_dead, hasCovid, district);
   }


    //change vaccine  status
   function changeVaccine(string memory status, uint256 id) public{
        users[id].vaccine_status= status; 
   }


    //cahnge Covid status.
   function changehasCovid(uint256 id) public{
      if (users[id].hasCovid == false) {
        users[id].hasCovid= true; 
        covidCount++;
        getHighestDistrict();
        string memory dis = users[id].district;
        if (districtCount[dis].count==0){
          keyNames.push(dis);
        }
        districtCount[dis].count ++;
        districtCount[dis].age.push(users[id].age);

        //sorting the age list
        uint n = districtCount[dis].age.length;
        for (uint i = 0; i < n - 1; i++) {
            for (uint j = 0; j < n - i - 1; j++) {
                if (districtCount[dis].age[j] > districtCount[dis].age[j + 1]) {
                    uint temp = districtCount[dis].age[j];
                    districtCount[dis].age[j] = districtCount[dis].age[j + 1];
                    districtCount[dis].age[j + 1] = temp;
                }
            }
        }

        //categorise the Patient-->
        if (users[id].age < 13){
          covidPatients["children"].count ++;
          covidPatients["children"].percentage = (covidPatients["children"].count * 100/ covidCount) ;
        }
        else if( users[id].age >= 13 && users[id].age < 20){
          covidPatients["teenage"].count ++;
          covidPatients["teenage"].percentage = (covidPatients["teenage"].count * 100 / covidCount) ;
        }
        else if(users[id].age >= 20 && users[id].age < 50){
          covidPatients["young"].count ++;
          covidPatients["young"].percentage = (covidPatients["young"].count * 100/ covidCount) ;
        } else {
          covidPatients["elder"].count ++;
          covidPatients["elder"].percentage = (covidPatients["elder"].count * 100/ covidCount);
        }
                
      }
   }

//change the day count when it's a new day
   function changeDayCount() public {
    dayCount++;
   }

   //change Death status
   function changeDeathStatus(uint256 id) public {
    if (users[id].is_dead == false) {
      users[id].is_dead = true;
      deadCount++;
      uint256 avg = deadCount/dayCount;
      deathRate =  avg;
   }
  }


	
   //Get the district with highest number of death here ==>

   function getHighestDistrict() public{
      string memory district; 
      uint256 highest = 0 ;
      for (uint256 i=0; i < keyNames.length; i++){
        string memory dist = keyNames[i];
        if (districtCount[dist].count >= highest){
          district = dist;
          highest = districtCount[dist].count;
        }
    }
     highestDistrict = district; 
   }
   
   
   

   // get the median in each district ==> 

   function calcMedian() public {

    for (uint256 i; i < keyNames.length; i++){
      uint256 med;
      uint256 n = districtCount[keyNames[i]].age.length;
      if (n % 2 != 0){
        med = districtCount[keyNames[i]].age[n / 2];
      } else{
        uint256 m = n/2;
        med = (districtCount[keyNames[i]].age[m-1]+districtCount[keyNames[i]].age[m])/2;
      }
      districtCount[keyNames[i]].median = med;
    }
   }

}
