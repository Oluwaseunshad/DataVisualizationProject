import controlP5.*;
import java.util.*;


ControlP5 cp5,cp6;
PShape bot;
PShape botarr[];
PGraphics pg;
PFont f;
PImage img;
int xsize=1200,ysize=680;
int currentMode = -1;           //intitally for the welcome screen
int targetMode = 0;
int dropdownPosX = 30;
int dropdownPosY = 80;
float transitionOpacity = 0;
boolean fadingOut = false;
boolean modeTransitioning = false;
List dropdownItemList = Arrays.asList("Team Ranking", "Player Ranking", "Other 1", "Other 2", "Other 3");
List dropdownYearList = Arrays.asList("2000","2001","2002","2003","2004","2000","2001","2002","2003","2004","2000","2001","2002","2003","2004");
 String[][] teams = {{"Anaheim Angels(ANA)","Arizona Diamondbacks(ARI)","Atlanta Braves(ATL)","Baltimore Orioles(BAL)","Boston Red Sox(BOS)","Chicago White Sox(CHA)"},
                    {"Chicago Cubs(CHN)","Cincinnati Reds(CIN)","Cleveland Indians (CLE)","Colorado Rockies(COL)","Detroit Tigers(DET)","Florida Marlins(FLO)"},
                    {"Houston Astros(HOU)","Kansas City Royals(KCA)","Los Angeles Dodgers(LAN)","Milwaukee Brewers(MIL)","Minnesota Twins(MIN)","Montral Expos(MON)"},
                    {"New York Yankees(NYA)","New York Mets(NYN)","Oakland Athletics(OAK)","Philadelphia Phillies(PHI)","Pittsburgh Pirates(PIT)","San Diego Padres(SDN)"},
                    {"Seattle Mariners(SEA)","San Francisco Giants(SFN)","St. Louis Cardinals(SLN)","Tampa Bay Devil Rays(TBA)","Texas Rangers(TEX)","Toronto Blue Jays(TOR)"}}  ;
  
ScrollableList modeDropList;
Button[] button = new Button[17];
Button goBackToTeams;
Button[] playersButton = new Button[10];
ControlFont font;
boolean endWelcomeScreen=false;
boolean dropDownVisible = true;
boolean teamLogoClicked = false;
String clickedTeamID="";
boolean drawYearListOnce = true;
int yearClicked;
String[] clickedPlayersID = new String[9];
//Queue<PlayerData> playerClickedQueue = new LinkedList<>();
boolean check = true,displayflag=false;
//boolean canPressYearButton = true;
int buttonNumberPressed= 0;
int[] buttonColor = {16734033,16760115,14417715,7733043,3407703,3407805,1152345,5432345,1235467};
void setup() {
   size(1200,680);
   pg = createGraphics(1200, 680);
   botarr = new PShape[30];
   botarr[0] = loadShape("ANA.svg");
   botarr[1] = loadShape("ARI.svg");
   botarr[2] = loadShape("ATL.svg");
   botarr[3] = loadShape("BOS.svg");
   botarr[4] = loadShape("CHA.svg");
   botarr[5] = loadShape("CHN.svg");
   botarr[6] = loadShape("CIN.svg");
   botarr[7] = loadShape("CLE.svg");
   botarr[8] = loadShape("COL.svg");
   botarr[9] = loadShape("DET.svg");
   botarr[10] = loadShape("HOU.svg");
   botarr[11] = loadShape("KCA.svg");
   botarr[12] = loadShape("LAN.svg");
   botarr[13] = loadShape("MIL.svg");
   botarr[14] = loadShape("MIN.svg");
   botarr[15] = loadShape("MON.svg");
   botarr[16] = loadShape("NYA.svg");
   botarr[17] = loadShape("NYN.svg");
   botarr[18] = loadShape("OAK.svg");
   botarr[19] = loadShape("PHI.svg");
   botarr[20] = loadShape("PIT.svg");
   botarr[21] = loadShape("SEA.svg");
   botarr[22] = loadShape("SFN.svg");
   botarr[23] = loadShape("SLN.svg");
   botarr[24] = loadShape("TBA.svg");
   botarr[25] = loadShape("TEX.svg");
   botarr[26] = loadShape("TOR.svg");
  background(255);
  f = createFont("Arial", 20, true);
  font = new ControlFont(f,20);
  cp5 = new ControlP5(this);
  
  cp5.setAutoDraw(false);
   
  
  
  //my random function calls to test of they work
  createPlayerObjects();
 // getPlayerDetails("anderga01");
  //System.out.println("Highest paid Player salary");
  int row = getHighestPaidPlayer(2005);
  //System.out.println("row "+row);
   //System.out.println("Salary "+playerData[row][2005-2000].salary);
  //getPlayerDetails(playerData[row][0].playerID);
  
  
}

