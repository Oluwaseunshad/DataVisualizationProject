import controlP5.*;
import java.util.*;

ControlP5 cp5;

int currentMode = 0;

// team table and data
int teamStartYear = 2000;
int teamEndYear = 2016;
int teamColumnCount = 18;
int teamRankNum = 10;
int currentTeamYear = 2016;
int currentTeamClickIndex = -1;
int teamInfoXPos = 15;
int teamInfoYPos = 160;
int teamRuleXPos = 193;
int teamRuleYPos = 86;
int teamInfoRowSize = 20;
float teamHighScore;
float teamLowScore;
Table teamTable;
String teamYMax;
String teamYMin;
String teamTableName = "TeamFinal.csv";
String[] teamAttributes = {"year", "teamid", "teamname", "salary", "score", 
                       "finalscore", "lgid", "franchname", "divid", "rank",
                       "w", "l", "divwin", "wcwin", "lgwin", "wswin", "r", "hr"};
TeamData[][] teamData = new TeamData[teamEndYear - teamStartYear + 1][teamRankNum];
DropdownList teamYearDropList;

int startYear = 1995;
int endYear = 2018;
int dropdownPosX = 30;
int dropdownPosY = 80;
String[] roles = {"Batter", "Pitcher"};
String currentYear = str(endYear);
String currentRole = roles[0];


DropdownList mode1YearDropList;
DropdownList mode1RoleDropList;
CheckBox mode1StatusCheckBox;
int mode1StatusNum = 4;
float[] previousCheckBoxStates;

float plotWidth = 700.0;
float plotHeight = 400.0;
float plotOriginX = 250;
float plotOriginY = 130;
float plotMarginX = 50;
float plotMarginY = 35;
float dotSpeed = 0.06;
PFont f;
String yLabel = "Investment Score";
String yMax;
String yMin;

float modeButtonPosX = 10;
float modeButtonPosY = 560;
float modeButtonWidth = 130;
float modeButtonHeight = 30;
float transitionOpacity = 0;
boolean fadingOut = false;
boolean modeTransitioning = false;
String[] modeText = {"Team", "Player"};

int colorDPosX = (int)plotOriginX + 20;
int colorDPosY = (int)plotOriginY + 15;
int colorDWidth = 80;
int colorDHeight = 100;

int dataNum = 25;
int xAxisStep = 5;
float maxScore;
float minScore;
float xAxisMarkLength = 10;
float dataRadius = 7;
int[][] dataColors = {{255, 216, 0}, {88, 112, 88}, {88, 116, 152}, {232, 104, 80}};
float[] highScores = new float[4];
float[] lowScores = new float[4];

PlotData[][] mode1Data = new PlotData[4][dataNum];

class TeamData {
  int year;
  int totalSalary;
  int yearRank;
  int winNum;
  int lossNum;
  int runScore;
  int homeRun;
  float xPos;
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
  
  TeamData(float xPos, String[] teamInfo) {
    this.xPos = xPos;
    this.year = int(teamInfo[0]);
    this.teamId = teamInfo[1];
    this.teamName = teamInfo[2];
    this.totalSalary = int(teamInfo[3]);
    this.performanceScore = float(teamInfo[4]);
    this.investmentScore = float(teamInfo[5]);
    this.leagueName = teamInfo[6].equals("NL") ? "National League" : "American League";
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
  }
}

class PlotData {
  float xPos;
  float score;
  String playerName;
  String teamName;
  int age;
  int seasonRanking;
  float salary;
  String[] achievements;
  PlotData(float xPos, float score) {
    this.xPos = xPos;
    this.score = score;
    this.playerName = "Brandon Lee";
    this.teamName = "New York Yankees";
    this.age = 12;
    this.salary = 5000000;
    this.seasonRanking = 3;
    this.achievements = new String[1];
    achievements[0] = "Champion";
  }
}
 
