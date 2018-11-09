/**
Author) Oluwaseun Shadare
*/
import java.util.*;

String salaryfileName = "Salaries.csv";
String teamfileName = "Teams.csv";
static String [] data;
static String [] teamData;
//int overal

//working with salaries from 2000 - 2016
int [] years = new int [17];
List <String> teams = new ArrayList();
List <Integer> yearID = new ArrayList();
List <Integer> winYears = new ArrayList();
List <String> winningTeams = new ArrayList();
List <Integer> numberOfWins = new ArrayList();
static int [] salary;
String [] row;
String [] winRows;
PVector [] positionHouWinsSalaries;
HashMap <String, List<Integer>> atlTotalWins = new HashMap();
     HashMap <String, List<Integer>> balTotalWins = new HashMap();
     HashMap <String, List<Integer>> bosTotalWins = new HashMap();
     HashMap <String, List<Integer>> calTotalWins = new HashMap();
     HashMap <String, List<Integer>> chaTotalWins = new HashMap();
     HashMap <String, List<Integer>> chnTotalWins = new HashMap();
     HashMap <String, List<Integer>> cinTotalWins = new HashMap();
     HashMap <String, List<Integer>> cleTotalWins = new HashMap();
     HashMap <String, List<Integer>> detTotalWins = new HashMap();
     HashMap <String, List<Integer>> houTotalWins = new HashMap();
     HashMap <String, List<Integer>> kcaTotalWins = new HashMap();
     HashMap <String, List<Integer>> lanTotalWins = new HashMap();
     HashMap <String, List<Integer>> minTotalWins = new HashMap();
     HashMap <String, List<Integer>> ml4TotalWins = new HashMap();
     HashMap <String, List<Integer>> monTotalWins = new HashMap();
     HashMap <String, List<Integer>> nyaTotalWins = new HashMap();
     HashMap <String, List<Integer>> nynTotalWins = new HashMap();
     HashMap <String, List<Integer>> oakTotalWins = new HashMap();
     HashMap <String, List<Integer>> phiTotalWins = new HashMap();
     HashMap <String, List<Integer>> pitTotalWins = new HashMap();
     HashMap <String, List<Integer>> sdnTotalWins = new HashMap();
     HashMap <String, List<Integer>> seaTotalWins = new HashMap();
     HashMap <String, List<Integer>> sfnTotalWins = new HashMap();
     HashMap <String, List<Integer>> slnTotalWins = new HashMap();
     HashMap <String, List<Integer>> texTotalWins = new HashMap();
     HashMap <String, List<Integer>> torTotalWins = new HashMap();
     HashMap <String, List<Integer>> colTotalWins = new HashMap();
     HashMap <String, List<Integer>> floTotalWins = new HashMap();
     HashMap <String, List<Integer>> anaTotalWins = new HashMap();
     HashMap <String, List<Integer>> ariTotalWins = new HashMap();
     HashMap <String, List<Integer>> milTotalWins = new HashMap();
     HashMap <String, List<Integer>> tbaTotalWins = new HashMap();
     HashMap <String, List<Integer>> laaTotalWins = new HashMap();
     HashMap <String, List<Integer>> wasTotalWins = new HashMap();
     HashMap <String, List<Integer>> miaTotalWins = new HashMap();
    List<Integer> atlWinsList = new ArrayList();
    List<Integer> balWinsList = new ArrayList();
    List<Integer> bosWinsList = new ArrayList();
    List<Integer> calWinsList = new ArrayList();
    List<Integer> chaWinsList = new ArrayList();
    List<Integer> chnWinsList = new ArrayList();
    List<Integer> cinWinsList = new ArrayList();
    List<Integer> cleWinsList = new ArrayList();
    List<Integer> detWinsList = new ArrayList();
    List<Integer> houWinsList = new ArrayList();
    List<Integer> kcaWinsList = new ArrayList();
    List<Integer> lanWinsList = new ArrayList();
    List<Integer> minWinsList = new ArrayList();
    List<Integer> ml4WinsList = new ArrayList();
    List<Integer> monWinsList = new ArrayList();
    List<Integer> nyaWinsList = new ArrayList();
    List<Integer> nynWinsList = new ArrayList();
    List<Integer> oakWinsList = new ArrayList();
    List<Integer> phiWinsList = new ArrayList();
    List<Integer> pitWinsList = new ArrayList();
    List<Integer> sdnWinsList = new ArrayList();
    List<Integer> seaWinsList = new ArrayList();
    List<Integer> sfnWinsList = new ArrayList();
    List<Integer> slnWinsList = new ArrayList();
    List<Integer> texWinsList = new ArrayList();
    List<Integer> torWinsList = new ArrayList();
    List<Integer> colWinsList = new ArrayList();
    List<Integer> floWinsList = new ArrayList();