void draw() {
  background(255);
  switch (currentMode) {
    case -1:
   
     drawWelcomeScreen();
      bot = loadShape("MAINMB.svg");
      shape(bot,xsize/2-100, 150, 150, 150);
       break;
    case 0:
   
    
    
    break;
    
    case 1:  
      //player Mode
      fill(0);
      if(!teamLogoClicked){
     //System.out.println("Playermode");
     handlePlayerMode();}
     else{
       size(1200,680);
       background(255);
       drawText(25,CENTER,clickedTeamID+" Players",xsize/2-300,30);
       
       drawPlayersPart(); //will have functions to list players, make their graphs etc.
       
      
     }
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
      fadingOut = !fadingOut;  
    }
    if (!fadingOut && transitionOpacity <= 0) {
      modeTransitioning = false;
      fadingOut = true;
      transitionOpacity = 0;
    }
  }
}
void drawModeDropDown(String mode,List dropdownItemList){


  modeDropList = cp5.addScrollableList(mode)
     .setPosition(dropdownPosX, dropdownPosY)
     .setSize(200, 200)
     .setBarHeight(30)
     .setItemHeight(30)
     .addItems(dropdownItemList)
      .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
     ;
  cp5.getController(mode).getCaptionLabel().setFont(font).setSize(15);
  cp5.getController(mode).getCaptionLabel().getStyle().marginTop = 5; 
  cp5.getController(mode).getCaptionLabel().getStyle().marginLeft = 5; 
  cp5.getController(mode).getValueLabel().setFont(font).setSize(15);
  cp5.getController(mode).getValueLabel().getStyle().marginTop = 5; 
  cp5.getController(mode).getValueLabel().getStyle().marginLeft = 5;    

  modeDropList.close();

}
void handlePlayerMode(){
  drawText(45,LEFT,"PICK YOUR",10,ysize/2);
  drawText(45,LEFT,"TEAM",10,ysize/2+30);
  drawTeamLogos();
  displayHoverText();
  
  
}