void setup() {
  size(1000, 600);
  background(255);
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  f = createFont("Arial", 16, true);
  
  // import team data
  teamTable = loadTable(teamTableName, "header");
  for (int i = 0; i < teamTable.getRowCount(); i++) {
    TableRow row = teamTable.getRow(i);
    String[] teamInfo = new String[teamColumnCount];
    for (int j = 0; j < teamColumnCount; j++)
      teamInfo[j] = row.getString(teamAttributes[j]);
    teamData[i / teamRankNum][i % teamRankNum] = new TeamData(plotOriginX + plotMarginX + (plotWidth - 2 * plotMarginX) / (teamRankNum - 1) * (teamRankNum - i % teamRankNum - 1), teamInfo);
  }
  
  // initialize plotData with fake data
  for (int i = 0; i < mode1Data.length; i++) {
    for (int j = 0; j < dataNum; j++) {
      mode1Data[i][j] = new PlotData(plotOriginX + plotMarginX + (plotWidth - 2 * plotMarginX) / (dataNum - 1) * j, j * (i + 0.5));
    }
  }

  // initialize dropLists
  teamYearDropList = cp5.addDropdownList("TEAM YEAR").setPosition(dropdownPosX, dropdownPosY);
  mode1YearDropList = cp5.addDropdownList("YEAR").setPosition(dropdownPosX, dropdownPosY);
  mode1RoleDropList = cp5.addDropdownList("ROLE").setPosition(dropdownPosX + 185, dropdownPosY);
  for (int i = teamStartYear; i <= teamEndYear; i++) {
    teamYearDropList.addItem(str(i), i - startYear);
  }
  for (int i = startYear; i <= endYear; i++) {
    mode1YearDropList.addItem(str(i), i - startYear);
  }
  for (int i = 0; i < roles.length; i++) {
    mode1RoleDropList.addItem(roles[i], i); 
  }
  customizeDropdownList(teamYearDropList);
  customizeDropdownList(mode1YearDropList);
  customizeDropdownList(mode1RoleDropList);  
  teamYearDropList.close();
  mode1YearDropList.close();
  mode1RoleDropList.close();
  
  // initialize checkbox
  mode1StatusCheckBox = cp5.addCheckBox("mode1StatusCheckBox")
                .setPosition(400, 83)
                .setSize(15, 15)
                .setItemsPerRow(4)
                .setSpacingColumn(30)
                .setSpacingRow(20)
                .setColorValue(255)
                .setColorForeground(color(100))
                .setColorBackground(color(200))
                .setColorActive(color(0))
                .setColorLabel(0)
                .addItem("FA0", 0)
                .addItem("FA1", 1)
                .addItem("FA2", 2)
                .addItem("Other", 3)
                .setNoneSelectedAllowed(false)
                ;
  mode1StatusCheckBox.activateAll();
  
  if (currentMode == 0) {
    mode1YearDropList.hide();
    mode1RoleDropList.hide();
    mode1StatusCheckBox.hide();
  }
  else {
    teamYearDropList.hide();
  }
  
  definePlotScale();
}
 
void draw() {
  background(255);

  //cp5.draw();
  drawProgramHeader();  
  drawPlotFrame();
  drawModeTitle();
  
  if (currentMode == 0) {
    drawTeamData();
    drawTeamRule();
    drawTeamInfo();
    checkTeamHoverData();
  }  
  
  if (currentMode == 1) {  
    drawMode1Data();   
    drawMode1ColorDescriptionBox();
    checkMode1HoverData();
  }
  
  cp5.draw();
  modeTransitioning();
  drawModeButton();
}

void modeTransitioning() {
  if (modeTransitioning) {
    fill(0, transitionOpacity);
    rect(-1, -1, 1001, 601);
    if (fadingOut)
      transitionOpacity += 7;
    else
      transitionOpacity -= 7;
    if (fadingOut && transitionOpacity >= 255) {
      currentMode = currentMode == 0 ? 1 : 0;
      definePlotScale();
      
      fadingOut = !fadingOut;
      if (currentMode == 1) {
        mode1YearDropList.show();
        mode1RoleDropList.show();
        mode1StatusCheckBox.show();
        
        teamYearDropList.hide();
      }
      else {
        mode1YearDropList.hide();
        mode1RoleDropList.hide();
        mode1StatusCheckBox.hide();
        
        teamYearDropList.show();
      }    
    }
    if (!fadingOut && transitionOpacity <= 0) {
      modeTransitioning = false;
      fadingOut = true;
      transitionOpacity = 0;
    }
  }
}

void drawProgramHeader() {
  fill(0);
  textFont(f, 15);
  textAlign(LEFT);
  text("CS6260 Term Project", 30, 30);
  text("Che Shian Hung, Dewan Chaulagain, Oluwaseun Sesan Shadare, Shadi Moradi", 30, 55);
}

