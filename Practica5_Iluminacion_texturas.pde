// Realizado por Martín van Puffelen López

// Idea animación crecimiento estaciones de alquiler bicicletas desde inicio de año
// Coger top  alquiler y hacer figuras a tamaño relativo

import processing.sound.*;
PGraphics lienzo;
PImage img;
PImage edgeImg;
boolean playedParty;
HashMap<String, float[]> stations;

int xAux=0;
int yAux;
int yPos;
float angOro, angPlata, angBronce;
PShape sagulpaFace;
PImage textureSagulpa;

Table estaciones;
int mode;
final int START_SCREEN= 1;
final int ANIMATION_SCREEN=2;
float minlat,minlon,maxlat,maxlon;

float r = 5;
int numStats=10;
float rMax=175;
int rentalMax=11291;
float rtelmo,rsanta,rferia,rshana,rwoer,rnaval,rfarray,rleon,resp,rpilar=5;
boolean pop1,pop2,pop3,pop4,pop5,pop6,pop7,pop8,pop9,pop10=false;

float zoom;
SoundFile  popSound;
SoundFile  partySound;
int x;
int y;

float v= 1.0/9.0;
float[][] kernel = {{ v, v, v }, 
                    { v, v, v }, 
                    { v, v, v }};        


void setup() {
  size(800, 800, P3D);
  mode=START_SCREEN;
  stations= new HashMap<String, float[]>();
  // Coger 10 estaciones con más bicicletas alquiladas
  estaciones = loadTable("Estaciones Sitycleta.csv", "header" );
  for(TableRow est: estaciones.rows()){
    String estacionName=est.getString("Estación");
    float arr[] = new float[3];
    arr[0]=est.getFloat("Latitud");
    arr[1]=est.getFloat("Longitud");
    arr[2]=est.getFloat("Rentals");
    stations.put(estacionName,arr);
  }
  playedParty=false;
  angOro=0; 
  angPlata=0; 
  angBronce=0;
  textureSagulpa=loadImage("saguLogo.png");
  yAux=0;
  yPos=-1;
  

  //Imagen del Mapa
  img=loadImage("map.jpg");
  img.loadPixels();
  // Blur imagen presentación
  edgeImg=createImage(img.width,img.height,RGB);
   for (int y = 1; y < img.height-1; y++) {   // Skip top and bottom edges
    for (int x = 1; x < img.width-1; x++) {  // Skip left and right edges
      float sum = 0; // Kernel sum for this pixel
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*img.width + (x + kx);
          // Image is grayscale, red/green/blue are identical
          float val = red(img.pixels[pos]);
          // Multiply adjacent pixels based on the kernel values
          sum += kernel[ky+1][kx+1] * val;
        }
      }
      // For this pixel in the new image, set the gray value
      // based on the sum from the kernel
      edgeImg.pixels[y*img.width + x] = color(sum);
    }
  }
  // State that there are changes to edgeImg.pixels[]
  edgeImg.updatePixels();
  
  //Creamos lienzo par el mapa
  lienzo = createGraphics(img.width ,img.height);
  lienzo.beginDraw();
  lienzo.background(100);
  lienzo.endDraw();

  //Latitud y longitud de los extremos del mapa de la imagen
  minlon = -15.4678;
  maxlon = -15.3545;
  minlat = 28.0946;
  maxlat = 28.1595;

  x = 0;
  y = 0;
  zoom = 1;
  popSound= new SoundFile(this,"sfx-pop.wav");
  partySound=new SoundFile(this,"partySound2.wav");
}

void draw() {
  background(220);
  if(mode==START_SCREEN){
    image(edgeImg, 0, 0);
    fill(0,0,0);
    textSize(22);
    text("Evolución alquiler sitycletas", width/3, height/3, 120); 
    text("Pulsa ESPACIO para iniciar animación", width/4, height/2, 120); 
  
  }
  if(mode==ANIMATION_SCREEN){
    //Desplazamiento con botón izquierdo ratón
    if(numStats!=0){
    if (mousePressed && mouseButton == LEFT) {
      x += (mouseX - pmouseX)/zoom;
      y += (mouseY - pmouseY)/zoom;
    }
    //Coloca origen en el centro
    pushMatrix();
    translate(width/2,height/2,0);
    //Escala según el zoom
    scale(zoom);
    //Centro de la imagen en el origen
    translate(-img.width/2+x,-img.height/2+y);
    image(lienzo, 0,0);
     actMapa();
     popMatrix();
    }
     if(numStats==0){
         if(!playedParty){
          partySound.play();
          playedParty=true;
        }
       translate(-width/2,-height/2,0);
        camera();
        background(0);
        textureMode(NORMAL);
        beginShape();
        texture(textureSagulpa);
        vertex(0, 0, 0, 0,   0);
        vertex( 100, 0, 0, 1, 0);
        vertex( 100,  100, 0, 1, 1);
        vertex(0,  100, 0, 0,   1);
        endShape();
        ambientLight(128, 128, 128);
        lightSpecular(128,128,128);
        directionalLight(128,128,128, 0, 1, -1);
        textSize(20);
        text("¡San Telmo: 11291!", width/3+40, 200+yAux, 0);
        yAux+=1*yPos;
        if(yAux<=180 || yAux>220 ){
          yPos=-yPos;
        }
        fill(255,248,220);
        text("Plaza de la feria: 9617", width/4, 590, 0);
        fill(255,248,220);
        text("Base Naval: 9612", width*0.7, 590, 0);
        fill(255,255,255);
        text("Alquileres sitycleta 2021", 110 ,50);
        visPodium();
        translate(width/2, height/2-10, 50);
        rotateX(radians(-30));
        noStroke();
        box(100);
        
        pointLight(0, 0, 10,mouseX,mouseY,1000);
        pushMatrix();
        translate(0,-100,0);
        rotateY(radians(angOro));
        angOro+=2;
        specular(255,255,255);
        shininess(1.0 + (10 * abs(cos(frameCount * 0.2))));
        ambient(255, 215,0);
        sphere(50);
        popMatrix();
        
        pushMatrix();
        translate(-140,0,0);
        rotateY(radians(angPlata));
        angPlata+=1.5;
        specular(70);
        shininess(1.0 + (10 * abs(cos(frameCount * 0.1))));
        ambient(216, 216,216);
        sphere(50);
        popMatrix();
        
        pushMatrix();
        translate(145,0,0);
        rotateY(radians(angBronce));
        angBronce+=1;
        specular(50);
        shininess(1.0 + (10 * abs(cos(frameCount * 0.05))));
        ambient(128, 74,0);
        sphere(50);
        popMatrix();
        xAux=0;

        }
     }
  }


