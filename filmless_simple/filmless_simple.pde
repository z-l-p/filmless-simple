// A workflow for printing projectable 16mm film images
// ----------------------------------------------------
// by Matt McWilliams https://sixteenmillimeter.com/projects/filmless/
// Customized by Zach Poff in March 2025:
//  - Added vertical lines to make film strip layout easier
//  - Added direction arrow and (optional) page numbering
//  - Exported page is now PNG, with DPI metadata for printing actual size


//for core functions
import processing.sound.*;
import soundtrack.optical.*;
// for changing the DPI of the full page output file
import java.awt.image.BufferedImage;
import java.util.Iterator;
import javax.imageio.*;
import javax.imageio.metadata.*;
import javax.imageio.stream.*;
import java.awt.Graphics2D;


/**
 *  CHANGE THESE
 **/

//types: unilateral, variable area, dual variable area, maurer, variable density
int DPI = 1440;               //maximum printer DPI 
String SOUNDTRACK_TYPE  = "unilateral";
String PITCH = "long";        // long, short //7.62, 7.605
String FORMAT = "16mm";       //16mm or super16
int PERFS = 1;                //single (1) or double (2) perf film
float PAGE_W = 8.5;           //page width in inches
float PAGE_H = 11.0;          //page height in inches
float SAFE_W = .25;           //safe area on each side of the page
float SAFE_H = 1.0;            //safe area on top and bottom of page
color BACKGROUND = color(255);  //the color that will fill the entire frame where there's no image (clear 255 is best for production)
int GUIDELINE_PX = 0;        // The pixel width of the vertical guidelines between strips of film (set to 0 to disable)
int SHOW_PAGENUM = 1;            // Set to true to print page numbers (leave it off for printing the template)
boolean NEGATIVE = false;     //true to invert image data
boolean SHOW_PERFS = true;    //set to true to print perfs for cutting registration
color PERFS_COLOR = color(255);
int SOUND_OFFSET = 25;

//Don't change unless necessary
String SEP = System.getProperty("file.separator");

String SOURCE = "frames";           //path to directory containing frames
String SOUND = "audio";    //leave empty string if silent

//This is a magic number that is used to scale the vertical (H) or horizontal (W) resolution
//because the printer sometimes lies to you.
float MAGIC_H_CORRECTION = 1.0;
float MAGIC_W_CORRECTION = 1.0;

/**
 * CONSTANTS (DON'T CHANGE PLZ)
 **/
float IN = 25.4;
float LONG_H = 7.62;
float SHORT_H = 7.605;     
float STD16_W = 10.26;   //0.413"
float STD16_H = 7.49;    //0.295"
float SUPER16_W = 12.52; //0.492" 
float SUPER16_H = 7.41;  //0.292"
float PERF_W = 1.829;
float PERF_H = 1.27;
float DPMM = DPI / IN;

int SPACING = PITCH.equals("long") ? round(LONG_H * DPMM * MAGIC_H_CORRECTION) : round(SHORT_H * DPMM * MAGIC_H_CORRECTION);
int PAGE_W_PIXELS = ceil((PAGE_W - (SAFE_W * 2)) * DPI * MAGIC_W_CORRECTION);
int PAGE_H_PIXELS = ceil((PAGE_H - (SAFE_H * 2)) * DPI * MAGIC_H_CORRECTION);
int FRAME_W = FORMAT.equals("super16") ? round(SUPER16_W * DPMM * MAGIC_W_CORRECTION) : round(STD16_W * DPMM * MAGIC_W_CORRECTION);
int FRAME_H = FORMAT.equals("super16") ? round(SUPER16_H * DPMM * MAGIC_H_CORRECTION) : round(STD16_H * DPMM * MAGIC_H_CORRECTION);
int LEFT_PAD = round(((16 - STD16_W) / 2) * DPMM * MAGIC_W_CORRECTION); //space to left of frame
int COLUMNS = floor(PAGE_W_PIXELS / (16 * DPMM));
int ROWS = floor(PAGE_H_PIXELS / SPACING);
int FRAME_LINE = round((SPACING - FRAME_H) / 2);
int PAGES = 0;
int FRAMES = 0;
int SOUND_W = ceil(DPMM * (12.52 - 10.26));
boolean HAS_SOUND = false;
String SOUNDTRACK_FILE = "";