void drawPlayersPart(){
  if(drawYearListOnce)
    {drawYearListOnLeft();
      drawYearListOnce= false;
    }
    
  String filename = clickedTeamID + ".svg";
   bot = loadShape(filename);
   shape(bot,20,0,120,120);
   if(displayflag)
     {
       displayEachPlayerDetails();
      // check =false;
     }
   
   if(yearClicked>=2000 && check){
      displayPlayers(yearClicked,clickedTeamID);
     
    // System.out.println("2000 clicked");
     //break;
     //default:
     //  break;
   
   
   }
  

}
void displayPlayers(int yearClicked,String clickedTeamID){
  int buttonxpos = 200;
  int buttonypos = 50;
    cp6 = new ControlP5(this);
    int j=0;
    for(int i=0;i<1332;i++){
        if(playerData[i][yearClicked-2000]!=null &&  playerData[i][yearClicked-2000].teamID.contains(clickedTeamID)){
        //System.out.println(playerData[i][yearClicked-2000].playerName);
        //playerClickedQueue.add(playerData[i][yearClicked-2000]);
         playersButton[j]= cp6.addButton(playerData[i][yearClicked-2000].playerName)
         .setPosition(buttonxpos,buttonypos).setSize(100,60)
        
       //Set the pre-defined Value of the button : (int)
       .setValue(0)
       .setColorBackground(buttonColor[0]) 
       //set the way it is activated : RELEASE the mouseboutton or PRESS it
       .activateBy(ControlP5.PRESS).setOn() ;
        clickedPlayersID[j++]=playerData[i][yearClicked-2000].playerID;
       // System.out.println(clickedPlayersID[j++]);
        //this will have the 9 playerID for each team for each year
      buttonxpos+=105;
  }
    }
    playersButton[9]= cp6.addButton("Back to year").setPosition(180,500).setSize(100,60)
        
       //Set the pre-defined Value of the button : (int)
       .setValue(1)
       .setColorBackground(255) 
       //set the way it is activated : RELEASE the mouseboutton or PRESS it
       .activateBy(ControlP5.PRESS).setOn() ;
    
   //displayTwoPlayerDetails();
   check = false;
   // cp6.hide(playersButton[0]);
   //cp6.controlEvent(CckontrolEvent theEvent);
     //cp6.draw();

}
void displayEachPlayerDetails(){
  int i = buttonNumberPressed;     //which player button was clicked
 // getPlayerDetails(clickedPlayersID[i]);
  //lets plot player salary over the year
  int index = hash.get(clickedPlayersID[i]);       // get the id of that player (as we had saved it above ) 
  int maxSal = getHighestPaidPlayer(yearClicked);  
  drawAxesAndLabels(2016,2000,maxSal,0.5,"Years","Salary in Million");
  
  for(PlayerData pd : playerData[index])
    if(pd!=null){
     int m = (int)map(pd.salary,28000000,165574,150,415);
     int x = (int)map( pd.yearID,2000,2016,300,1100);
     strokeWeight(4);
     point(x,m);
    // System.out.println(x+"  "+m);
     drawText(15,CENTER ,pd.playerName,750,140);
    //System.out.println(pd.salary);
  }



}
void drawAxesAndLabels(int xmax,int xmin,float ymax,float ymin,String xlabel,String ylabel){
  
    drawAxesLabels(xlabel, ylabel,450,450,150,250);
    strokeWeight(0.3);
    line(300,415,1150,415);
    line(300,415,300,150);
    drawAxesScale(1,2000,0,300,1150,50,410,415,150,-25,280);

}





void drawYearListOnLeft(){
  int i = teamStartYear;
  int buttonxpos = 30;
  int buttonypos = 125;
  
  cp5.hide();
   cp5 = new ControlP5(this);
  // drawModeDropDown("Select Year",dropdownYearList );
  for(;i<=teamEndYear;i++){
     button[i-2000]= cp5.addButton("Year"+i).setPosition(buttonxpos,buttonypos).setSize(100,30)
       //Set the pre-defined Value of the button : (int)
       .setValue(0)
       //set the way it is activated : RELEASE the mouseboutton or PRESS it
       .activateBy(ControlP5.PRESS).setOff() ;
      buttonypos+=32;
  }
  goBackToTeams = cp5.addButton("Back to the teams").setPosition(1000,600).setSize(200,60)
       //Set the pre-defined Value of the button : (int)
       .setValue(0)
       //set the way it is activated : RELEASE the mouseboutton or PRESS it
       .activateBy(ControlP5.PRESS).setOff() ;
}


void drawPlayerNames(){
  drawText(45,LEFT,"TEAM",300,ysize/2+30);
  bot = loadShape("ANA.svg");
   shape(bot,80,0,120,120);
  System.out.println("click ");
}

void displayHoverText(){
  mouseOver();
  
}



