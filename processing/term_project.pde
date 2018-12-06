import controlP5.*;
import java.util.*;

ControlP5 cp5;
PFont f;
int windowWidth = 1200;
int windowHeight = 680;

// mode
int currentMode = 0;
int targetMode = 0;
int dropdownPosX = 30;
int dropdownPosY = 80;
float transitionOpacity = 0;
boolean fadingOut = false;
boolean modeTransitioning = false;
List dropdownItemList = Arrays.asList("Team Ranking", "Player Ranking", "Other 1", "Other 2", "Other 3");
ScrollableList modeDropList;

// team
int teamMode = 0;
int teamTargetMode = 0;
int teamCount = 30;
int teamStartYear = 2000;
int teamEndYear = 2016;
int teamColumnCount = 18;
int teamRankNum = 10;
int[] avgTotalSalary = new int[teamEndYear - teamStartYear + 1];
float changeSpeed = 0.04;
color teamDefaultColor = color(102, 102, 102);
color teamButtonHighlight = #DC143C;
Table teamTable;
boolean teamSelectTransition = false;
String[] teamAttributes = {"year", "teamid", "teamname", "salary", "score", 
                       "finalscore", "lgid", "franchname", "divid", "rank",
                       "w", "l", "divwin", "wcwin", "lgwin", "wswin", "r", "hr"};
String[] teamID = {"ANA", "ARI", "ATL", "BAL", "BOS", "CHA", "CHN", "CIN", "CLE", "COL",
                   "DET", "FLO", "HOU", "KCA", "LAN", "MIL", "MIN", "MON", "NYA", "NYN",
                   "OAK", "PHI", "PIT", "SDN", "SEA", "SFN", "SLN", "TBA", "TEX", "TOR",
                   "LAA", "MIA", "WAS"};