void visPodium(){
    for(int i=0;i<6;i++){
    pushMatrix();
    ambient(255, 255,255);
    specular(0);
    translate(150+xAux, height/2+100, 0);
    rotateX(radians(-30));
    noStroke();
    box(100);
    xAux+=100;
    popMatrix();
  }
}


//Rueda del ratón para modificar el zoom
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zoom -= e/10;
  if (zoom<1)
    zoom = 1;
}

void reset(){
  x = 0;
  y = 0;
  zoom=1;
  numStats=10;
  rtelmo=5;rsanta=5;rferia=5;rshana=5;rwoer=5;rnaval=5;rfarray=5;rleon=5;resp=5;rpilar=5;
  pop1=false;pop2=false;pop3=false;pop4=false;pop5=false;pop6=false;pop7=false;pop8=false;pop9=false;pop10=false;
}

void keyPressed(){
  if(key=='r'&& mode==ANIMATION_SCREEN){
    reset();
  }
  if(key==' ' && mode!=ANIMATION_SCREEN){
    mode=ANIMATION_SCREEN;
  }

}

void actMapa(){
  lienzo.beginDraw();
  lienzo.image(img, 0,0,img.width,img.height);
  for(String key: stations.keySet()){
    float mlon = map(stations.get(key)[1], minlon, maxlon, 0, img.width);
    float mlat = map(stations.get(key)[0], maxlat, minlat, 0, img.height);
    lienzo.fill(0,255,0);
    float propSizeEllipse=(stations.get(key)[2]/rentalMax)*rMax;
    switch(key){
      case "San Telmo":
        if (rtelmo<propSizeEllipse) rtelmo=visEl(rtelmo, mlon, mlat);
        else if(!pop1){
          pop1=true;              
          popSound.play();
          numStats--;   
        }
        break;
      case "Plaza de la feria":
        if (rferia<propSizeEllipse) rferia=visEl(rferia, mlon, mlat);
        else if(!pop2){
          pop2=true;                  
          popSound.play();
          numStats--;   
        }
        break;
       case "Base Naval":
        if (rnaval<propSizeEllipse) rnaval=visEl(rnaval, mlon, mlat);
        else if(!pop3){
          pop3=true;                
          popSound.play();
          numStats--;   
        }
        break;
      case "Parque Santa Catalina":
        if (rsanta<propSizeEllipse) rsanta=visEl(rsanta, mlon, mlat);
        else if(!pop4){
          pop4=true;                 
          popSound.play();
          numStats--;   
        }
        break;
      case "Plazoleta de Farray":
        if (rfarray<propSizeEllipse) rfarray=visEl(rfarray, mlon, mlat);
        else if(!pop5){
          pop5=true;                
          popSound.play();
          numStats--;   
        }
        break;
      case "Plaza O'Shanahan":
        if (rshana<propSizeEllipse) rshana=visEl(rshana, mlon, mlat);
        else if(!pop6){
          pop6=true;                 
          popSound.play();
          numStats--;   
        }
        break;
      case "León y Castillo":
        if (rleon<propSizeEllipse) rleon=visEl(rleon, mlon, mlat);
        else if(!pop7){
          pop7=true;                 
          popSound.play();
          numStats--;   
        }
        break;
      case "Plaza de España":
        if (resp<propSizeEllipse) resp=visEl(resp, mlon, mlat);
        else if(!pop8){
          pop8=true;
                 
          popSound.play();
          numStats--;             
        }
        break;
      case "Plaza del Pilar":
        if (rpilar<propSizeEllipse) rpilar=visEl(rpilar, mlon, mlat);
        else if(!pop9){
          pop9=true;
               
          popSound.play();
          numStats--;     
        }
        break;
      case "Torre Woermann":
        if (rwoer<propSizeEllipse) rwoer=visEl(rwoer, mlon, mlat);
        else if(!pop10){
          pop10=true;               
          popSound.play();
          numStats--;     
        }
        break;
    }
    lienzo.fill(0,0,0);
    lienzo.textSize(15);
    lienzo.text(key, mlon+2,mlat);
  }
  lienzo.endDraw();
}

float visEl(float R, float mlon, float mlat){
   R+=0.2;
   lienzo.ellipse(mlon, mlat, R, R);
  return R;
}