void drawPlotFrame() {
  int xNum = currentMode == 0 ? 10 : 25;
  int xStep = currentMode == 0 ? 1 : 5;
  fill(255);
  rect(plotOriginX, plotOriginY, plotWidth, plotHeight);

  fill(0);
  textFont(f, 14);
  textAlign(CENTER);
  for (int i = xNum / xStep - 1; i >= 0; i--) {
    float x = plotOriginX + plotMarginX + (plotWidth - 2 * plotMarginX) / (xNum - 1) * i * xStep;
    float y = plotOriginY + plotHeight;
    line(x - 1, y + xAxisMarkLength / 2, x - 1, y - xAxisMarkLength / 2);
    text(str(xNum - i * xStep), x, y + 20);
  }
  if (currentMode == 1) {
    float x = plotOriginX + plotMarginX + (plotWidth - 2 * plotMarginX);
    float y = plotOriginY + plotHeight;
    line(x - 1, y + xAxisMarkLength / 2, x - 1, y - xAxisMarkLength / 2);
    text(str(1), x, y + 20);
  }

  text("Rank 1 - " + str(xNum), plotOriginX + plotWidth / 2, plotOriginY + plotHeight + 50);
  pushMatrix();
  translate(plotOriginX - 30, plotOriginY + plotHeight / 2);
  rotate(-HALF_PI);
  text(yLabel, 0, 0);
  popMatrix();
}

void drawModeButton() {
  if (modeTransitioning || (mouseX > modeButtonPosX && mouseX < modeButtonPosX + modeButtonWidth &&
      mouseY > modeButtonPosY && mouseY < modeButtonPosY + modeButtonHeight)) {
    fill(0);
    rect(modeButtonPosX, modeButtonPosY, modeButtonWidth, modeButtonHeight);
    fill(255);
    textFont(f, 17);
    textAlign(CENTER);
    text("Change Mode", modeButtonPosX + modeButtonWidth / 2, modeButtonPosY + modeButtonHeight / 2 + 6);
  }
  else {   
    fill(255);
    rect(modeButtonPosX, modeButtonPosY, modeButtonWidth, modeButtonHeight);
    fill(0);
    textFont(f, 17);
    textAlign(CENTER);
    text(modeText[currentMode] + " Mode", modeButtonPosX + modeButtonWidth / 2, modeButtonPosY + modeButtonHeight / 2 + 6);
  }
}

void drawModeTitle() {
  fill(0);
  textAlign(LEFT);
  textFont(f, 42);
  text("Let's help " + ((currentMode == 0) ? "Dr. Lee" : "Brandon") + "!", 600, 55);
  textFont(f, 20);
  text("to find the cheapest best " + modeText[currentMode].toLowerCase() + " :)", 650, 95);
}

void drawTeamData() {
  fill(0);
  textFont(f, 35);
  textAlign(LEFT);
  text(currentTeamYear, 270, 180);
  text("Team Investment Ranking", 360, 180);
  textFont(f, 14);
  textAlign(CENTER);
  text(teamYMax, plotOriginX - 25, plotOriginY + plotMarginY + 6);
  text(teamYMin, plotOriginX - 25, plotOriginY + plotHeight - plotMarginY + 6);
  strokeWeight(0.25);
  
  float preX = 0;
  float preY = 0;
  for (TeamData td : teamData[currentTeamYear - teamStartYear]) {
    noStroke();
    fill(dataColors[3][0], dataColors[3][1], dataColors[3][2]);
    float y = map(td.investmentScore, teamLowScore, teamHighScore, 0, plotHeight - plotMarginY * 2);
    ellipse(td.xPos, plotOriginY + plotHeight - plotMarginY - y, dataRadius, dataRadius); 
    stroke(0);
    if (preX != 0) {
      stroke(dataColors[3][0], dataColors[3][1], dataColors[3][2]);
      line(preX, preY, td.xPos, plotOriginY + plotHeight - plotMarginY - y);
    }
    preX = td.xPos;
    preY = plotOriginY + plotHeight - plotMarginY - y;
  }
  
  stroke(0);
  strokeWeight(1);
}

