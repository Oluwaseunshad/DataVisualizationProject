import java.util.Set;

class TeamData {
  int year;
  int totalSalary;
  int yearRank;
  int investmentRank;
  int winNum;
  int lossNum;
  int runScore;
  int homeRun;
  int xPos;
  int yPos;
  float performanceScore;
  float investmentScore;
  boolean divisionWin;
  boolean wildCardWin;
  boolean leagueWin;
  boolean worldSeriesWin;
  String teamId;
  String teamName;
  String leagueName;
  String franchName;
  String division;
  Set<String> players;
  Set<String> faPlayers;
  
  TeamData(int xPos, int yPos, String[] teamInfo) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.year = int(teamInfo[0]);
    this.teamId = teamInfo[1];
    this.teamName = teamInfo[2];
    this.totalSalary = int(teamInfo[3]);
    this.performanceScore = float(teamInfo[4]);
    this.investmentScore = float(teamInfo[5]);
    this.leagueName = teamInfo[6];
    this.franchName = teamInfo[7];
    this.division = teamInfo[8];
    this.yearRank = int(teamInfo[9]);
    this.winNum = int(teamInfo[10]);
    this.lossNum = int(teamInfo[11]);
    this.divisionWin = teamInfo[12].equals("Y") ? true : false;
    this.wildCardWin = teamInfo[13].equals("Y") ? true : false;
    this.leagueWin = teamInfo[14].equals("Y") ? true : false;
    this.worldSeriesWin = teamInfo[15].equals("Y") ? true : false;
    this.runScore = int(teamInfo[16]);
    this.homeRun = int(teamInfo[17]);
    this.investmentRank = int(teamInfo[18]);
    players = new HashSet<String>();
    faPlayers = new HashSet<String>();
  }
}
