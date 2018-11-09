import controlP5.*;
import java.util.*;

ControlP5 cp5;

int startYear = 1995;
int endYear = 2018;
int dropdownPosX = 30;
int dropdownPosY = 80;
String[] roles = {"Batter", "Pitcher"};
String currentYear = str(endYear);
String currentRole = roles[0];


DropdownList yearDropList;
DropdownList roleDropList;
CheckBox statusCheckBox;
int statusNum = 4;
float[] previousCheckBoxStates;

float plotWidth = 700.0;
float plotHeight = 400.0;
float plotOriginX = 250;
float plotOriginY = 130;
float plotMarginX = 50;
float plotMarginY = 35;
float dotSpeed = 0.06;
PFont f;
String xLabel = "Rank 1 - 25";
String yLabel = "Performance Score";
String yMax;
String yMin;

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
List<PlotData> fa0Data = new ArrayList<PlotData>();
List<PlotData> fa1Data = new ArrayList<PlotData>();
List<PlotData> fa2Data = new ArrayList<PlotData>();
List<PlotData> otherData = new ArrayList<PlotData>();

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
  f = createFont("Arial", 16, true);
  
  // initialize plotData with fake data
  for (int i = 0; i < 25; i++) {
    fa0Data.add(new PlotData(plotOriginX + plotMarginX + (plotWidth - 2 * plotMarginX) / (dataNum - 1) * i, i * 1));
    fa1Data.add(new PlotData(plotOriginX + plotMarginX + (plotWidth - 2 * plotMarginX) / (dataNum - 1) * i, i * 2));
    fa2Data.add(new PlotData(plotOriginX + plotMarginX + (plotWidth - 2 * plotMarginX) / (dataNum - 1) * i, i * 3));
    otherData.add(new PlotData(plotOriginX + plotMarginX + (plotWidth - 2 * plotMarginX) / (dataNum - 1) * i, i * 2.5));
  }

  // initialize dropLists
  yearDropList = cp5.addDropdownList("YEAR").setPosition(dropdownPosX, dropdownPosY);
  roleDropList = cp5.addDropdownList("ROLE").setPosition(dropdownPosX + 185, dropdownPosY);
  for (int i = startYear; i <= endYear; i++) {
    yearDropList.addItem(str(i), i - startYear);
  }
  for (int i = 0; i < roles.length; i++) {
    roleDropList.addItem(roles[i], i); 
  }
  customizeDropdownList(yearDropList);
  customizeDropdownList(roleDropList);  
  yearDropList.close();
  roleDropList.close();
  
  // initialize checkbox
  statusCheckBox = cp5.addCheckBox("statusCheckBox")
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
  statusCheckBox.activateAll();
  
  definePlotScale();
}
 