SoundtrackOptical soundtrack;
String[] frames;
PImage frameBuffer;
PGraphics frameBlank;
PGraphics pageBuffer;
PGraphics soundBuffer;

void setup () {
  size(460, 240);
  //surface.setResizable(true);
  println(SOURCE);
  println(SOUND);
  frames = listFrames(SOURCE, SOUND);
  if (frames == null) {
    println("Frames not found, check SOURCE path");
    exit();
    return;
  }
  
  FRAMES = frames.length;
  PAGES = ceil((float) FRAMES / (ROWS * COLUMNS));
  pageBuffer = createGraphics(PAGE_W_PIXELS, PAGE_H_PIXELS);
  
  if (HAS_SOUND) {
    soundtrack = new SoundtrackOptical(this, SOUNDTRACK_FILE, DPI, 1.0, SOUNDTRACK_TYPE, PITCH, !NEGATIVE);
  }
  
  printInfo();
  
  if (PERFS == 2 && HAS_SOUND ) {
    println("WARNING: Double perf film and soundtrack will interfere with one another. Are you sure?"); 
  }
  
  if (FORMAT.equals("super16") && HAS_SOUND) {
    println("WARNING: Super16 frame and soundtrack will interfere with one another. Are you sure?"); 
  }
  
  if (FORMAT.equals("super16") && PERFS == 2) {
    println("WARNING: Super16 frame and double perf film will interfere with one another. Are you sure?"); 
  }

  text("DISPLAY", 200, 200);
  frameBlank = createGraphics(FRAME_W, FRAME_H);
  noLoop();
  delay(1000);
  thread("renderPages");
}

void draw () {
  background(0);
  fill(255);
  text("SOURCE DIR: " + SOURCE, 10, 20);
  text("DPI: " + DPI, 10, 40);
  text("STRETCH: " + MAGIC_W_CORRECTION + " x " + MAGIC_H_CORRECTION, 10, 60);
  text("FRAMES: " + FRAMES, 10, 80);
  text("FRAME SIZE: " + FRAME_W + "x" + FRAME_H + " px", 10, 100);
  text("PAGES: " + PAGES, 10, 120);
  text("PAGE SIZE: " + PAGE_W_PIXELS + "x" + PAGE_H_PIXELS + " px", 10, 140);
  text("FRAMES/PAGE: " + (ROWS * COLUMNS), 10, 160);
  text("SECONDS/PAGE: " + ((ROWS * COLUMNS) / 24), 10, 180);
  textSize(20);
  text("RENDERING... (This window will close when done.)", 10, 210);
}

void printInfo() {
  println("STRETCH: " + MAGIC_W_CORRECTION + " x " + MAGIC_H_CORRECTION);
  println("PAGE SIZE: " + PAGE_W_PIXELS + "x" + PAGE_H_PIXELS);
  println("FRAME SIZE: " + FRAME_W + "x" + FRAME_H);
  println("FRAMES PER STRIP: " + ROWS);
  println("STRIPS PER PAGE: " + COLUMNS);
  println("FRAMES PER PAGE: " + (ROWS * COLUMNS));
  println("SECONDS PER PAGE: " + ((ROWS * COLUMNS) / 24));
  println("FRAMES: " + FRAMES);
  println("PAGES: " + PAGES);
  //println("RENDER_PATH: " + RENDER_PATH);
  if (!SOUND.equals("")) {
    println("SOUNDTRACK SAMPLE RATE: " + (SPACING * 24));
  }
}