void drawTeamRule() {
  fill(128);
  textFont(f, 11);
  textAlign(LEFT);
  text("Performance = Win / Loss + 1 * (DivWin) + 0.8 * (WCWin) + 1.5 * (LgWin) + 2 * (WSWin)", teamRuleXPos, teamRuleYPos);
  text("Investment = MAX(TotalSalary) / TotalSalary * Performance", teamRuleXPos, teamRuleYPos + teamInfoRowSize);
}

void drawTeamInfo() {
  if (currentTeamClickIndex == -1)
    return;

  TeamData td = teamData[currentTeamYear - teamStartYear][currentTeamClickIndex];
  fill(dataColors[1][0], dataColors[1][1], dataColors[1][2]);
  textFont(f, 12);
  textAlign(LEFT);
  text("Team Name:  " + td.teamName, teamInfoXPos, teamInfoYPos + 0 * teamInfoRowSize);
  text("Team ID:  " + td.teamId, teamInfoXPos, teamInfoYPos + 1 * teamInfoRowSize);
  text("Year:  " + str(td.year), teamInfoXPos, teamInfoYPos + 2 * teamInfoRowSize);
  text("League:  " + (td.leagueName.equals("NL") ? "National League" : "American League"), teamInfoXPos, teamInfoYPos + 3 * teamInfoRowSize);
  text("Franchise:  " + td.franchName , teamInfoXPos, teamInfoYPos + 4 * teamInfoRowSize);
  text("Division:  " + td.division, teamInfoXPos, teamInfoYPos + 5 * teamInfoRowSize);
  text("Year Rank:  " + str(td.yearRank), teamInfoXPos, teamInfoYPos + 6 * teamInfoRowSize);
  text("Win:  " + str(td.winNum), teamInfoXPos, teamInfoYPos + 7 * teamInfoRowSize);
  text("Loss:  " + str(td.lossNum), teamInfoXPos, teamInfoYPos + 8 * teamInfoRowSize);
  text("Runs Scored:  " + str(td.runScore), teamInfoXPos, teamInfoYPos + 9 * teamInfoRowSize);
  text("Homerun:  " + str(td.homeRun), teamInfoXPos, teamInfoYPos + 10 * teamInfoRowSize);
  text("Achievement:  ", teamInfoXPos, teamInfoYPos + 11 * teamInfoRowSize);
  List<String> achievement = new ArrayList<String>();
  if (td.divisionWin) achievement.add("Division Winner");
  if (td.wildCardWin) achievement.add("Wild Card Winner");
  if (td.leagueWin) achievement.add("League Winner");
  if (td.worldSeriesWin) achievement.add("World Series Winner!!");
  if (achievement.size() == 0) achievement.add("None");
  for (int i = 0; i < achievement.size(); i++) {
    text(achievement.get(i), teamInfoXPos + 80, teamInfoYPos + (11 + i) * teamInfoRowSize);
  }
  
  fill(dataColors[2][0], dataColors[2][1], dataColors[2][2]);
  textFont(f, 13);
  text("Total Salary:", teamInfoXPos, teamInfoYPos + 15 * teamInfoRowSize);
  text("Performance Score:", teamInfoXPos, teamInfoYPos + 16 * teamInfoRowSize);
  text("Investment Score:", teamInfoXPos, teamInfoYPos + 17 * teamInfoRowSize);
  String[] scores = new String[3];
  scores[0] = str(td.totalSalary);
  for (int i = 3; i < str(td.totalSalary).length(); i += 3) {
    scores[0] = scores[0].substring(0, str(td.totalSalary).length() - i) + "," + scores[0].substring(str(td.totalSalary).length() - i);
  }
  scores[1] = nf(td.performanceScore, 1, 2);
  scores[2] = nf(td.investmentScore, 1, 2);
  textAlign(RIGHT);
  for (int i = 0; i < scores.length; i++)
    text(scores[i], teamInfoXPos + 180, teamInfoYPos + (15 + i) * teamInfoRowSize);
  textAlign(LEFT);
}

void drawMode1Data() {
  fill(0);
  textFont(f, 35);
  textAlign(LEFT);
  text(currentYear + " " + currentRole, 370, 180);
  textFont(f, 14);
  textAlign(CENTER);
  text(yMax, plotOriginX - 25, plotOriginY + plotMarginY + 6);
  text(yMin, plotOriginX - 25, plotOriginY + plotHeight - plotMarginY + 6);
  strokeWeight(0.25);
  
  for (int i = 0; i < mode1StatusNum; i++)
    if (mode1StatusCheckBox.getArrayValue()[i] == 1.0) drawPlotData(mode1Data[i], dataColors[i]);
    
  stroke(0);
  strokeWeight(1);
}