void draw() {
  background(255);
  
  // draw program header
  fill(0);
  textFont(f, 15);
  textAlign(LEFT);
  text("CS6260 Term Project", 30, 30);
  text("Che Shian Hung, Dewan Chaulagain, Oluwaseun Sesan Shadare, Shadi Moradi", 30, 55);
  textFont(f, 42);
  text("Let's help Brandon!", 600, 55);
  textFont(f, 20);
  text("to find the cheapest best players :)", 633, 95);
  
  // draw plot frame
  fill(255);
  rect(plotOriginX, plotOriginY, plotWidth, plotHeight);
  for (int i = dataNum / xAxisStep; i >= 0; i--) {
    float x = i != 5 ? plotOriginX + plotMarginX + (plotWidth - 2 * plotMarginX) / (dataNum - 1) * i * xAxisStep : 
                       plotOriginX + plotMarginX + (plotWidth - 2 * plotMarginX) / (dataNum - 1) * (i * xAxisStep - 1);
    float y = plotOriginY + plotHeight;
    line(x - 1, y + xAxisMarkLength / 2, x - 1, y - xAxisMarkLength / 2);
    fill(0);
    textFont(f, 14);
    textAlign(CENTER);
    text(i != 5 ? str(25 - i * 5) : str(1), x, y + 20);
  }
  text(xLabel, plotOriginX + plotWidth / 2, plotOriginY + plotHeight + 50);
  pushMatrix();
  translate(plotOriginX - 60, plotOriginY + plotHeight / 2);
  rotate(-HALF_PI);
  text(yLabel, 0, 0);
  popMatrix();
  fill(0);
  textFont(f, 35);
  textAlign(LEFT);
  text(currentYear + " " + currentRole, 370, 180);
  
  // draw data
  fill(0);
  textFont(f, 14);
  textAlign(CENTER);
  text(yMax, plotOriginX - 25, plotOriginY + plotMarginY + 6);
  text(yMin, plotOriginX - 25, plotOriginY + plotHeight - plotMarginY + 6);
  strokeWeight(0.25);
  //fill(255, 216, 0); // lemon
  if (statusCheckBox.getArrayValue()[0] == 1.0) drawList(fa0Data, dataColors[0]);
  //fill(88, 112, 88); // green
  if (statusCheckBox.getArrayValue()[1] == 1.0) drawList(fa1Data, dataColors[1]);
  //fill(88, 116, 152); // blue
  if (statusCheckBox.getArrayValue()[2] == 1.0) drawList(fa2Data, dataColors[2]);
  //fill(232, 104, 80); // red
  if (statusCheckBox.getArrayValue()[3] == 1.0) drawList(otherData, dataColors[3]);
  stroke(0);
  strokeWeight(1);
  
  // draw color description box
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
  
  // if user points to a data
  if (statusCheckBox.getArrayValue()[0] == 1.0) hoverData(fa0Data);
  if (statusCheckBox.getArrayValue()[1] == 1.0) hoverData(fa1Data);
  if (statusCheckBox.getArrayValue()[2] == 1.0) hoverData(fa2Data);
  if (statusCheckBox.getArrayValue()[3] == 1.0) hoverData(otherData);
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
  if (theEvent.isFrom(statusCheckBox)) {
    // make sure at least one box is checked
    if (checkBoxAllFalse(statusCheckBox.getArrayValue())) {
      for (int i = 0; i < previousCheckBoxStates.length; i++) {
        if (previousCheckBoxStates[i] == 1.0)
          statusCheckBox.activate(i);
      }
      return;
    }
    previousCheckBoxStates = statusCheckBox.getArrayValue();
    definePlotScale();
  }
  // dropdown list event
  else {
    switch (theEvent.getController().getName()) {
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
}

boolean checkBoxAllFalse(float[] ary) {
  for (float i : ary) {
    if (i == 1.0) return false; 
  }
  return true;
}

void setHighLowScores() {
  highScores[0] = fa0Data.get(dataNum - 1).score;
  highScores[1] = fa1Data.get(dataNum - 1).score;
  highScores[2] = fa2Data.get(dataNum - 1).score;
  highScores[3] = otherData.get(dataNum - 1).score;
  lowScores[0] = fa0Data.get(0).score;
  lowScores[1] = fa1Data.get(0).score;
  lowScores[2] = fa2Data.get(0).score;
  lowScores[3] = otherData.get(0).score;
}

void definePlotScale() {
  setHighLowScores();
  maxScore = Float.MIN_VALUE;
  minScore = Float.MAX_VALUE;
  for (int i = 0; i < statusNum; i++) {
    if (statusCheckBox.getArrayValue()[i] == 1.0) {
       if (maxScore < highScores[i])
         maxScore = highScores[i];
       if (minScore > lowScores[i])
         minScore = lowScores[i];
    }
  }
  yMax = str(maxScore);
  yMin = str(minScore);
}

void drawList(List<PlotData> l, int [] c) {
  float preX = 0;
  float preY = 0;
  for (PlotData pd : l) {
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

void hoverData(List<PlotData> plotData) {
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
  if (!yearDropList.isMouseOver()) {    
    yearDropList.close();
  }
  if (!roleDropList.isMouseOver()) {    
    roleDropList.close();
  }
}
