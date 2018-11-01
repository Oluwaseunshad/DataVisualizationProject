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
String xLabel = "Rank 1 - 25";
String yLabel = "Performance Score";
String yMax;
String yMin;

int currentMode = 1;
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
  
  // initialize plotData with fake data
  for (int i = 0; i < mode1Data.length; i++) {
    for (int j = 0; j < dataNum; j++) {
      mode1Data[i][j] = new PlotData(plotOriginX + plotMarginX + (plotWidth - 2 * plotMarginX) / (dataNum - 1) * j, j * (i + 0.5));
    }
  }

  // initialize dropLists
  mode1YearDropList = cp5.addDropdownList("YEAR").setPosition(dropdownPosX, dropdownPosY);
  mode1RoleDropList = cp5.addDropdownList("ROLE").setPosition(dropdownPosX + 185, dropdownPosY);
  for (int i = startYear; i <= endYear; i++) {
    mode1YearDropList.addItem(str(i), i - startYear);
  }
  for (int i = 0; i < roles.length; i++) {
    mode1RoleDropList.addItem(roles[i], i); 
  }
  customizeDropdownList(mode1YearDropList);
  customizeDropdownList(mode1RoleDropList);  
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
  
  definePlotScale();
}
 
void draw() {
  background(255);

  cp5.draw();
  drawProgramHeader();  
  drawPlotFrame();
  drawModeTitle();
  
  if (currentMode == 0) {
    // drawMode0Data();
  }  
  
  if (currentMode == 1) {  
    drawMode1Data();   
    drawMode1ColorDescriptionBox();
    checkMode1HoverData();
  }
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
      fadingOut = !fadingOut;
      if (currentMode == 1) {
        mode1RoleDropList.show();
        mode1StatusCheckBox.show();
      }
      else {
        mode1RoleDropList.hide();
        mode1StatusCheckBox.hide();
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
  text("to find the cheapest best " + modeText[currentMode].toLowerCase() + " :)", 633, 95);
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
  for (int i = 0; i < mode1StatusNum; i++) {
    highScores[i] = mode1Data[i][dataNum - 1].score; 
    lowScores[i] = mode1Data[i][0].score;
  }
}

void definePlotScale() {
  setHighLowScores();
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
  if (!modeTransitioning && mouseX > modeButtonPosX && mouseX < modeButtonPosX + modeButtonWidth &&
      mouseY > modeButtonPosY && mouseY < modeButtonPosY + modeButtonHeight) {
    modeTransitioning = true;
    fadingOut = true;
  }
}
