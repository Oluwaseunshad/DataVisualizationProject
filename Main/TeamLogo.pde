
void drawTeamLogos(){
  //shape() function doesnot accept patterns, so cannot use loop to do it
  //DONOT DELETE THE BELOW SEQUENTIAL CODE
  /*
  String[] teams = {"ANA.svg","ARI.svg","ATL.svg","BAL.png","BOS.svg","CHA.svg","CHN.svg","CIN.svg","CLE.svg","COL.svg"
  ,"DET.svg","FLO.svg","HOU.svg","KCA.svg","LAN.svg","MIL.svg","MIN.svg","MON.svg",
  "NYA.svg","NYN.svg","OAK.svg","PHI.svg","PIT.svg","SDN.svg","SEA.svg","SFN.svg","SLN.svg","TBA.svg","TEX.svg","TOR.svg"}  ;
  
  
   bot = loadShape(t);
   shape(bot,xpos,ypos, 50, 50);
  //String p = "SEA.svg";
  for(String t : teams){
    int xpos = xsize/3-100;
    int xadd = 52;
    for(int a=0;a<5;a++){
      bot = loadShape(t);
      shape(bot,xpos,ypos, 50, 50);
      xpos+=xadd;
      }
      ypos+=52;
  }
  */
    int figsize = 120;
   int xpos = xsize/3-100;
   int ypos = 0;
   int xadd = figsize+20;
  
   shape(botarr[0],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   shape(botarr[1],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   shape(botarr[2],xpos,ypos,figsize,figsize);
   xpos+=xadd;
   
   shape(botarr[3],xpos,ypos,figsize,figsize);
   xpos+=xadd;
   xpos+=xadd;
   
   shape(botarr[4],xpos,ypos,figsize,figsize);
   xpos+=xadd;
   
   shape(botarr[5],xpos,ypos,figsize,figsize);
   
   
    ypos+=(figsize+20);
   xpos = xsize/3-100;
  
   shape(botarr[6],xpos,ypos,figsize,figsize);
   xpos+=xadd;
   
   shape(botarr[7],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   shape(botarr[8],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   shape(botarr[9],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   shape(botarr[10],xpos,ypos,figsize,figsize);
   xpos+=xadd;
   
    shape(botarr[11],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   xpos = xsize/3-100;
   ypos+=(figsize+20);
  
   shape(botarr[12],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   shape(botarr[13],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   shape(botarr[14],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   shape(botarr[15],xpos,ypos,figsize,figsize);
   xpos+=xadd;
   
   shape(botarr[16],xpos,ypos,figsize,figsize);
   xpos+=xadd;
   
   shape(botarr[17],xpos,ypos,figsize,figsize);
   
   xpos = xsize/3-100;
   ypos+=(figsize+20);
  
   shape(botarr[18],xpos,ypos,figsize,figsize);
   xpos+=xadd;
   
   shape(botarr[19],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   shape(botarr[20],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   shape(botarr[21],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   shape(botarr[22],xpos,ypos,figsize,figsize);
   xpos+=xadd;
   shape(botarr[23],xpos,ypos,figsize,figsize);
   xpos+=xadd;   
  
   xpos = xsize/3-100;
   ypos+=(figsize+20);
  
   shape(botarr[24],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   shape(botarr[25],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   shape(botarr[26],xpos,ypos,figsize,figsize);
   xpos+=xadd;
  
   shape(botarr[27],xpos,ypos,figsize,figsize);
   xpos+=xadd;
   
   shape(botarr[28],xpos,ypos,figsize,figsize);
   xpos+=xadd;
   
   shape(botarr[29],xpos,ypos,figsize,figsize);
 
  }