void drawMode1ColorDescriptionBox() {
  fill(255);
  rect(colorDPosX, colorDPosY, colorDWidth, colorDHeight);
  fill(0);
  textAlign(LEFT);
  text("FA0", colorDPosX + colorDWidth / 2, colorDPosY + colorDHeight / 5 + 5);
  text("FA1", colorDPosX + colorDWidth / 2, colorDPosY + colorDHeight / 5 * 2 + 5);
  text("FA2", colorDPosX + colorDWidth / 2, colorDPosY + colorDHeight / 5 * 3 + 5);
  text("Other", colorDPosX + colorDWidth / 2, colorDPosY + colorDHeight / 5 * 4 + 5);
  noStroke();
  fill(255, 216, 0);
  rect(colorDPosX + 13, colorDPosY + colorDHeight / 5 - 5, 20, 10);
  fill(88, 112, 88);
  rect(colorDPosX + 13, colorDPosY + colorDHeight / 5 * 2 - 5, 20, 10);
  fill(88, 116, 152);
  rect(colorDPosX + 13, colorDPosY + colorDHeight / 5 * 3 - 5, 20, 10);
  fill(232, 104, 80);
  rect(colorDPosX + 13, colorDPosY + colorDHeight / 5 * 4 - 5, 20, 10);
  stroke(0);
}

void customizeDropdownList(DropdownList ddl) {
  ddl.setSize(150, 150);
  ddl.setBackgroundColor(0);
  ddl.setItemHeight(20);
  ddl.setBarHeight(20);
}

// controlEvent monitors clicks on the gui
void controlEvent(ControlEvent theEvent) {
  // checkbox event
  if (theEvent.isFrom(mode1StatusCheckBox)) {
    // make sure at least one box is checked
    if (checkBoxAllFalse(mode1StatusCheckBox.getArrayValue())) {
      for (int i = 0; i < previousCheckBoxStates.length; i++) {
        if (previousCheckBoxStates[i] == 1.0)
          mode1StatusCheckBox.activate(i);
      }
      return;
    }
    previousCheckBoxStates = mode1StatusCheckBox.getArrayValue();
  }
  // dropdown list event
  else {
    switch (theEvent.getController().getName()) {
      case "TEAM YEAR":
        currentTeamYear = int(theEvent.getController().getValue()) + teamStartYear;
        currentTeamClickIndex = -1;
        break;
      case "YEAR":
        currentYear = str(int(theEvent.getController().getValue()) + startYear);
        break;
      case "ROLE":
        currentRole = roles[int(theEvent.getController().getValue())];
        break;
      default:
        break;
    }
  }
  definePlotScale();
}

boolean checkBoxAllFalse(float[] ary) {
  for (float i : ary) {
    if (i == 1.0) return false; 
  }
  return true;
}

void setHighLowScores() {
  if (currentMode == 0) {
    teamHighScore = teamData[currentTeamYear - teamStartYear][0].investmentScore;
    teamLowScore = teamHighScore;
    for (int i = 1; i < teamRankNum; i++) {
      float s = teamData[currentTeamYear - teamStartYear][i].investmentScore;
      if (teamHighScore < s)
        teamHighScore = s;
      if (teamLowScore > s)
        teamLowScore = s;
    }
    teamYMax = nf(teamHighScore, 1, 2);
    teamYMin = nf(teamLowScore, 1, 2);
  }
  else {
    for (int i = 0; i < mode1StatusNum; i++) {
      highScores[i] = mode1Data[i][dataNum - 1].score; 
      lowScores[i] = mode1Data[i][0].score;
    }
  }
}

void definePlotScale() {
  setHighLowScores();
  if (currentMode == 1) {
    maxScore = Float.MIN_VALUE;
    minScore = Float.MAX_VALUE;
    for (int i = 0; i < mode1StatusNum; i++) {
      if (mode1StatusCheckBox.getArrayValue()[i] == 1.0) {
         if (maxScore < highScores[i])
           maxScore = highScores[i];
         if (minScore > lowScores[i])
           minScore = lowScores[i];
      }
    }
    yMax = str(maxScore);
    yMin = str(minScore);
  }
}

