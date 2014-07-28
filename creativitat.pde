int numLevels = 3;
int modul = 20;
int dispersioInicial = 30;
int fuzziness = 10;
int which = 1;
String file = "image.gif";
Level[] level = new Level[numLevels];
Bezier[] bezier = new Bezier[numLevels];
void setup(){
  smooth();
  PImage a = loadImage(file);
  size(a.width*modul, a.height*modul);
  int w = a.width;
  int h = a.height;
  background(255);
  for(int i = 0; i< numLevels; i++){
    level[i] = new Level(i);
  }
  bezier[which] = new Bezier(level[which].nodes);
}
void draw(){
  bezier[which].linia();
}
class Level{
  PImage a;
  int[] x = new int[0];
  int[] y = new int[0];
  int densitat;
  int count = 0;
  float[][] nodes;
  Level(int level){
    densitat = level+1;
    a = loadImage(file);
    a.filter(POSTERIZE,255);
    float umbral = 1 - float(level)/numLevels;
    a.filter(THRESHOLD,umbral);
    for(int i=0; i< a.height; i++){
      for(int j=0; j< a.width; j++){
        if(unhex(hex(a.get(j,i),2)) < 255){
          x = append(x, j);
          y = append(y, i);
        }
      }
    }
    nodes = new float[x.length * densitat][4];
    for(int i= 0; i< x.length; i++){
      for(int j=0; j< densitat; j++){
        nodes[count][0] = x[i]*modul + random(modul);
        nodes[count][1] = y[i]*modul + random(modul);
        nodes[count][2] = random(360);
        nodes[count][3] = random(fuzziness)+20;
        count++;
      }
    }
  }
}
class Bezier{
  int index,dispersio = dispersioInicial;
  float nx,ny,na,ns,nx2,ny2,na2,ns2;
  float[][] posicions;
  float[][] posicions1;
  float[][] posicions2;
  Bezier(float[][] punts){
    posicions = punts;
    index = floor(random(posicions.length));
    nx = posicions[index][0];
    ny = posicions[index][1];
    na = posicions[index][2];
    ns = posicions[index][3];
    posicions1 = (float[][])subset(posicions, 0,index);
    posicions2 = (float[][])subset(posicions, index+1, posicions.length-index-1);
    posicions = (float[][])concat(posicions1,posicions2);
  } 
  void linia(){
    noFill();
    int[] indexa = new int[0];
    if(posicions.length > 0){
      for(int i= 0; i < posicions.length; i++){ //busca un punt en d= dispersio
        if(abs(dist(nx, ny, posicions[i][0], posicions[i][1])) < dispersio && dist(nx, ny, posicions[i][0], posicions[i][1])>0){
          indexa = append(indexa, i);
        }
      }
      if(indexa.length > 0){
        int select = indexa[floor(random(indexa.length))]; //selecciona index de totes les possibles combinacions
        nx2 = posicions[select][0];
        ny2 = posicions[select][1];
        na2 = posicions[select][2];
        ns2 = posicions[select][3];
        posicions1 = (float[][])subset(posicions, 0, select);
        posicions2 = (float[][])subset(posicions, select+1, posicions.length-select-1);
        posicions = (float[][])concat(posicions1,posicions2);
        stroke(0);
        strokeWeight(1);
        line(nx,ny,nx2,ny2);
        nx = nx2;
        ny = ny2;
        na = na2;
        ns = ns2;
        dispersio = dispersioInicial;
      } else {
        dispersio++;
      }
    } else {
      if(which < numLevels-1){
      println("End level " + which);
      which++;
      bezier[which] = new Bezier(level[which].nodes);
      }else{
        noLoop();
        println("Finished!");
      }
    }
  }
}