color[] teamColor = {#003263, #BA0021, #A71930, #E3D4AD, #13274F, #CE1141, #000000, #DF4601, #BD3039, #0C2340, #27251F, #C4CED4, #0E3386, #CC3433, #C6011F, #000000, #E31937, #0C2340, #33006F, #C4CED4,
                     #0C2340, #FA4616, #00A3E0, #EF3340, #002D62, #EB6E1F, #004687, #BD9B60, #005A9C, #EF3E42, #0A2351, #B6922E, #002B5C, #D31145, #003087, #E4002B, #003087, #E4002C, #002D72, #FF5910,
                     #003831, #EFB21E, #E81828, #284898, #27251F, #FDB827, #002D62, #A2AAAD, #0C2C56, #005C5C, #FD5A1E, #27251F, #C41E3A, #0C2340, #092C5C, #8FBCE6, #003278, #C0111F, #134A8E, #1D2D5C,
                     #003263, #BA0021, #00A3E0, #EF3340, #AB0003, #14225A};
TeamData[][] teamData = new TeamData[teamEndYear - teamStartYear + 1][teamCount];
Map<String, Integer> teamColorMap = new HashMap<String, Integer>();

// team mode 0
int teamMarginX = 50;
int teamMarginTop = 205;
int teamMarginBottom = 50;
int teamRadius = 18;
int teamLineMaxOpacity = 20;
int teamYearHighlight = -1;
int teamWeightX = 630;
int teamWeightY = dropdownPosY + 3;
int teamWeightWidth = 30;
int teamWeightHeight = 25;
int teamWeightBetween = 110;
int teamWeightButtonX = 970;
int teamWeightButtonY = 125;
int teamWeightLineHeight = 45;
int teamTriX = 21;
int teamTriWidth = 15;
int teamTriHeight = 12;
int teamTriY1 = 200;
int teamTriY2 = windowHeight - 40;
int teamCurrentPage = 0;
float teamLineOpacity = teamLineMaxOpacity;
color teamTextDefaultColor = #0A2351;
String teamRankHighlight = "";
String teamRankHighlightName = "";
Textfield[] weights = new Textfield[6];

// team mode 1
int teamSelectYear = -1;
int teamSelectRadius = 150;
int teamSelectMarkX = 120;
int teamSelectMarkY = 300;
int teamBackX = 30;
int teamBackY = windowHeight - 55;
int teamViewByMode = 0;
int teamInfoXPos = 450;
int teamInfoYPos = 235;
int teamInfoRowSize = 35;
int teamColorId = -1;
int teamYearTriX1 = 666;
int teamYearTriX2 = 866;
int teamYearTriY = 128;
int teamYearTriHeight = 30;
int teamYearTriWidth = 30;
int teamYearIndex;
float teamMarkOpacity = 0;
color teamGreen = #32CD32;
color teamRed = #DC143C;
String[] teamViewByLabels = {"View by Year", "View by Team"};
String teamViewByButtonLabel = teamViewByLabels[teamViewByMode];

List<TeamData> teamSelectedTeam = new ArrayList<TeamData>();
 
void setup() {
  size(1200, 680);
  background(255);
  f = createFont("Arial", 20, true);
  ControlFont font = new ControlFont(f,20);
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  
  // mode drop list
  modeDropList = cp5.addScrollableList("MODE SELECT")
     .setPosition(dropdownPosX, dropdownPosY)
     .setSize(200, 200)
     .setBarHeight(30)
     .setItemHeight(30)
     .addItems(dropdownItemList)
      .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
     ;
  cp5.getController("MODE SELECT").getCaptionLabel().setFont(font).setSize(15);
  cp5.getController("MODE SELECT").getCaptionLabel().getStyle().marginTop = 5; 
  cp5.getController("MODE SELECT").getCaptionLabel().getStyle().marginLeft = 5; 
  cp5.getController("MODE SELECT").getValueLabel().setFont(font).setSize(15);
  cp5.getController("MODE SELECT").getValueLabel().getStyle().marginTop = 5; 
  cp5.getController("MODE SELECT").getValueLabel().getStyle().marginLeft = 5;   
  
  // weight text field
  for (int i = 0; i < weights.length; i++) {
    weights[i] = cp5.addTextfield("weight" + str(i))
     .setPosition(teamWeightX + i * teamWeightBetween, teamWeightY)
     .setSize(teamWeightWidth,teamWeightHeight)
     .setCaptionLabel("")
     .setFont(createFont("arial",17))
     .setFocus(false)
     .setAutoClear(false)
     .setInputFilter(ControlP5.FLOAT)
     .setColorBackground(color(#0A2351, 256))
     .setColorForeground(color(#0A2351, 256))
     .setColor(color(255,256))
     .hide()
     ;
  }
  weights[weights.length - 1].setPosition(teamWeightX, teamWeightY + teamWeightLineHeight);
  weights[0].setText("1");
  weights[1].setText("1");
  weights[2].setText("0.8");
  weights[3].setText("1.5");
  weights[4].setText("1");
  weights[5].setText("1.5");

  // import team data
  long sum = 0;
  teamTable = loadTable("TeamFinal.csv", "header");
  for (int i = 0; i < teamTable.getRowCount(); i++) {
    TableRow row = teamTable.getRow(i);
    int year = i / teamCount;
    int rank = i % teamCount;
    String[] teamInfo = new String[teamColumnCount + 1];
    for (int j = 0; j < teamColumnCount; j++)
      teamInfo[j] = row.getString(teamAttributes[j]);
    teamInfo[teamColumnCount] = str(rank + 1);
    //teamData[year][rank] = new TeamData((windowWidth - teamMarginX * 2) / (teamEndYear - teamStartYear + 1) * year + 33 + teamMarginX,
    //                                    (windowHeight - teamMarginBottom - teamMarginTop) / teamRankNum * (rank % teamRankNum) + teamMarginTop + 30, 
    //                                    teamInfo);
    teamData[year][rank] = new TeamData((windowWidth - teamMarginX * 2) / (teamEndYear - teamStartYear) * (year - 1) + 33 + teamMarginX,
                                        (windowHeight - teamMarginBottom - teamMarginTop) / teamRankNum * (rank % teamRankNum) + teamMarginTop + 30, 
                                        teamInfo);
    sum += teamData[year][rank].totalSalary;
    if (rank == 29) {
      avgTotalSalary[year] = int(sum / 30);
      sum = 0;
    }
  }
  loadFAPlayer();
  loadTeamPlayer();
  addTeamColor();
  
  if (currentMode == 0) {
    displayWeightsTextfield(true);
  }
  else {
    displayWeightsTextfield(false);
  }
  
  modeDropList.close();
}
 
void draw() {
  background(255);

  drawProgramHeader();  
  drawModeTitle();
  
  switch (currentMode) {
    case 0:
    if (teamMode == 0) {
      drawTeamLines();
      drawTeamRanking();
      drawTeamMode0Buttons();
      if (!teamSelectTransition)
        checkTeamRankingHover();
      checkWeightsLength();
    }
    else if (teamMode == 1) {
      drawTeamInfo();
      drawTeamMode1Buttons();
      if (teamViewByMode == 0) {
        drawTeamYearInfo();
      }
      else {
        
      }
    }
    if (teamSelectTransition)
      teamSelectTransitioning();
    break;
    
    case 1:
    break;
    
    default:
    break;
  }
  
  cp5.draw();
  modeTransitioning();
}

void modeTransitioning() {
  if (modeTransitioning) {
    fill(0, transitionOpacity);
    rect(-1, -1, 1201, 681);
    if (fadingOut)
      transitionOpacity += 7;
    else
      transitionOpacity -= 7;
    if (fadingOut && transitionOpacity >= 255) {
      currentMode = targetMode;  
      if (currentMode == 0) {
        resetTeamMode();
        displayWeightsTextfield(true);
      }
      else {
        displayWeightsTextfield(false); 
      }
      fadingOut = !fadingOut;  
    }
    if (!fadingOut && transitionOpacity <= 0) {
      modeTransitioning = false;
      fadingOut = true;
      transitionOpacity = 0;
    }
  }
}

void loadFAPlayer() {
  int year = teamStartYear;
  String team = "";
  TeamData temp = null;
  Set s = null;
  // import FA player data: playerID, year, team
  teamTable = loadTable("FAPlayer.csv", "header");
  
  for (int i = 0; i < teamTable.getRowCount(); i++) {
    TableRow row = teamTable.getRow(i);
    if (!team.equals(row.getString("team")) || year != int(row.getString("year"))) {
      if (s != null)
        temp.faPlayers = s;
      year = int(row.getString("year"));
      team = row.getString("team");
      temp = findTeamData(year - teamStartYear, team);
      //if (temp == null) System.out.println(team);
      s = temp.faPlayers;
    }
    s.add(row.getString("playerID"));
  }
}

void loadTeamPlayer() {
  int year = teamStartYear;
  String team = "";
  TeamData temp = null;
  Set s = null;
  // import FA player data: playerID, year, team
  teamTable = loadTable("TeamPlayer.csv", "header");
  
  for (int i = 0; i < teamTable.getRowCount(); i++) {
    TableRow row = teamTable.getRow(i);
    if (!team.equals(row.getString("team")) || year != int(row.getString("year"))) {
      if (s != null)
        temp.players = s;
      year = int(row.getString("year"));
      team = row.getString("team");
      temp = findTeamData(year - teamStartYear, team);
      //if (temp == null) System.out.println(team);
      s = temp.players;
    }
    s.add(row.getString("playerID"));
  }
}

TeamData findTeamData(int index, String team) {
  for (int i = 0; i < teamCount; i++) {
     if (teamData[index][i].teamId.equals(team)) {
       return teamData[index][i];
     }
  }
  return null;
}

void displayWeightsTextfield(boolean show) {
  for (int i = 0; i < weights.length; i++) {
    if (show)
      weights[i].show();
    else
      weights[i].hide();
  }
}

void checkWeightsLength() {
  for (Textfield tf : weights) {
    if (str(float(tf.getText())).length() > 3) {
      tf.setText(tf.getText().substring(0, tf.getText().length() - 1));
    }
  }
}

void setWeightsOpacity(float opacity) {
  for (Textfield tf : weights) {
    tf.setColor(color(255, opacity));
    tf.setColorBackground(color(#0A2351, opacity));
    tf.setColorForeground(color(#0A2351, opacity));
  }
}

void drawProgramHeader() {
  fill(0);
  textFont(f, 15);
  textAlign(LEFT);
  text("CS6260 Term Project", 30, 30);
  text("Che Shian Hung, Dewan Chaulagain, Oluwaseun Sesan Shadare, Shadi Moradi", 30, 55);
}

void drawModeTitle() {
  fill(0);
  textAlign(LEFT);
  textFont(f, 42);
  if (currentMode == 0) {
    textFont(f, 38); 
    text("Baseball Team Investment Ranking", 580, 55);
  }
  else
    text("Let's help " + ((currentMode % 2 == 0) ? "Dr. Lee" : "Brandon") + "!", 700, 55);
  //textFont(f, 20);
  //text("to find the cheapest best " + modeText[currentMode].toLowerCase() + " :)", 650, 95);
}

void addTeamColor() {
  for (int i = 0; i < teamID.length; i++) {
    teamColorMap.put(teamID[i], i);
  }
}

// controlEvent monitors clicks on the gui
void controlEvent(ControlEvent theEvent) {
  // checkbox event
  if (theEvent.isFrom(modeDropList)) {
    switch (theEvent.getController().getName()) {
      case "MODE SELECT":
        if (int(theEvent.getController().getValue()) != currentMode) {
          targetMode = int(theEvent.getController().getValue());
          modeTransitioning = true;
          fadingOut = true;
        }
        break;
      default:
        break;
    }
  }
}

void resetTeamMode() {
  teamSelectYear = -1;
  teamSelectTransition = false;
  teamMode = 0;
  teamTargetMode = 0;
  teamLineOpacity = teamLineMaxOpacity;
  setWeightsOpacity(255);
}

void drawTeamLines() {
  fill(teamTextDefaultColor, teamLineOpacity * 12);
  textFont(f, 16);
  textAlign(LEFT);
  int weightTextY = dropdownPosY + 23;
  text("Performance score =", 460, weightTextY);
  text("* W/L +", teamWeightX + teamWeightWidth + 12, weightTextY);
  text("* DivW +", teamWeightX + teamWeightWidth * 2 + teamWeightBetween - 21, weightTextY);
  text("* WcW +", teamWeightX + teamWeightWidth * 3 + teamWeightBetween * 2 - 53, weightTextY);
  text("* LgW +", teamWeightX + teamWeightWidth * 4 + teamWeightBetween * 3 - 80, weightTextY);
  text("* WsW", teamWeightX + teamWeightWidth * 5 + teamWeightBetween * 4 - 110, weightTextY);
  text("Investment score    =", 460, weightTextY + teamWeightLineHeight);
  text("* (AvgSalary / Salary - 1)  +  P. score", teamWeightX + teamWeightWidth + 12, weightTextY + teamWeightLineHeight);
  
  fill(teamTextDefaultColor, teamLineOpacity * 2);
  stroke(0, teamLineOpacity);
  text(str(teamStartYear + 1), teamMarginX + 15, teamMarginTop - 10);
  //for(int i = 1; i <= teamEndYear - teamStartYear; i++) {
  //  text(str(teamStartYear + i), (windowWidth - teamMarginX * 2) / (teamEndYear - teamStartYear + 1) * i + teamMarginX + 15, teamMarginTop - 10);
  //  line((windowWidth - teamMarginX * 2) / (teamEndYear - teamStartYear + 1) * i + teamMarginX, teamMarginTop - 15, (windowWidth - teamMarginX * 2) / (teamEndYear - teamStartYear + 1) * i + teamMarginX, windowHeight - teamMarginBottom); 
  //}
  for(int i = 1; i <= teamEndYear - teamStartYear - 1; i++) {
    text(str(teamStartYear + i + 1), (windowWidth - teamMarginX * 2) / (teamEndYear - teamStartYear) * i + teamMarginX + 15, teamMarginTop - 10);
    line((windowWidth - teamMarginX * 2) / (teamEndYear - teamStartYear) * i + teamMarginX, teamMarginTop - 15, (windowWidth - teamMarginX * 2) / (teamEndYear - teamStartYear) * i + teamMarginX, windowHeight - teamMarginBottom); 
  }
  fill(teamTextDefaultColor, teamLineOpacity * 2);
  for (int i = 10 * teamCurrentPage; i < 10 * teamCurrentPage + teamRankNum; i++) {
    text(str(i + 1), 20, (windowHeight - teamMarginBottom - teamMarginTop) / teamRankNum * (i % 10) + teamMarginTop + 35);
  }
  line(teamMarginX + 10, teamMarginTop, windowWidth - teamMarginX - 10, teamMarginTop);
}

void drawTeamRanking() {
  noStroke();
  textFont(f, 16);
  int opacity;
  //for (int i = 0; i < teamData.length; i++) {
  //  for (int j = 10 * teamCurrentPage; j < 10 * teamCurrentPage + teamRankNum; j++) {
  //    int colorIndex = teamColorMap.get(teamData[i][j].teamId);
  //    if(teamData[i][j].teamId.equals(teamRankHighlight)) {
  //      opacity = int(teamLineOpacity * 12);
  //    }
  //    else
  //      opacity = int(teamLineOpacity * 4);
  //    fill(teamColor[colorIndex * 2], opacity);
  //    arc(teamData[i][j].xPos, teamData[i][j].yPos, teamRadius, teamRadius, -PI, 0);
  //    fill(teamColor[colorIndex * 2 + 1], opacity);
  //    arc(teamData[i][j].xPos, teamData[i][j].yPos, teamRadius, teamRadius, 0, PI);
  //  }
  //}
  for (int i = 1; i < teamData.length; i++) {
    for (int j = 10 * teamCurrentPage; j < 10 * teamCurrentPage + teamRankNum; j++) {
      int colorIndex = teamColorMap.get(teamData[i][j].teamId);
      if(teamData[i][j].teamId.equals(teamRankHighlight)) {
        opacity = int(teamLineOpacity * 12);
      }
      else
        opacity = int(teamLineOpacity * 4);
      fill(teamColor[colorIndex * 2], opacity);
      arc(teamData[i][j].xPos, teamData[i][j].yPos, teamRadius, teamRadius, -PI, 0);
      fill(teamColor[colorIndex * 2 + 1], opacity);
      arc(teamData[i][j].xPos, teamData[i][j].yPos, teamRadius, teamRadius, 0, PI);
    }
  }
  if (teamRankHighlightName.length() > 0) {
    fill(teamDefaultColor, teamLineOpacity * 12);
    textFont(f, 25);
    textAlign(LEFT);
    text(teamRankHighlightName, 70, 160);
  }
  stroke(0);
}

void drawTeamInfo() {
  noStroke();
  fill(teamColor[teamColorId * 2], teamMarkOpacity);
  arc(teamSelectMarkX, teamSelectMarkY, teamSelectRadius, teamSelectRadius, -PI, 0);
  fill(teamColor[teamColorId * 2 + 1], teamMarkOpacity);
  arc(teamSelectMarkX, teamSelectMarkY, teamSelectRadius, teamSelectRadius, 0, PI);
  fill(teamColor[teamColorId * 2], teamMarkOpacity);
  
  textFont(f, 40);
  textAlign(LEFT);
  if (teamSelectedTeam.get(0).teamId.equals("LAA")) {
    text("Los Angeles Angels\nof Anahem", teamSelectMarkX / 3.5, teamSelectMarkY + 155);
    textFont(f, 35);
    fill(teamColor[teamColorId * 2 + 1], teamMarkOpacity);
    text("(" + teamSelectedTeam.get(0).teamId + ")", teamSelectMarkX / 3.5, teamSelectMarkY + 265);
  }
  else {
    text(teamSelectedTeam.get(0).teamName, teamSelectMarkX / 3.5, teamSelectMarkY + 155);
    textFont(f, 35);
    fill(teamColor[teamColorId * 2 + 1], teamMarkOpacity);
    text("(" + teamSelectedTeam.get(0).teamId + ")", teamSelectMarkX / 3.5, teamSelectMarkY + 215);
  }
}

void drawTeamYearInfo() {
  int rightPos = teamInfoXPos + 330;
  TeamData td = teamSelectedTeam.get(teamYearIndex);
  fill(teamDefaultColor, teamMarkOpacity);
  textFont(f, 50);
  textAlign(CENTER);
  text(str(td.year), rightPos, 160);
  
  textAlign(LEFT);
  fill(teamColor[teamColorId * 2], teamMarkOpacity / 2);
  textFont(f, 30);  
  
  text("League:", teamInfoXPos, teamInfoYPos + 0 * teamInfoRowSize);
  text("Division:", teamInfoXPos, teamInfoYPos + 1 * teamInfoRowSize);
  text("Win:", teamInfoXPos, teamInfoYPos + 2 * teamInfoRowSize);
  text("Loss:" , teamInfoXPos, teamInfoYPos + 3 * teamInfoRowSize);
  text("Homerun:", teamInfoXPos, teamInfoYPos + 4 * teamInfoRowSize);
  text("Runs Scored:", teamInfoXPos, teamInfoYPos + 5 * teamInfoRowSize);
  text("Year Rank:", teamInfoXPos, teamInfoYPos + 6 * teamInfoRowSize);
  text("Investment Rank:", teamInfoXPos, teamInfoYPos + 7 * teamInfoRowSize);
  text("Achievement:", teamInfoXPos, teamInfoYPos + 8 * teamInfoRowSize);
  
  textAlign(RIGHT);
  fill(teamColor[teamColorId * 2 + 1], teamMarkOpacity);
  text(td.leagueName, rightPos, teamInfoYPos + 0 * teamInfoRowSize);
  text(td.division, rightPos, teamInfoYPos + 1 * teamInfoRowSize);
  text(str(td.winNum), rightPos, teamInfoYPos + 2 * teamInfoRowSize);
  text(str(td.lossNum), rightPos, teamInfoYPos + 3 * teamInfoRowSize);
  text(str(td.homeRun), rightPos, teamInfoYPos + 4 * teamInfoRowSize);
  text(str(td.runScore), rightPos, teamInfoYPos + 5 * teamInfoRowSize);
  text(str(td.yearRank), rightPos, teamInfoYPos + 6 * teamInfoRowSize);
  text(str(td.investmentRank), rightPos, teamInfoYPos + 7 * teamInfoRowSize);
  
  List<String> achievement = new ArrayList<String>();
  if (td.divisionWin) achievement.add("Division Winner");
  if (td.wildCardWin) achievement.add("Wild Card Winner");
  if (td.leagueWin) achievement.add("League Winner");
  if (td.worldSeriesWin) achievement.add("World Series Winner!!");
  if (achievement.size() == 0) achievement.add("None");
  for (int i = 0; i < achievement.size(); i++) {
    text(achievement.get(i), rightPos, teamInfoYPos + (9 + i) * teamInfoRowSize + 10);
  }
  
  rightPos += 40;
  textAlign(LEFT);
  fill(teamColor[teamColorId * 2], teamMarkOpacity / 2);
  text("Total Salary:", rightPos, teamInfoYPos + 0 * teamInfoRowSize);
  text("FA Player:", rightPos, teamInfoYPos + 4 * teamInfoRowSize);
  text("Non-FA Player:", rightPos, teamInfoYPos + 5 * teamInfoRowSize);
  text("New FA Player:", rightPos, teamInfoYPos + 6 * teamInfoRowSize);
  text("New Non-FA Player:", rightPos, teamInfoYPos + 7 * teamInfoRowSize);
  text("Performance Score:", rightPos, teamInfoYPos + 9 * teamInfoRowSize);
  text("Investment Score:", rightPos, teamInfoYPos + 10.7 * teamInfoRowSize);
  
  textAlign(RIGHT);
  fill(teamColor[teamColorId * 2 + 1], teamMarkOpacity);
  int pIdCount;
  String[] scores = new String[7];
  String diff = str(abs(td.totalSalary - teamSelectedTeam.get(teamYearIndex - 1).totalSalary));
  String temp = diff;
  scores[0] = str(td.totalSalary);
  for (int i = 3; i < str(td.totalSalary).length(); i += 3) {
    scores[0] = scores[0].substring(0, str(td.totalSalary).length() - i) + "," + scores[0].substring(str(td.totalSalary).length() - i);
  }
  for (int i = 3; i < temp.length(); i += 3) {
    diff = diff.substring(0, temp.length() - i) + "," + diff.substring(temp.length() - i);
  }
  scores[1] = str(td.faPlayers.size());
  pIdCount = 0;
  for (String pId: td.faPlayers)
    if (td.players.contains(pId))
      pIdCount++;
  scores[2] = str(td.players.size() - pIdCount);
  pIdCount = 0;
  for (String pId: td.faPlayers)
    if (teamSelectedTeam.get(teamYearIndex - 1).players.contains(pId) || teamSelectedTeam.get(teamYearIndex - 1).faPlayers.contains(pId))
      pIdCount++;
  scores[3] = str(td.faPlayers.size() - pIdCount);
  pIdCount = 0;
  for (String pId: td.players)
    if (teamSelectedTeam.get(teamYearIndex - 1).players.contains(pId) || teamSelectedTeam.get(teamYearIndex - 1).faPlayers.contains(pId))
      pIdCount++;
  scores[4] = str(td.players.size() - pIdCount);
  scores[5] = nf(td.performanceScore, 1, 2);
  scores[6] = nf(td.investmentScore, 1, 2);
  textAlign(RIGHT);
  for (int i = 0; i < 4; i++) {
    text(scores[i + 1], windowWidth - 50, teamInfoYPos + (4 + (i * 1)) * teamInfoRowSize);
  }
  text(scores[0], windowWidth - 50, teamInfoYPos + 1.5 * teamInfoRowSize + 20);
  for (int i = 0; i < scores.length - 5; i++) {
    text(scores[i + 5], windowWidth - 50, teamInfoYPos + (9.9 + (i * 1.6)) * teamInfoRowSize);
  }
  
  if (td.totalSalary > teamSelectedTeam.get(teamYearIndex - 1).totalSalary) {
    fill(teamRed, teamMarkOpacity / 1.3);
    diff = "+" + diff;
  }
  else {
    fill(teamGreen, teamMarkOpacity / 1.3);
    diff = "-" + diff;
  }
  text("( " + diff + " )", windowWidth - 32, teamInfoYPos + 1.5 * teamInfoRowSize - 15);
  textAlign(LEFT);
}

void drawTeamMode0Buttons() {
  strokeWeight(3);
  color c = teamDefaultColor;
  if (mouseX > teamWeightButtonX && mouseX < teamWeightButtonX + 80 && mouseY > teamWeightButtonY && mouseY < teamWeightButtonY + 30)
    c = teamButtonHighlight;
  textFont(f, 25);
  textAlign(LEFT);
  fill(255);
  stroke(c, teamLineOpacity * 10);
  rect(teamWeightButtonX, teamWeightButtonY, 80, 30); 
  fill(c, teamLineOpacity * 10);
  text("Rank", teamWeightButtonX + 11, teamWeightButtonY + 25);
  
  int teamWeightButtonX2 = teamWeightButtonX +100;
  
  c = teamDefaultColor;
  if (mouseX > teamWeightButtonX2 && mouseX < teamWeightButtonX2 + 80 && mouseY > teamWeightButtonY && mouseY < teamWeightButtonY + 30)
    c = teamButtonHighlight;
  fill(255);
  stroke(c, teamLineOpacity * 10);
  rect(teamWeightButtonX2, teamWeightButtonY, 80, 30); 
  fill(c, teamLineOpacity * 10);
  text("Reset", teamWeightButtonX2 + 7, teamWeightButtonY + 25);
  
  strokeWeight(0);
  if (teamCurrentPage != 0) {
    c = teamDefaultColor;
    if (mouseX > teamTriX - 2 && mouseX < teamTriX + teamTriWidth + 2 && mouseY > teamTriY1 - teamTriHeight - 2 && mouseY < teamTriY1 + 2)
      c = teamButtonHighlight;
    fill(c, teamLineOpacity * 8);
    triangle(teamTriX, teamTriY1, teamTriX + teamTriWidth, teamTriY1, teamTriX + teamTriWidth / 2, teamTriY1 - teamTriHeight);
  }
  
  if (teamCurrentPage != 2) {
    c = teamDefaultColor;
    if (mouseX > teamTriX - 2 && mouseX < teamTriX + teamTriWidth + 2 && mouseY > teamTriY2 - 2 && mouseY < teamTriY2 + teamTriHeight + 2)
      c = teamButtonHighlight;
    fill(c, teamLineOpacity * 8);
    triangle(teamTriX, teamTriY2, teamTriX + teamTriWidth, teamTriY2, teamTriX + teamTriWidth / 2, teamTriY2 + teamTriHeight);
  }
  strokeWeight(1);
}

void drawTeamMode1Buttons() {
  strokeWeight(3);
  color c = teamDefaultColor;
  if (mouseX > teamBackX && mouseX < teamBackX + 80 && mouseY > teamBackY && mouseY < teamBackY + 30)
    c = teamButtonHighlight;
  textFont(f, 25);
  textAlign(LEFT);
  fill(255);
  stroke(c, teamMarkOpacity / 2);
  rect(teamBackX, teamBackY, 80, 30); 
  fill(c, teamMarkOpacity);
  text("Back", teamBackX + 11, teamBackY + 25);
  
  c = teamDefaultColor;
  if (mouseX > teamBackX + 130 && mouseX < teamBackX + 310 && mouseY > teamBackY && mouseY < teamBackY + 30)
    c = teamButtonHighlight;
  fill(255);
  stroke(c, teamMarkOpacity / 2);
  rect(teamBackX + 130, teamBackY, 180, 30); 
  fill(c, teamMarkOpacity);
  text(teamViewByButtonLabel, teamBackX + 141, teamBackY + 25);
  
  if (teamViewByMode == 0) {
    strokeWeight(0);
    if (teamYearIndex != 1) {
      c = teamDefaultColor;
      if (mouseX > teamYearTriX1 - 2 && mouseX < teamYearTriX1 + teamYearTriWidth + 2 && mouseY > teamYearTriY - 2 && mouseY < teamYearTriY + teamYearTriHeight + 2)
        c = teamButtonHighlight;
      fill(c, teamMarkOpacity / 2);
      triangle(teamYearTriX1, teamYearTriY + teamYearTriHeight / 2, teamYearTriX1 + teamYearTriWidth, teamYearTriY, teamYearTriX1 + teamYearTriWidth, teamYearTriY + teamYearTriHeight);
    }
    
    if (teamYearIndex != teamSelectedTeam.size() - 1) {
      c = teamDefaultColor;
      if (mouseX > teamYearTriX2 - 2 && mouseX < teamYearTriX2 + teamYearTriWidth + 2 && mouseY > teamYearTriY - 2 && mouseY < teamYearTriY + teamYearTriHeight + 2)
        c = teamButtonHighlight;
      fill(c, teamMarkOpacity / 2);
      triangle(teamYearTriX2, teamYearTriY, teamYearTriX2, teamYearTriY + teamYearTriHeight, teamYearTriX2 + teamYearTriWidth, teamYearTriY + teamYearTriHeight / 2);
    }
  }
  strokeWeight(1);
}

void checkTeamRankingHover() {
  boolean found = false;
  for (int i = 1; i < teamData.length; i++) {
    for (int j = 10 * teamCurrentPage; j < 10 * teamCurrentPage + teamRankNum; j++) {
      if (mouseX > teamData[i][j].xPos - teamRadius && mouseX < teamData[i][j].xPos + teamRadius && mouseY > teamData[i][j].yPos - teamRadius && mouseY < teamData[i][j].yPos + teamRadius) {
        found = true;
        textFont(f, 16);
        fill(teamTextDefaultColor, int(teamLineOpacity * 12));
        text(str(teamData[i][j].year), (windowWidth - teamMarginX * 2) / (teamEndYear - teamStartYear) * (teamData[i][j].year - teamStartYear - 1) + teamMarginX + 15, teamMarginTop - 10);
        text(str(j + 1), 20, teamData[i][j].yPos + 5);
        textFont(f, 14);
        fill(teamButtonHighlight, int(teamLineOpacity * 12));
        text("(" + nf(teamData[i][j].performanceScore, 1, 2) + ")", 505, 85);
        text("(" + nf(teamData[i][j].investmentScore, 1, 2) + ")", 505, 128);
        
        teamRankHighlight = teamData[i][j].teamId;
        teamYearHighlight = i + teamStartYear;
        teamRankHighlightName = teamData[i][j].teamName;
        break;
      }
    }
  }
  if (!found) {
    teamRankHighlight = ""; 
    teamYearHighlight = -1;
    teamRankHighlightName = "";
  }
}

void rerankTeam(float wlWeight, float divWeight, float wcWeight, float lgWeight, float wsWeight, float sWeight) {
  for (int i = 0; i < teamData.length; i++) {
    for (int j = 0; j < teamCount; j++) {
      teamData[i][j].performanceScore = wlWeight * float(teamData[i][j].winNum) / float(teamData[i][j].lossNum) + 
                                        divWeight * (teamData[i][j].divisionWin ? 1 : 0) +
                                        wcWeight * (teamData[i][j].wildCardWin ? 1 : 0) +
                                        lgWeight * (teamData[i][j].leagueWin ? 1 : 0) +
                                        wsWeight * (teamData[i][j].worldSeriesWin ? 1 : 0);
      teamData[i][j].investmentScore = avgTotalSalary[i] / float(teamData[i][j].totalSalary) * sWeight + teamData[i][j].performanceScore;
    }
    sortTeams(teamData[i]);
  }
  
  for (int i = 0; i < teamData.length; i++) {
    for (int j = 0; j < teamCount; j++) {
      teamData[i][j].xPos = (windowWidth - teamMarginX * 2) / (teamEndYear - teamStartYear + 1) * i + 33 + teamMarginX;
      teamData[i][j].yPos = (windowHeight - teamMarginBottom - teamMarginTop) / teamRankNum * (j % teamRankNum) + teamMarginTop + 30;
    }
  }
}

void sortTeams(TeamData[] tds) {
  int maxIndex;
  float max;
  TeamData temp = null;
  for (int i = 0; i < tds.length - 1; i++) {
    max = tds[i].investmentScore;
    maxIndex = i;
    for (int j = i + 1; j < tds.length; j++) {
      if (tds[j].investmentScore > max) {
        max = tds[j].investmentScore;
        maxIndex = j;
      }
    }
    if (maxIndex != i) {
      temp = tds[i];
      tds[i] = tds[maxIndex];
      tds[maxIndex] = temp;
    }
  }
}

void teamSelectTransitioning() {
  if (teamMode == 0 && teamTargetMode == 1) {
    if (teamLineOpacity > 0) {
      teamLineOpacity -= (teamLineOpacity - -2) * changeSpeed;
      setWeightsOpacity(teamLineOpacity * 12);
    }
    else {
      teamMarkOpacity = 0;
      teamMode = teamTargetMode;
      teamViewByMode = 0;
      teamViewByButtonLabel = teamViewByLabels[teamViewByMode];
      displayWeightsTextfield(false);
    }
  }
  else if (teamMode == 1 && teamTargetMode == 1) {
    if (teamMarkOpacity < 255)
      teamMarkOpacity += (256 - teamMarkOpacity) * changeSpeed / 2;
    else
      teamSelectTransition = false;
  }
  else if (teamMode == 1 && teamTargetMode == 0) {
    if (teamMarkOpacity > 0)
      teamMarkOpacity -= (teamMarkOpacity - -1) * changeSpeed * 2;
    else {
      teamLineOpacity = 0;
      teamSelectedTeam.clear();
      teamRankHighlight = "";
      teamSelectYear = -1;
      teamYearHighlight = -1;
      teamMode = teamTargetMode; 
      displayWeightsTextfield(true);
    }
  }
  else if (teamMode == 0 && teamTargetMode == 0) {
    if (teamLineOpacity < teamLineMaxOpacity - 2) {
      teamLineOpacity += (teamLineMaxOpacity - teamLineOpacity) * changeSpeed;
      setWeightsOpacity(teamLineOpacity * 12);
    }
    else
      teamSelectTransition = false;
  }
}

void mousePressed() {
  if (!modeDropList.isMouseOver()) {    
    modeDropList.close();
  }
  if (currentMode == 0) {
    if (mouseX > teamWeightButtonX && mouseX < teamWeightButtonX + 80 && mouseY > teamWeightButtonY && mouseY < teamWeightButtonY + 30) {
      rerankTeam(float(weights[0].getText()), float(weights[1].getText()), float(weights[2].getText()), float(weights[3].getText()), float(weights[4].getText()), float(weights[5].getText()));
    }
    if (mouseX > teamWeightButtonX + 100 && mouseX < teamWeightButtonX + 180 && mouseY > teamWeightButtonY && mouseY < teamWeightButtonY + 30) {
      weights[0].setText("1");
      weights[1].setText("1");
      weights[2].setText("0.8");
      weights[3].setText("1.5");
      weights[4].setText("1");
      weights[5].setText("1.5");
    }
    if (teamCurrentPage != 0 && mouseX > teamTriX - 2 && mouseX < teamTriX + teamTriWidth + 2 && mouseY > teamTriY1 - teamTriHeight - 2 && mouseY < teamTriY1 + 2) {
      teamCurrentPage--;
    }

    if (teamCurrentPage != 2 && mouseX > teamTriX - 2 && mouseX < teamTriX + teamTriWidth + 2 && mouseY > teamTriY2 - 2 && mouseY < teamTriY2 + teamTriHeight + 2) {
      teamCurrentPage++;
    }
    if (teamMode == 0 && teamRankHighlight.length() > 0 && !teamSelectTransition) {
      teamSelectedTeam.clear();
      for (int i = 0; i < teamData.length; i++) {
        for (int j = 0; j < teamCount; j++) {
          if (teamData[i][j].teamId.equals(teamRankHighlight)){
            teamSelectedTeam.add(teamData[i][j]);
            if (teamData[i][j].year == teamYearHighlight)
              teamYearIndex = teamSelectedTeam.size() - 1;
            break;
          }
        }
      }
      for (int i = 0; i < teamID.length; i++) {
        if (teamID[i].equals(teamRankHighlight)) {
          teamColorId = i;
          break;
        }
      }
      teamSelectYear = teamYearHighlight;
      teamSelectTransition = true;
      teamTargetMode = 1;
    }
    else if (teamMode == 1) {
      if (mouseX > teamBackX && mouseX < teamBackX + 80 && mouseY > teamBackY && mouseY < teamBackY + 30) {
        teamSelectTransition = true;
        teamTargetMode = 0;
      }
      if (mouseX > teamBackX + 130 && mouseX < teamBackX + 300 && mouseY > teamBackY && mouseY < teamBackY + 30) {
        teamViewByMode = teamViewByMode == 0 ? 1 : 0;
        teamViewByButtonLabel = teamViewByLabels[teamViewByMode];
      }
      if (teamYearIndex != 1 && mouseX > teamYearTriX1 - 2 && mouseX < teamYearTriX1 + teamYearTriWidth + 2 && mouseY > teamYearTriY - 2 && mouseY < teamYearTriY + teamYearTriHeight + 2) {
        teamYearIndex--;
        teamSelectYear = teamSelectedTeam.get(teamYearIndex).year;
      }
      if (teamYearIndex != teamSelectedTeam.size() - 1 && mouseX > teamYearTriX2 - 2 && mouseX < teamYearTriX2 + teamYearTriWidth + 2 && mouseY > teamYearTriY - 2 && mouseY < teamYearTriY + teamYearTriHeight + 2) {
        teamYearIndex++;
        teamSelectYear = teamSelectedTeam.get(teamYearIndex).year;
      }
    }
  }
}
