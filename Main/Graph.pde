import java.text.*;
DecimalFormat numberFormat = new DecimalFormat("#0");
void drawAxesLabels(String xlabel, String ylabel,int x1, int y1,int x2,int y2){
  textFont(f,16);  // give axis labels and titles
  textAlign(LEFT);
  stroke(100,0,0);
  text(xlabel,x1,y1);
  //text(xlabel, 450, 450);
  pushMatrix();
   //rotate(-PI/2);
    text(ylabel,x2,y2);
  // text(ylabel, 150, 250);
   popMatrix();
}

void drawAxesScale(int strokeweight, int xsum, int ysum, int rowstart, int rowend, int rowrange, int linex,int colstart, int colend, int colrange ,int liney )
{
   strokeWeight(1);
   //float sum =2000;
  
  for(int i=rowstart;i<rowend;i+=rowrange)
    {
      strokeWeight(0.2);
      pushMatrix();
      //sum+=xvaluetoprint;
    line(i,linex,i,linex+10);
    String xvalue = numberFormat.format(xsum);
      text(xvalue,i-7,linex+20);
      xsum ++;
      popMatrix();
    }
    //ysum = 0;
    for(int i=colstart;i>=colend;i+=colrange)
    {
      
      strokeWeight(0.5);
       line(rowstart,i,rowend,i);
      pushMatrix();
      String yvalue = numberFormat.format(ysum);
      text(yvalue,liney,i);
      ysum+= 3;
      popMatrix();
    }
}