String[] listFrames (String dir, String audioDir) {
  ArrayList<String> tmp = new ArrayList<String>();
  ArrayList<String> audioTmp = new ArrayList<String>();
  String output[];
  File file;
  File audioFile;
  int arraySize;
  int o = 0;
  dir = dataPath(dir);
  audioDir = dataPath(audioDir);
  println(dir);
  println(audioDir);
  if (dir.substring(dir.length() - 1, dir.length()) != SEP) {
    dir = dir + SEP;
  }
  if (audioDir.substring(audioDir.length() - 1, audioDir.length()) != SEP) {
    audioDir = audioDir + SEP;
  }
  file = new File(dir);
  audioFile = new File(audioDir);
  if (file.isDirectory()) {
    String names[] = file.list();
    names = sort(names);
    for (int i = 0; i < names.length; i++) {
      if (names[i].toLowerCase().contains(".jpg")  || 
          names[i].toLowerCase().contains(".jpeg") ||
          names[i].toLowerCase().contains(".tif")  || //only works with Processing tiffs
          names[i].toLowerCase().contains(".png")) {
        tmp.add(dir + names[i]); 
      }
    }
    
    arraySize = tmp.size();

    if (arraySize == 0) {
      println("ERROR: No frames detected, exiting");
      exit();
      return null;
    }

    if (audioFile.isDirectory()) {
      String audioNames[] = audioFile.list();
      if (audioNames != null) {
        audioNames = sort(audioNames);
    
        for (int i = 0; i < audioNames.length; i++) {
          if (audioNames[i].toLowerCase().contains(".wav")) {
            audioTmp.add(audioDir + audioNames[i]);
          }
        }
      } else {
        println("Audio directory " + audioDir + " not found");
      }
    } else {
      println("SOUND string " + audioDir + " does not point to a directory");
    }

    if (audioTmp.size() > 0) {
      HAS_SOUND = true;
      SOUNDTRACK_FILE = audioTmp.get(0);
      println("Using audio file " + SOUNDTRACK_FILE);
    } else {
      println("No audio file detected, creating silent tracks");
    }

    
    if (HAS_SOUND) {
      arraySize += SOUND_OFFSET;
    }
    
    output = new String[arraySize];
    
    if (HAS_SOUND) {
      for (int i = 0; i < SOUND_OFFSET; i++) {
        output[o] = "_BLANK_";
        o++;
      }
    }
    
    for (int i = 0; i < tmp.size(); i++) {
      output[o] = tmp.get(i);
      o++;
    }
    sort(output);
    return output;
  } else {
    println("ERROR: SOURCE variable does not point to a directory");
    exit();
  }
  return null;
}

String leftPad (int val) {
  String str = "" + val;
  if (str.length() == 1) {
    str = "0" + str;
  }
  return str;
}