void drawPlotData(PlotData[] plotData, int[] c) {
  float preX = 0;
  float preY = 0;
  for (PlotData pd : plotData) {
    noStroke();
    fill(c[0], c[1], c[2]);
    float y = map(pd.score, minScore, maxScore, 0, plotHeight - plotMarginY * 2);
    ellipse(pd.xPos, plotOriginY + plotHeight - plotMarginY - y, dataRadius, dataRadius); 
    stroke(0);
    if (preX == 0) {
      preX = pd.xPos;
      preY = plotOriginY + plotHeight - plotMarginY - y;
    }
    else {
      stroke(c[0], c[1], c[2]);
      line(preX, preY, pd.xPos, plotOriginY + plotHeight - plotMarginY - y);
    }
  }
}

void checkTeamHoverData() {
  for (int i = 0; i < teamRankNum; i++) {
    TeamData td = teamData[currentTeamYear - teamStartYear][i];
    float y = map(td.investmentScore, teamLowScore, teamHighScore, 0, plotHeight - plotMarginY * 2);
    if (mouseX > td.xPos - dataRadius && mouseX < td.xPos + dataRadius && mouseY > plotOriginY + plotHeight - plotMarginY - y - dataRadius && mouseY < plotOriginY + plotHeight - plotMarginY - y + dataRadius) {
      fill(255);
      rect(mouseX - 150, mouseY + 10, 140, 39);
      fill(0);
      textFont(f, 10);
      textAlign(LEFT);
      text(td.teamName, mouseX - 150 + 10, mouseY + 25);
      text("Investment Score: " + nf(td.investmentScore, 1, 2), mouseX - 150 + 10, mouseY + 40);
      break;
    }
  }
}

void checkTeamClickData() {
  for (int i = 0; i < teamRankNum; i++) {
    TeamData td = teamData[currentTeamYear - teamStartYear][i];
    float y = map(td.investmentScore, teamLowScore, teamHighScore, 0, plotHeight - plotMarginY * 2);
    if (mouseX > td.xPos - dataRadius && mouseX < td.xPos + dataRadius && mouseY > plotOriginY + plotHeight - plotMarginY - y - dataRadius && mouseY < plotOriginY + plotHeight - plotMarginY - y + dataRadius) {
      currentTeamClickIndex = i;
      break;
    }
  }
}

void checkMode1HoverData() {
  for (int i = 0; i < mode1StatusNum; i++)
    if (mode1StatusCheckBox.getArrayValue()[i] == 1.0)
      hoverData(mode1Data[i]);
}

void hoverData(PlotData[] plotData) {
  for (PlotData pd : plotData) {
    float y = map(pd.score, minScore, maxScore, 0, plotHeight - plotMarginY * 2);
    if (mouseX > pd.xPos - dataRadius && mouseX < pd.xPos + dataRadius && mouseY > plotOriginY + plotHeight - plotMarginY - y - dataRadius && mouseY < plotOriginY + plotHeight - plotMarginY - y + dataRadius) {
      fill(255);
      int maxLength = max(pd.playerName.length(), pd.teamName.length());
      rect(mouseX - maxLength * 7, mouseY + 10, maxLength * 7 - 10, 40);
      fill(0);
      textFont(f, 10);
      textAlign(LEFT);
      text(pd.playerName, mouseX - maxLength * 7 + 10, mouseY + 25);
      text(pd.teamName, mouseX - maxLength * 7 + 10, mouseY + 40);
      break;
    }
  }
}

void mousePressed() {
  if (!mode1YearDropList.isMouseOver()) {    
    mode1YearDropList.close();
  }
  if (!mode1RoleDropList.isMouseOver()) {    
    mode1RoleDropList.close();
  }
  if (!teamYearDropList.isMouseOver()) {
    teamYearDropList.close();
  }
  if (!modeTransitioning && mouseX > modeButtonPosX && mouseX < modeButtonPosX + modeButtonWidth &&
      mouseY > modeButtonPosY && mouseY < modeButtonPosY + modeButtonHeight) {
    modeTransitioning = true;
    fadingOut = true;
  }
  if (currentMode == 0) {
    checkTeamClickData();
  }
}