void drawText(int siz,int Align , String str, int xpos,int ypos){
  textFont(f, siz);
  textAlign(Align);
  text(str, xpos,ypos);
}



void drawWelcomeScreen(){
  fill(0);
  textAlign(LEFT);
  textFont(f, 42);
  text("Major League Baseball Data Visualization ", 130, ysize/2);
  textFont(f, 25);
  //textAlign(CENTER);
  text("CS6260 Term Project",xsize/2-150, ysize/2+50);
  text("By:",30, ysize-155);
  text("Che Shian Hung", 30, ysize-125);
  text("Oluwaseun Sesan Shadare",30,ysize-95);
  text("Shadi Moradi",30,ysize-65);
  text("Dewan Chaulagain",30,ysize-35);
}


//void drawProgramHeader() {
//  fill(0);
//  textFont(f, 15);
//  textAlign(LEFT);
//  text("CS6260 Term Project", 30, 30);
//  text("Che Shian Hung, Dewan Chaulagain, Oluwaseun Sesan Shadare, Shadi Moradi", 30, 55);
//}

void drawModeTitle() {
  fill(0);
  textAlign(LEFT);
  textFont(f, 42);
  text("Let's help " + ((currentMode % 2 == 0) ? "Dr. Lee" : "Brandon") + "!", 600, 55);
  //textFont(f, 20);
  //text("to find the cheapest best " + modeText[currentMode].toLowerCase() + " :)", 650, 95);
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
      //case "Select Year":
      //              yearClicked = int(theEvent.getController().getValue())+2000;
         
        
      //  break;
          
      default:
        break;
    }
  }
 
  
   for (int i =0;i<17;i++)
  {
    if(theEvent.isFrom(button[i])){
      if(theEvent.getController().getName().contains("Year")){
     String temp =  theEvent.getController().getName().substring(4,8);
     yearClicked = Integer.parseInt(temp);
     }
  }
    }
  for (int i =0;i<9;i++)
  {
    if(theEvent.isFrom(playersButton[i])){
      buttonNumberPressed = i;
      displayflag=true;
       System.out.println("pressed button "+ (i+1));
       
    }  
  }
  if(theEvent.isFrom(playersButton[9])){
      //buttonNumberPressed = 8;
      yearClicked=0;
      displayflag=false;
       System.out.println("pressed button "+ (8+1));
       check = true;
       cp6.hide();
       
    }
    if(theEvent.isFrom(goBackToTeams)){
    
      System.out.println("BAck");
     teamLogoClicked=false;
     check = true;displayflag=false;
     buttonNumberPressed=0;
     
    }
}

void mousePressed() {
  if (!modeDropList.isMouseOver()) {    
    modeDropList.close();
  }
}

void mouseOver(){
 
  if(mouseX>300 && mouseX<=xsize && mouseY >=0 && mouseY<=ysize)
      drawText(15,LEFT,teams[mouseY/130][(mouseX-300)/300],mouseX,mouseY);
  
}
void mouseClicked(){
  if(currentMode==1 && teamLogoClicked==false){ //if in player mode, then we have all logos, use that
    if(mouseX>300 && mouseX<=xsize && mouseY >=0 && mouseY<=ysize)
      {
        teamLogoClicked=true;
        String temp = teams[mouseY/130][(mouseX)/130];
        temp = temp.substring(temp.indexOf('(')+1,temp.indexOf(')'));
        clickedTeamID = temp;
        //background(255);      
      }
      //drawText(15,LEFT,teams[mouseY/130][(mouseX-300)/300],mouseX,mouseY);
  
  
  }
}

void keyPressed() {
      if (key == ' ') {
        
       currentMode=0;
       if(dropDownVisible){
      drawModeDropDown("MODE SELECT",dropdownItemList);
      dropDownVisible = false;
    }
      // pg.beginDraw(); 
      //  pg.clear();
      //pg.endDraw(); 
    }
}
