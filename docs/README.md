# How to Print 16mm Film on a Desktop Inkjet Printer #

_Zach Poff - [Cooper Union Handmade Cinema Group](https://handmadecinema.cooper.edu/) – March 2025_

**This is a complete guide to digitally printing 16mm films using a common inkjet printer, using the [filmless-simple](https://github.com/z-l-p/filmless-simple) workflow. It was written to support a workshop at Cooper Union for the Advancement of Science and Art, but the basic workflow would be the same anywhere**

Before you start, be aware of what this medium does (and doesn't do) compared to other moving-image techniques:

**Pros:**

- Unique look (very noisy, pixelated, yet organic too)
- Achievable with (mostly) “home office” tools that most people have access to
- You can even print the soundtrack onto the edge of the film!
- An inexpensive way to make a “camera-less” film (with caveats below)

**Cons:**

- It's not really a technique to make "desktop" films using tools you already have. It requires certain film-specific materials (special 16mm leader, splicer, projector) in addition to a computer & printer.
- It's time-consuming and laborious (which is part of the charm)
- Not very durable (ink will scrape off the film and end up on the side
  rails of the projector). For long-term use, you’ll want to optically
  print this onto “real” film (negating any cost savings)
- Inkjet ink won’t stick to common clear leader. You need **leader with
  emulsion.**  
  (A *laser* printer can print onto any clear film, but color laser printers are
  expensive and finicky.)


# What you need: #

### Inkjet printer ###

- Preferably with straight paper path (like the Epson 3880 printers at
  Cooper Union)

### Software ### 

See [software links in the main README file](https://github.com/z-l-p/filmless-simple?tab=readme-ov-file#dependencies)

- **Adobe Premiere** (or other NLE, for preparing your video file and
  exporting to frames + audio)

- **Adobe Photoshop** (or other image editor, for printing)

- **Processing** (a java-based creative coding platform, to assemble the
  images into filmstrips). Install the **Sound library** (via the
  internal library manager) and the **OpticalSound library** (from
  github)

- **filmless_simple.pde** Processing sketch in this repo (based on the **[filmless](https://sixteenmillimeter.com/projects/filmless/)**
  workflow by Matt McWilliams).

### Card Stock & Tape ### 

- The card stock will be the carrier sheet for your strips of film.
  Regular paper would work, but a stiffer stock keeps the film flatter
  for best results.

- You need thin double-stick tape (like Scotch #136) to adhere the film
  strips to the template. If you find it too hard to remove the film
  after printing, try Scotch Removable Double Sided Tape #667

### Clear Leader ### 

- You need single-perf 16mm clear film leader **with emulsion** so the
  ink has something absorbent to stick to. This is hard to find
  commercially. I recommend fixing and washing short ends of B&W print
  stock, but you may be able to bleach used film too. 
Regular clear
  leader (without emulsion) is easy to purchase (Urbanski film, etc). It
  will work for laser printers, but **inkjet inks will not dry** when
  applied to it.

### 16mm Splicer ### 

- Don't bother trying to use scissors and tape. You need a legit splicer.

# The Process #

### Start with a video file in Premiere ###

- Put your video on a timeline with a 640 x 480 resolution and make sure
  it looks OK.
- Change the frame counter to frames (instead of timecode)
- Trim your video to length: On an Epson 3880, each US letter page
  can fit **360 frames** (12x30). If you include an audio file, the
  Processing sketch will add 25 empty frames before the picture starts
  (because 16mm optical sound is 25 frames ahead of the picture it
  matches). So the first page with sound holds **335 frames**. (See the Troubleshooting section for more details.)
  The Processing sketch will automatically generate as many pages as your video
  demands, but it’s wise to start with a single page at first.
- Export your sequence twice:  
  - As “Waveform Audio”, with Channels set to Mono  
  - - Move this file to **filmless_simple / data / audio**  
  - As “JPEG” which will create an image sequence of numbered frames. _(Don't export as .TIFF files because Processing won't be able to open them in the next step.)_
  - - Move these files to **filmless_simple / data / frames**

### In Processing ###
- Use the “filmless_simple.pde” sketch to
arrange the frames into a printable page (with optical sound). It
automatically grabs files from the **audio** and **frames** folders that you prepared in the previous step.
- You don't need to mess with any of the variables in the script. Just click the arrow (“play button”) to run the script. A black window will open with some stats. Wait for it to close and locate the page file in
the filmless_simple/data/ folder: “**page_0.png**”. (Feel free to rename to something more meaningful.)

### Print your template ### 
In Photoshop, open the page file that you generated. Then print it onto your card stock. (There is a template file in the main folder of this repo, so you can print that instead if your Processing variables match the defaults.)

- Turn on the Epson 3880 printer and wait for it to prime
- Press the area with 3 dots to open the manual feed tray. (Before
  printing, it will pull the paper in, then eject it back toward you
  after printing.)
- **IMPORTANT: Draw an arrow on the front edge of the paper before you insert it. (You'll use this mark later to make sure the paper is inserted the right way for the second printing pass.**
- Follow the LCD display to load paper (aligned with front edge).
- Print the page, using these specific settings:  
  Select the EPSON Stylus Pro 3880 printer and click “Print Settings…”  
  In the popup, select:  
  Paper Size: US Letter (Manual – Front)  
  Printer Settings:  
  Media Type: Enhanced Matte Paper (Double-check this. Sometimes it changes randomly!)
  Resolution: SuperPhoto – 1440 dpi  
  Finest Detail: ON  
  Advanced Media Control:  
  All sliders set to "0"  
  Paper Thickness: 4  
  Platen Gap: Auto  
  Color Handling: Photoshop Manages Colors  
  Printer Profile: Epson … 3880 Enhanced Matte Paper  
  Scale: 100%

### Assemble Your Page ###

- Attach 3 horizontal strips of double-stick tape to your printed template page:
  One above the frames, one below, and one in the middle. (Some tape is too sticky to remove easily, so rub your fingers on the sticky surface to reduce adhesion.)
- Identify which side of your clear leader has emulsion. There are several ways, but my favorite is to rub my thumb on the film and listen: One side will sound more “rough” than the other. That’s the emulsion.
- Carefully lay the film on the page, matching the printed guides. Cut each strip longer than the printed frames, almost to the edge of the paper. (You'll need a few un-printed frames during splicing.)
- Check the page for flatness before you print. The film strips must not overlap!

### Print Your Frames ### 

- In Photoshop, follow the same steps as before to print onto your page
  of film.
- Wait at least 10 minutes for the film to dry. You’ll get better results if you let it dry longer.
- Carefully peel the film from the card stock, splicing it together as you go. One page will make a nice loop if you splice it end-to-end, or you can make several smaller loops.

### Showtime! ###

- The film should run OK in the projector, but the many splices will
  jump, and ink will eventually be deposited in the projector gate. Be
  sure to clean the projector afterward!

# Troubleshooting #

- **Processing Error: "ArrayIndexOutOfBoundsException .... "** means that your sound file is stereo. Try again with a mono file.
- **The ink won't dry!** If the ink is pooling on the film surface, you're printing on the base side of the film. Turn it over to print on the emulsion side.
- **Empty frames at the start:** This is caused by the standard 25 frame sound offset of 16mm film. Since sound precedes picture, the code adds blank frames before the picture starts. If you don't mind a silent first second of picture, you can cut it off. If you're making a loop then you can get tricky: In Premiere, unlock your picture and sound. Shift the sound 25 frames earlier than picture. Cut the sound to separate the first 25 frames and move them to the end, filling the gap left over from the shift. Then set the SOUND_OFFSET variable in Processing to 0. The resulting film can be spliced into a loop with continuous sound and picture.
- **The print doesn't line up exactly with the film!** It will never be 100%, but there is a way to calibrate the print size to match your film. First you need to check if your film is "short pitch" (most camera stocks) or "long pitch" (most print stocks) and adjust the Processing "PITCH" variable accordingly. If you need further adjustment, adjust the MAGIC_H_CORRECTION and MAGIC_W_CORRECTION variables. (see below)

# Processing Variables #
There are variables at the beginning of the Processing sketch that you can change. **They are pre-set to sensible defaults** so you probably don't need to change them.

```java
int DPI = 1440;
```

The DPI is the target for printing. The maximum DPI you'll be able to print is dependent on your printer or image reproduction technology. The higher the DPI, the higher the theoretical resolution of your output. This variable will also determine your sound quality, as you will only be able to reproduce the number of samples the vertical resolution allows. If your printer can only draw 10,000 lines in 24 frames, your sample rate will effectively be 10Khz.

```java
String SOUNDTRACK_TYPE = "unilateral";
```

The soundtrack type refers to the style of soundtrack that's produced by the sketch. The soundtrack is produced using [SoundtrackOptical](https://github.com/sixteenmillimeter/SoundtrackOptical) and the options are `unilateral`, `variable area`, `dual variable area`, `maurer`, `variable density`. Read more about these different types [here](http://www.paulivester.com/films/filmstock/guide.htm).

```java
String PITCH = "long";
```

The pitch of the film refers to the distance between the perforations. Long pitch films are generally projection films, while short pitch films are for cameras. If you plan on contact printing your generated film, you should change the variable to `short`.

```java
String FORMAT = "16mm";
```

`FORMAT` refers to the image format that your film strips will use. Either `16mm` for standard 16mm or `super16` for Super16.

Keep in mind: This sketch will scale your video frames to fit the size of the film frames. If you choose a standard 16mm format any frames provided to the script will be scaled to a ~4:3 aspect ratio. If you provide 1080P frames, they will be squashed from 16:9 to the square-ish 4:3 ratio. Conversely, if you choose the super16 format using `String FORMAT = "super16";` your 4:3 frames will be stretched to 1.66:1. 

Another thing to note: Super16 and soundtracks occupy the same space on the filmstrip and the script will throw an error if you try to include both audio and a Super16 image format.

```java
int PERFS = 1;
```

Refers to the number of perforations that will be printed as guides for your film. Can be either `1` or `2`. Similar to the conflict between Super16 and soundtracks, the second perforation on "double perf" film strips will occupy the same area that soundtracks and Super16 images do.

```java
float PAGE_W = 8.5;
float PAGE_H = 11.0;
float SAFE_W = .25;
float SAFE_H = 1.0;
```

Change these only when printing on larger format sheets than standard US letter stock. The "SAFE_" variables refer to the areas on both sides of the width or height of the sheet which will not be printed on. Changing these to higher values will reduce the maximum amount of frames that are able to be printed on a single sheet.

Using these default settings the script will generate 12 strips of 30 frames each, totally 360 frames per page.

```java
color BACKGROUND = color(255);
```
The color that will fill the entire frame where there's no image or soundtrack data. The `color()` method will accept grey values from `0` (black) to `255` (white) or will accept 8-bit RGB color values like `color(255, 0, 0)` (red), `color(0, 255, 0)` (green), `color(0, 0, 255)` (blue) or anything in between those values.

Note that the edges of film are under more pressure than the image area, so it's a good idea to avoid printing there. Setting the background to "clear" (255) keeps ink off of the edges where it will get abraded by friction.

```java
int GUIDELINE_PX = 16;
```

The pixel width of the vertical guidelines between strips of film (set to 0 to disable)

```java
int SHOW_PAGENUM = 0;
```

Set to 1 to print page numbers (leave it off for printing the template, to leave room for the page numbers to be overprinted later)

```java
boolean NEGATIVE = false;
```

Change this value from `false` to `true` to invert the colors of your images. Use this for contact printing or other experimental uses. Keep in mind: this will not perform the orange color mask inversion needed for color contact printing but will naively invert all color values.

```java
boolean SHOW_PERFS = true;
```

Set to `true` to print perfs for cutting registration. Set to `false` to print nothing.

```java
color PERFS_COLOR = color(255);
```

Set the color of the perforations, similar to `BACKGROUND`. By default, they will be drawn white.

```java
int SOUND_OFFSET = 25;
```

The sound offset is the number of frames before the image starts after the soundtrack starts. When set to `25` the image will start on the 26th frame, which is the standard for 16mm prints. Change this only if sync sound is not important.

```java
MAGIC_W_CORRECTION = 1.0;
MAGIC_H_CORRECTION = 1.0;
```

These allow fine control of the image scale in the width and height dimensions. Adjust them if your print doesn't match your film. See the [original filmless docs](https://github.com/sixteenmillimeter/filmless?tab=readme-ov-file#calibration) for details.
