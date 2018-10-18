/**
Author: Oluwaseun Shadare
*/

String fileName = "Batting.csv";
String [] data;
int [] doubles = new int [104324];
int [] triples = new int [104324];
int [] homeRuns = new int [104324];
int [] hitByPitch = new int [104324];
int [] stolenBases = new int [104324];
int [] atBat = new int [104324];
int [] games = new int [104324];
int [] ranks = new int[104324];
//int [] singles = new int [104324];
float [] playerPerformance = new float [104324];

int margin, chartHeight;
float xSpace;
PVector[] positionPlayerPerformance = new PVector[104234];
PVector[] positionPlayerRanking = new PVector[104234];
float overallPlayerPerformanceMin, overallPlayerPerformanceMax, midOverallPlayerPerformance, firstQuartPlayerPerformance, lastQuartPlayerPerformance;
int overallMinPlayerRanking, overallMaxPlayerRanking, midOverallPlayerRanking, firstQuartPlayerRanking, lastQuartPlayerRanking;

void setup(){
  size(1700, 800);
  processData();
}

void draw(){
  background(20);
  drawGUIForPlayerPerformance();
  fill(200);
  for (int i=0; i<positionPlayerPerformance.length; ++i){
     point(positionPlayerPerformance[i].x, positionPlayerPerformance[i].y);
   }
}


void processData(){
  data = loadStrings(fileName);

  margin = 70;
  chartHeight = (height - margin) - margin;
  xSpace = (width - margin - margin) / (atBat.length - 1);

  for (int i=1; i < data.length; ++i){
    String [] row = split(data[i], ",");
    doubles[i-1] = int(row[9]);
    triples[i-1] = int(row[10]);
    homeRuns[i-1] = int(row[11]);
    hitByPitch[i-1] = int(row[8]);
    atBat[i-1] = int(row[6]);
    stolenBases[i-1] = int(row[13]);
    games[i-1] = int(row[5]);
    ranks[i-1] = int(row[22]);
  }
  //arithmetic exception when dividing by 0
  for (int j = 0; j < playerPerformance.length; ++j){
    playerPerformance[j] = ((2 * doubles[j]) + (5/2 * triples[j]) + (7/2 * homeRuns[j]) + (4/5 * hitByPitch[j]) + (1/2 * stolenBases[j]))/ (games[j] + homeRuns[j]);
  }
  
  getMinMaxForPlayerPerformance(); 
  mapPlayerPerformanceToPositions();
  
  getMinMaxForPlayerPerformance();
  mapPlayerRankingToPositions();
}


void drawGUIForPlayerPerformance(){
  
  for (int i=0; i<positionPlayerPerformance.length; ++i){
    if (i > 0){
      stroke(200);
       line(positionPlayerPerformance[i].x, positionPlayerPerformance[i].y, positionPlayerPerformance[i-1].x, positionPlayerPerformance[i-1].y);
  }
  }
   
  //display text on y-axis
  text(overallPlayerPerformanceMax, 5, margin);
  text(overallPlayerPerformanceMin, 5, height - margin);
  text(midOverallPlayerPerformance, 5, height/2);
  text(lastQuartPlayerPerformance, 5, height/4 + margin/2);
  text(firstQuartPlayerPerformance, 5, height/2 + 150);
  
  
  //display text on x-axis
  text(overallMinPlayerRanking, positionPlayerRanking[0].x - 15, height - margin  + 20);
  text(overallMaxPlayerRanking, positionPlayerRanking[104233].x - 15, height - margin  + 20);
  text(midOverallPlayerRanking, positionPlayerRanking[52117].x - 15, height - margin  + 20);
  text(firstQuartPlayerRanking, positionPlayerRanking[26058].x - 15, height - margin  + 20);
  text(lastQuartPlayerRanking, positionPlayerRanking[78175].x - 15, height - margin  + 20);
  text("A graph showing the player's performance(y-axis) and their rankings (x-axis)", positionPlayerRanking[26058].x - 15, height - margin + 50);
 
}




void getMinMaxForPlayerPerformance(){
  
  float minPlayerPerformance = playerPerformance[0];
  float maxPlayerPerformance = playerPerformance[0];

  //get the overall minimum and maximum lstat value
  for (int i=1; i< playerPerformance.length; i++){
    minPlayerPerformance = Math.min(minPlayerPerformance, playerPerformance[i]);
    maxPlayerPerformance = Math.max(maxPlayerPerformance, playerPerformance[i]);
  }
 
  overallPlayerPerformanceMin = (float)minPlayerPerformance;
  overallPlayerPerformanceMax = (float)maxPlayerPerformance;
  midOverallPlayerPerformance = (overallPlayerPerformanceMin + overallPlayerPerformanceMax)/2;
  firstQuartPlayerPerformance = (overallPlayerPerformanceMin + midOverallPlayerPerformance) / 2;
  lastQuartPlayerPerformance = (overallPlayerPerformanceMax + midOverallPlayerPerformance) / 2; 

}


void getMinMaxForPlayerRanking(){
  
  int overallMinPlayerRanking = min(ranks);
  int overallMaxPlayerRanking = max(ranks);

  
  midOverallPlayerRanking = (overallMinPlayerRanking + overallMaxPlayerRanking)/2;
  firstQuartPlayerRanking = (overallMinPlayerRanking + midOverallPlayerRanking) / 2;
  lastQuartPlayerRanking = (overallMaxPlayerRanking + midOverallPlayerRanking) / 2; 

}

void mapPlayerPerformanceToPositions(){
    for (int i=0; i<positionPlayerPerformance.length; ++i){
    float thePerformance = map((float)playerPerformance[i], (float)overallPlayerPerformanceMin, (float)overallPlayerPerformanceMax, 0, chartHeight);
    float yPos = height - margin - thePerformance;
    float xPos = margin + (xSpace * i);
    positionPlayerPerformance[i] = new PVector(xPos, yPos);
  }
}
void mapPlayerRankingToPositions(){
    for (int i=0; i<positionPlayerRanking.length; ++i){
    float theRanking = map(ranks[i], overallMinPlayerRanking, overallMaxPlayerRanking, 0, chartHeight);
    float yPos = height - margin - theRanking;
    float xPos = margin + (xSpace * i);
    positionPlayerRanking[i] = new PVector(xPos, yPos);
  }
}