void renderPages() {
  //surface.setSize(PAGE_W_PIXELS, PAGE_H_PIXELS / SEGMENTS);
  //delay(1000);
  int cursor;
  int leftX;
  int topY;
  int perfLeft;
  int perfRight;
  int perfTop;
  int soundTop;
  int soundLeft;
  boolean hasFrames = false;
  
  frameBlank.beginDraw();
  frameBlank.background(BACKGROUND);
  frameBlank.endDraw();
  
  
  for (int page = 0; page < PAGES; page++) {
    pageBuffer.beginDraw();
    pageBuffer.textSize(60);
    pageBuffer.clear();
    pageBuffer.background(255);
    pageBuffer.stroke(0);
    pageBuffer.noFill();
    //draw calibration marks to be overwritten if needed
    pageBuffer.rect(0, 0, 10 * DPMM, 10 * DPMM);
    pageBuffer.rect(((16 * COLUMNS) * DPMM) - (10 * DPMM) - 1, 0, 10 * DPMM, 10 * DPMM);
    pageBuffer.rect(((16 * COLUMNS) * DPMM) - (10 * DPMM) - 1, ((ROWS * (SPACING / DPMM)) * DPMM) - (10 * DPMM) - 1, 10 * DPMM, 10 * DPMM);
    pageBuffer.rect(0, ((ROWS * (SPACING / DPMM)) * DPMM) - (10 * DPMM) - 1, 10 * DPMM, 10 * DPMM);
    //pageBuffer.stroke(0);
    for (int x = 0; x < COLUMNS; x++) {
      //pageBuffer.line(x * (16 * DPMM), 0, x * (16 * DPMM), PAGE_H_PIXELS);
      for (int y = 0; y < ROWS; y++) {
        cursor = (page * (COLUMNS * ROWS)) + (x * ROWS) + y; 
        if (cursor >= FRAMES) {
          hasFrames = false;
          break;
        }
        hasFrames = true;
        println("Frame " + cursor + "/" + FRAMES);
        
        topY = (y * SPACING) + FRAME_LINE;
        leftX = x * (round(16 * DPMM)) + LEFT_PAD;
        perfTop = round((y * SPACING) - ((PERF_H / 2) * DPMM));
        
        
        // fill background around a frame
        pageBuffer.noStroke();
        pageBuffer.fill(BACKGROUND);
        pageBuffer.rect(x * (round(16 * DPMM)), (y * SPACING), round(16*DPMM), SPACING);
        
        // line on left side of frame (to help lay down film strips onto page)
        pageBuffer.stroke(0);
        pageBuffer.strokeWeight(GUIDELINE_PX);
        pageBuffer.line(x * (round(16 * DPMM)), (y * SPACING), x * (round(16 * DPMM)), (y * SPACING)+ SPACING); // outer line LEFT
        pageBuffer.noStroke();
        
        if (SHOW_PERFS){
          perfLeft = round(x * (round(16 * DPMM)) + (.85 * DPMM));
          pageBuffer.fill(PERFS_COLOR);
          //rect([1.829, 1.27, 2], d = .5, center = true);
          //﻿.85 from side
          pageBuffer.rect(perfLeft, perfTop, PERF_W * DPMM, PERF_H * DPMM, .26 * DPMM);
          
          //last perf
          if (y == ROWS - 1) {
            perfTop = round(((y + 1) * SPACING) - ((PERF_H / 2) * DPMM));
            pageBuffer.rect(perfLeft, perfTop, PERF_W * DPMM, PERF_H * DPMM, .26 * DPMM);
          }
        }
        
        if (SHOW_PERFS && PERFS == 2) {
          perfRight = round((x + 1) * (round(16 * DPMM)) - (PERF_W * DPMM) - (.85 * DPMM));
          pageBuffer.rect(perfRight, perfTop, PERF_W * DPMM, PERF_H * DPMM, .26 * DPMM);
          
          if (y == ROWS - 1) {
            perfTop = round(((y + 1) * SPACING) - ((PERF_H / 2) * DPMM));
            pageBuffer.rect(perfRight, perfTop, PERF_W * DPMM, PERF_H * DPMM, .26 * DPMM);
          }
        }
        
        if (frames[cursor].equals("_BLANK_")) {
          pageBuffer.image(frameBlank, leftX, topY, FRAME_W, FRAME_H);
        } else {
          frameBuffer = loadImage(frames[cursor]);
          if (NEGATIVE) {
            frameBuffer.filter(INVERT);
          }
          frameBuffer.resize(FRAME_W, FRAME_H);
          pageBuffer.image(frameBuffer, leftX, topY, FRAME_W, FRAME_H);
        }
        
        if (HAS_SOUND) {
          soundTop = y * SPACING;
          soundLeft = (x * round(16 * DPMM)) + LEFT_PAD + FRAME_W + round(0.3368 * DPMM);
          try {
            soundBuffer = soundtrack.buffer(cursor);
            if (soundBuffer != null) {
              pageBuffer.image(soundBuffer, soundLeft, soundTop, round((12.52 - 10.26 - 0.3368) * DPMM), SPACING);
            }
          } catch (Error e) {
            //
          }
        }
        if (hasFrames) {
          text((x + 1) + "", (x * 16 * DPMM) + (8 * DPMM), ROWS * SPACING + 20);
        }
      }
    }
  pageBuffer.fill(0);
  pageBuffer.textAlign(RIGHT);
  pageBuffer.textSize(DPI/4);
  pageBuffer.translate(PAGE_W_PIXELS - DPI/8, DPI/8);
  pageBuffer.rotate(radians(270));
  //pageBuffer.text("  INSERT --->", 0, 0);
  if (SHOW_PAGENUM == 1) {
    pageBuffer.text("Page " + (page +1), 0, 0);
  }
  pageBuffer.endDraw();
  // pageBuffer.save(dataPath("page_" + page + ".tif")); // original save method
  // updated saving method that sets file to correct DPI
  // forum.processing.org/two/discussion/27406/set-dpi-on-a-png-when-saving-a-pgraphics
  BufferedImage gridImage = toBufferedImage(pageBuffer.get());
  File output = new File(dataPath("page_" + page + ".png"));
  try {
    saveGridImage(gridImage, output, DPI);
  }
    catch(IOException e) {
    println(e.getMessage());
  }
    println("Saved page_" + dataPath(page + ".tif"));
  }
  printInfo();
  println("Completed");
  exit();
}