List<Integer> anaWinsList = new ArrayList();
    List<Integer> ariWinsList = new ArrayList();
    List<Integer> milWinsList = new ArrayList();
    List<Integer> tbaWinsList = new ArrayList();
    List<Integer> laaWinsList = new ArrayList();
    List<Integer> wasWinsList = new ArrayList();
    List<Integer> miaWinsList = new ArrayList();
int margin, chartHeight;
float xSpace;

void setup(){
  //size(1700, 800);
  processData();
}
/*
void draw(){
  background(20);
  fill(200);
}
*/

void processData(){
  data = loadStrings(salaryfileName);
  teamData = loadStrings(teamfileName);
  salary  = new int[data.length];
  for (int i=1; i < data.length; ++i){
    row = split(data[i], ",");
    salary[i-1] = int(row[4]);
    teams.add(row[1]);
    yearID.add(int(row[0]));
  }
  
  for (int j=1; j < teamData.length; j++){
    winRows = split(teamData[j], ",");
    winYears.add(int(winRows[0]));
    winningTeams.add(winRows[2]);
    numberOfWins.add(int(winRows[8]));
  }
   //years that we'll be working with
  for (int i=0; i<17; i++){
    years[i] = 2000+i;
  }
  
  //remove duplicate teams in the teams list
   List<String> newListOfTeams = new ArrayList();
        for(String teamName : teams){
            if(!newListOfTeams.contains(teamName)){
                newListOfTeams.add(teamName);
            }
        }
  
    ArrayList<HashMap<String, Long>> dataList = new ArrayList<HashMap<String, Long>>();
    for (int j=0; j<years.length; j++){
      HashMap<String, Long> map = new HashMap<String, Long>();
      for (int i=0; i<teams.size(); i++){
        String myTeam = teams.get(i);
        if (years[j] == yearID.get(i) && map.containsKey(myTeam)){
          map.put(myTeam, map.get(myTeam) + salary[i]);
        }
        if (years[j] == yearID.get(i) && !(map.containsKey(myTeam))){
          map.put(myTeam, Long.valueOf(salary[i]));
        }
      }
      dataList.add(map);
    } 
    
     ArrayList<HashMap<String, Integer>> teamWinList = new ArrayList<HashMap<String, Integer>>();
    for (int j=0; j<years.length; j++){
      HashMap<String, Integer> map = new HashMap<String, Integer>();
      for (int i=0; i<winningTeams.size(); i++){
        String myTeam = winningTeams.get(i);
        if (years[j] == winYears.get(i) && newListOfTeams.contains(myTeam) && !(map.containsKey(myTeam))){
          map.put(myTeam, numberOfWins.get(i));
        }
      }
      teamWinList.add(map);
    } 
    
     HashMap <String, Long> hashMap;
     HashMap <String, List<Long>> atlTotalSalary = new HashMap();
     HashMap <String, List<Long>> balTotalSalary = new HashMap();
     HashMap <String, List<Long>> bosTotalSalary = new HashMap();
     HashMap <String, List<Long>> calTotalSalary = new HashMap();
     HashMap <String, List<Long>> chaTotalSalary = new HashMap();
     HashMap <String, List<Long>> chnTotalSalary = new HashMap();
     HashMap <String, List<Long>> cinTotalSalary = new HashMap();
     HashMap <String, List<Long>> cleTotalSalary = new HashMap();
     HashMap <String, List<Long>> detTotalSalary = new HashMap();
     HashMap <String, List<Long>> houTotalSalary = new HashMap();
     HashMap <String, List<Long>> kcaTotalSalary = new HashMap();
     HashMap <String, List<Long>> lanTotalSalary = new HashMap();
     HashMap <String, List<Long>> minTotalSalary = new HashMap();
     HashMap <String, List<Long>> ml4TotalSalary = new HashMap();
     HashMap <String, List<Long>> monTotalSalary = new HashMap();
     HashMap <String, List<Long>> nyaTotalSalary = new HashMap();
     HashMap <String, List<Long>> nynTotalSalary = new HashMap();
     HashMap <String, List<Long>> oakTotalSalary = new HashMap();
     HashMap <String, List<Long>> phiTotalSalary = new HashMap();
     HashMap <String, List<Long>> pitTotalSalary = new HashMap();
     HashMap <String, List<Long>> sdnTotalSalary = new HashMap();
     HashMap <String, List<Long>> seaTotalSalary = new HashMap();
     HashMap <String, List<Long>> sfnTotalSalary = new HashMap();
     HashMap <String, List<Long>> slnTotalSalary = new HashMap();
     HashMap <String, List<Long>> texTotalSalary = new HashMap();
     HashMap <String, List<Long>> torTotalSalary = new HashMap();
     HashMap <String, List<Long>> colTotalSalary = new HashMap();
     HashMap <String, List<Long>> floTotalSalary = new HashMap();
     HashMap <String, List<Long>> anaTotalSalary = new HashMap();
     HashMap <String, List<Long>> ariTotalSalary = new HashMap();
     HashMap <String, List<Long>> milTotalSalary = new HashMap();
     HashMap <String, List<Long>> tbaTotalSalary = new HashMap();
     HashMap <String, List<Long>> laaTotalSalary = new HashMap();
     HashMap <String, List<Long>> wasTotalSalary = new HashMap();
     HashMap <String, List<Long>> miaTotalSalary = new HashMap();
    List<Long> atlList = new ArrayList();
    List<Long> balList = new ArrayList();
    List<Long> bosList = new ArrayList();
    List<Long> calList = new ArrayList();
    List<Long> chaList = new ArrayList();
    List<Long> chnList = new ArrayList();
    List<Long> cinList = new ArrayList();
    List<Long> cleList = new ArrayList();
    List<Long> detList = new ArrayList();
    List<Long> houList = new ArrayList();
    List<Long> kcaList = new ArrayList();
    List<Long> lanList = new ArrayList();
    List<Long> minList = new ArrayList();
    List<Long> ml4List = new ArrayList();
    List<Long> monList = new ArrayList();
    List<Long> nyaList = new ArrayList();
    List<Long> nynList = new ArrayList();
    List<Long> oakList = new ArrayList();
    List<Long> phiList = new ArrayList();
    List<Long> pitList = new ArrayList();
    List<Long> sdnList = new ArrayList();
    List<Long> seaList = new ArrayList();
    List<Long> sfnList = new ArrayList();
    List<Long> slnList = new ArrayList();
    List<Long> texList = new ArrayList();
    List<Long> torList = new ArrayList();
    List<Long> colList = new ArrayList();
    List<Long> floList = new ArrayList();
    List<Long> anaList = new ArrayList();
    List<Long> ariList = new ArrayList();
    List<Long> milList = new ArrayList();
    List<Long> tbaList = new ArrayList();
    List<Long> laaList = new ArrayList();
    List<Long> wasList = new ArrayList();
    List<Long> miaList = new ArrayList();

    for(int i=0;i<dataList.size();i++)
         {
              hashMap = dataList.get(i);  
             for (Map.Entry<String, Long> entry : hashMap.entrySet())
             {
                   if (entry.getKey().equalsIgnoreCase("ATL")){
                       atlTotalSalary.put(entry.getKey(),atlList);
                       atlTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("BAL")){
                       balTotalSalary.put(entry.getKey(),balList);
                       balTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("BOS")){
                       bosTotalSalary.put(entry.getKey(),bosList);
                       bosTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("CAL")){
                       calTotalSalary.put(entry.getKey(),calList);
                       calTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("CHA")){
                       chaTotalSalary.put(entry.getKey(),chaList);
                       chaTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("CHN")){
                       chnTotalSalary.put(entry.getKey(),chnList);
                       chnTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("CIN")){
                       cinTotalSalary.put(entry.getKey(),cinList);
                       cinTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("CLE")){
                       cleTotalSalary.put(entry.getKey(),cleList);
                       cleTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("DET")){
                       detTotalSalary.put(entry.getKey(),detList);
                       detTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("HOU")){
                       houTotalSalary.put(entry.getKey(),houList);
                       houTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("KCA")){
                       kcaTotalSalary.put(entry.getKey(),kcaList);
                       kcaTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("LAN")){
                       lanTotalSalary.put(entry.getKey(),lanList);
                       lanTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("MIN")){
                       minTotalSalary.put(entry.getKey(),minList);
                       minTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("ML4")){
                       ml4TotalSalary.put(entry.getKey(),ml4List);
                       ml4TotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("MON")){
                       monTotalSalary.put(entry.getKey(),monList);
                       monTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("NYA")){
                       nyaTotalSalary.put(entry.getKey(),nyaList);
                       nyaTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                    else if (entry.getKey().equalsIgnoreCase("NYN")){
                       nynTotalSalary.put(entry.getKey(),nynList);
                       nynTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("OAK")){
                       oakTotalSalary.put(entry.getKey(),oakList);
                       oakTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("PHI")){
                       phiTotalSalary.put(entry.getKey(),phiList);
                       phiTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("PIT")){
                       pitTotalSalary.put(entry.getKey(),pitList);
                       pitTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("SDN")){
                       sdnTotalSalary.put(entry.getKey(),sdnList);
                       sdnTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("SEA")){
                       seaTotalSalary.put(entry.getKey(),seaList);
                       seaTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("SFN")){
                       sfnTotalSalary.put(entry.getKey(),sfnList);
                       sfnTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("SLN")){
                       slnTotalSalary.put(entry.getKey(),slnList);
                       slnTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("TEX")){
                       texTotalSalary.put(entry.getKey(),texList);
                       texTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("TOR")){
                       torTotalSalary.put(entry.getKey(),torList);
                       torTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("COL")){
                       colTotalSalary.put(entry.getKey(),colList);
                       colTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("FLO")){
                       floTotalSalary.put(entry.getKey(),floList);
                       floTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("ANA")){
                       anaTotalSalary.put(entry.getKey(),anaList);
                       anaTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("ARI")){
                       ariTotalSalary.put(entry.getKey(),ariList);
                       ariTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("MIL")){
                       milTotalSalary.put(entry.getKey(),milList);
                       milTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                    else if (entry.getKey().equalsIgnoreCase("TBA")){
                       tbaTotalSalary.put(entry.getKey(),tbaList);
                       tbaTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("LAA")){
                       laaTotalSalary.put(entry.getKey(),laaList);
                       laaTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("WAS")){
                       wasTotalSalary.put(entry.getKey(),wasList);
                       wasTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("MIA")){
                       miaTotalSalary.put(entry.getKey(),miaList);
                       miaTotalSalary.get(entry.getKey()).add(entry.getValue());
                   }
             }
                
         }
     
 
     HashMap <String, Integer> winsMap;
     

    for(int i=0;i<teamWinList.size();i++)
         {
              winsMap = teamWinList.get(i);  
             for (Map.Entry<String, Integer> entry : winsMap.entrySet())
             {
                   if (entry.getKey().equalsIgnoreCase("ATL")){
                       atlTotalWins.put(entry.getKey(),atlWinsList);
                       atlTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("BAL")){
                       balTotalWins.put(entry.getKey(),balWinsList);
                       balTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("BOS")){
                       bosTotalWins.put(entry.getKey(),bosWinsList);
                       bosTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("CAL")){
                       calTotalWins.put(entry.getKey(),calWinsList);
                       calTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("CHA")){
                       chaTotalWins.put(entry.getKey(),chaWinsList);
                       chaTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("CHN")){
                       chnTotalWins.put(entry.getKey(),chnWinsList);
                       chnTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("CIN")){
                       cinTotalWins.put(entry.getKey(),cinWinsList);
                       cinTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("CLE")){
                       cleTotalWins.put(entry.getKey(),cleWinsList);
                       cleTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("DET")){
                       detTotalWins.put(entry.getKey(),detWinsList);
                       detTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("HOU")){
                       houTotalWins.put(entry.getKey(),houWinsList);
                       houTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("KCA")){
                       kcaTotalWins.put(entry.getKey(),kcaWinsList);
                       kcaTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("LAN")){
                       lanTotalWins.put(entry.getKey(),lanWinsList);
                       lanTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("MIN")){
                       minTotalWins.put(entry.getKey(),minWinsList);
                       minTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("ML4")){
                       ml4TotalWins.put(entry.getKey(),ml4WinsList);
                       ml4TotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("MON")){
                       monTotalWins.put(entry.getKey(),monWinsList);
                       monTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("NYA")){
                       nyaTotalWins.put(entry.getKey(),nyaWinsList);
                       nyaTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                    else if (entry.getKey().equalsIgnoreCase("NYN")){
                       nynTotalWins.put(entry.getKey(),nynWinsList);
                       nynTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("OAK")){
                       oakTotalWins.put(entry.getKey(),oakWinsList);
                       oakTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("PHI")){
                       phiTotalWins.put(entry.getKey(),phiWinsList);
                       phiTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("PIT")){
                       pitTotalWins.put(entry.getKey(),pitWinsList);
                       pitTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("SDN")){
                       sdnTotalWins.put(entry.getKey(),sdnWinsList);
                       sdnTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("SEA")){
                       seaTotalWins.put(entry.getKey(),seaWinsList);
                       seaTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("SFN")){
                       sfnTotalWins.put(entry.getKey(),sfnWinsList);
                       sfnTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("SLN")){
                       slnTotalWins.put(entry.getKey(),slnWinsList);
                       slnTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("TEX")){
                       texTotalWins.put(entry.getKey(),texWinsList);
                       texTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("TOR")){
                       torTotalWins.put(entry.getKey(),torWinsList);
                       torTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("COL")){
                       colTotalWins.put(entry.getKey(),colWinsList);
                       colTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("FLO")){
                       floTotalWins.put(entry.getKey(),floWinsList);
                       floTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("ANA")){
                       anaTotalWins.put(entry.getKey(),anaWinsList);
                       anaTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("ARI")){
                       ariTotalWins.put(entry.getKey(),ariWinsList);
                       ariTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("MIL")){
                       milTotalWins.put(entry.getKey(),milWinsList);
                       milTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                    else if (entry.getKey().equalsIgnoreCase("TBA")){
                       tbaTotalWins.put(entry.getKey(),tbaWinsList);
                       tbaTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("LAA")){
                       laaTotalWins.put(entry.getKey(),laaWinsList);
                       laaTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("WAS")){
                       wasTotalWins.put(entry.getKey(),wasWinsList);
                       wasTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
                   else if (entry.getKey().equalsIgnoreCase("MIA")){
                       miaTotalWins.put(entry.getKey(),miaWinsList);
                       miaTotalWins.get(entry.getKey()).add(entry.getValue());
                   }
             }            
         }
       /*
   for ( Map.Entry<String, Long> entry : cinTotalWins.entrySet()) {
          String key = entry.getKey();
          Long value = entry.getValue();
          println(key + ": " + value);
    // do something with key and/or tab
      }
      */
          
          printArray(wasTotalSalary);
}       
void drawGraphForTeamHOU(){
   positionHouWinsSalaries = new PVector[houWinsList.size()];      
  
  for (int i=0; i<positionHouWinsSalaries.length; ++i){
    if (i > 0){
      stroke(200);
      line(positionHouWinsSalaries[i].x, positionHouWinsSalaries[i].y, positionHouWinsSalaries[i-1].x, positionHouWinsSalaries[i-1].y);
  }
  }
   
  //display text on y-axis
  text("A graph showing the index of accessibility to radial highways (y-axis) and the weighted mean of distances to five Boston employment centres(x-axis) in the suburbs of Boston", positionCrimePTRatio[125].x - 15, height - margin + 50);
 
}



/**
void getMinMaxForHouWinsAndSalaries(){
  
  overallTaxMin = min(tax);
  overallTaxMax = max(tax);
  midOverallTax = (overallTaxMin + overallTaxMax)/2;
  firstQuartTax = (overallTaxMin + midOverallTax) / 2;
  lastQuartTax = (overallTaxMax + midOverallTax) / 2; 
  
  double minLstat = lstat[0];
  double maxLstat = lstat[0];

  //get the overall minimum and maximum lstat value
  for (int i=1; i< lstat.length; i++){
    minLstat = Math.min(minLstat, lstat[i]);
    maxLstat = Math.max(maxLstat, lstat[i]);
  }
  overallLowerStatMin = (float)minLstat;
  overallLowerStatMax = (float)maxLstat;
  midLstat = (overallLowerStatMin+overallLowerStatMax)/2;
  firstQuartLstat = (overallLowerStatMin + midLstat) / 2;
  lastQuartLstat = (overallLowerStatMax + midLstat) / 2;

}

void mapTaxValuesToPositions(){
  
    for (int i=0; i<tax.length; i++){
    float theTax = map(tax[i], overallTaxMin, overallTaxMax, 0, chartHeight);
    float yPos = height - margin - theTax;
    float xPos = margin + (xSpace * i);
    positionTaxAndLstat[i] = new PVector(xPos, yPos);
  }
}
**/
