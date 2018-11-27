
int teamEndYear=2016, teamStartYear=2000;    
Table playerTable;
HashMap<String, Integer> hash = new HashMap<String,Integer>();
String playerTableName = "top9foreachyear.csv";
String[] playerAttributes = {"yearID", "teamID", "lgID", "playerID", "salary", "finalGame",
       "playerName", "divID", "Rank", "W", "L", "DivWin", "WCWin", "LgWin",
       "WSWin", "name", "batterRating", "fielderRating", "pitcherRating",
       "status", "Yearinvestment"};
       
 
class PlayerData {
  int rank, win,lose,yearID;  
  String teamID,lgID,playerID, finalGame,playerName,lgwin,wswin, name, status,wcwin,divID,divwin;
  float xPos,salary,batterRating, fielderRating ,pitcherRating ,investment;
  PlayerData(float xPos, String[] playerInfo) {
    this.xPos = xPos;
    this.yearID = int(playerInfo[0]);
    this.teamID = playerInfo[1];
    this.lgID = playerInfo[2];
    this.playerID = playerInfo[3];
    this.salary = float(playerInfo[4]);
    this.finalGame = playerInfo[5];
    this.playerName = playerInfo[6];
    this.divID = playerInfo[7];
    this.rank = int(playerInfo[8]);
    this.win = int(playerInfo[9]);
    this.lose = int(playerInfo[10]);
    this.divwin = playerInfo[11];
    this.wcwin = playerInfo[12];
    this.lgwin = playerInfo[13];
    this.wswin = playerInfo[14];
    this.name = playerInfo[15];
    this.batterRating = float(playerInfo[16]);
    this.fielderRating = float(playerInfo[17]);
    this.pitcherRating = float(playerInfo[18]);
    this.status = playerInfo[19];
    this.investment = float(playerInfo[20]);
      }
}
int playerColumnCount=21;
int playerRankNum = 3;
PlayerData[][] playerData = new PlayerData[1332][teamEndYear - teamStartYear + 1]; //1332 unique players present 



float plotWidth = 700.0;
float plotHeight = 400.0;
float plotOriginX = 250;
float plotOriginY = 130;
float plotMarginX = 50;
float plotMarginY = 35;
int teamRankNum = 5;


//READ table and save data in plaerData Objects
void createPlayerObjects(){
  playerTable = loadTable(playerTableName,"header");
  int index=0;
  for (int i = 0; i < playerTable.getRowCount(); i++) {
    int inserttoindex;
     TableRow row = playerTable.getRow(i);
     if(hash.containsKey(row.getString("playerID"))){
       inserttoindex = (int)hash.get(row.getString("playerID"));
     }
     else
       {
         hash.put(row.getString("playerID"),index);
         inserttoindex = index;
         index++;
       }
    String[] playerInfo = new String[playerColumnCount];
    for (int j = 0; j < playerColumnCount; j++)
      playerInfo[j]=row.getString(playerAttributes[j]);
      //each year has 30
      //9 players from each team // 270 players for each year
     playerData[inserttoindex][i / 270] = new PlayerData(plotOriginX + plotMarginX + (plotWidth - 2 * plotMarginX) / (teamRankNum - 1) * (teamRankNum - i % teamRankNum - 1), playerInfo);
    
  }
 
}

void getPlayerDetails(String playerID){  //this function will finally draw all the playerdetails in the scrren// currently prints details on console
  int index = hash.get(playerID);
  for(PlayerData pd : playerData[index])
    if(pd!=null);
    //System.out.println(pd.salary);
}

int getHighestPaidPlayer(int year){  // returns the row corresponding to the highest paid player // so we cna obtain higest paid players for each year keep them in list and then plot them 
   int index = 0;
   float Salary = MIN_FLOAT;
  for(int i=0;i<playerData.length;i++){
    if(playerData[i][year-2000]==null)
      continue;
    if((float)playerData[i][year-2000].salary>=Salary)
     {
       index = i;
       Salary = (float)playerData[i][year-2000].salary;
     }
  }
  return index;
}