// The following functions are required to alter the DPI metadata of the saved output file (because Processing defaults to 72 dpi)
void saveGridImage(BufferedImage gridImage, File output, int dpi) throws IOException {
  String formatName = "png";
  output.delete();
  Iterator<ImageWriter> iw = ImageIO.getImageWritersByFormatName(formatName);
  iw.hasNext();
  ImageWriter writer = iw.next();
  ImageWriteParam writeParam = writer.getDefaultWriteParam();
  ImageTypeSpecifier typeSpecifier = ImageTypeSpecifier.createFromBufferedImageType(BufferedImage.TYPE_INT_RGB);
  IIOMetadata metadata = writer.getDefaultImageMetadata(typeSpecifier, writeParam);
  setDPI(metadata, dpi);
  final ImageOutputStream stream = ImageIO.createImageOutputStream(output);
  try {
    writer.setOutput(stream);
    writer.write(metadata, new IIOImage(gridImage, null, metadata), writeParam);
  } 
  finally {
    writer.dispose();
    stream.flush();
    stream.close();
  }
}

private void setDPI(IIOMetadata metadata, int dpi) throws IIOInvalidTreeException {
  // for PNG, it's dots per millimeter
  float  inch_2_cm = 2.54;
  double dotsPerMilli = 1.0 * dpi / 10 / inch_2_cm;
  IIOMetadataNode horiz = new IIOMetadataNode("HorizontalPixelSize");
  horiz.setAttribute("value", Double.toString(dotsPerMilli));
  IIOMetadataNode vert = new IIOMetadataNode("VerticalPixelSize");
  vert.setAttribute("value", Double.toString(dotsPerMilli));
  IIOMetadataNode dim = new IIOMetadataNode("Dimension");
  dim.appendChild(horiz);
  dim.appendChild(vert);
  IIOMetadataNode root = new IIOMetadataNode("javax_imageio_1.0");
  root.appendChild(dim);
  metadata.mergeTree("javax_imageio_1.0", root);
}

BufferedImage toBufferedImage(PImage img) {
  // Create a buffered image with transparency
  BufferedImage bimage = new BufferedImage(img.width, img.height, BufferedImage.TYPE_INT_ARGB);
  // Draw the image on to the buffered image
  Graphics2D bGr = bimage.createGraphics();
  bGr.drawImage(img.getImage(), 0, 0, null);
  bGr.dispose();
  // Return the buffered image
  return bimage;
}
