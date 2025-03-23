How to Print 16mm Film on a Desktop Inkjet Printer

Zach Poff - Cooper Handmade Cinema Group – March 2025

***Summary****:***

**

Print the included template file onto letter size card stock. Use
double-stick tape to attach strips of clear 16mm film to the template.
Use a video editor to export a video file as individual frames (and
optional audio). Use the filmless-simple Processing sketch to arrange
these files into a page of tiny images that match the template. Load the
template+film into the printer and print again. Wait for it to dry,
carefully remove the film, and splice it together for projection.
Rejoice!

Pros:

- Unique look (very noisy, pixelated, yet organic too)
- Achievable with “home office” tools that most people have access to
- You can even print the soundtrack onto the edge of the film!
- An inexpensive way to make a “camera-less” film (with caveats below)

Cons:

- Time-consuming
- Not very durable (ink will scrape off the film and end up on the side
  rails of the projector). For long-term use, you’ll want to optically
  print this onto “real” film (negating any cost savings)
- Inkjet ink won’t stick to common clear leader. You need leader with
  **emulsion.**  
  (A *laser* printer can print onto any clear film, but color lasers are
  expensive and finicky.)

What you need:

**

Inkjet printer

- Preferably with straight paper path, like the Epson 3880 printers at
  Cooper

Software

- **Adobe Premiere** (or other NLE, for preparing your video file and
  exporting to frames + audio)

- **Adobe Photoshop** (or other image editor, for printing)

- **Processing** (a java-based creative coding platform, to assemble the
  images into filmstrips). Install the **Sound library** (via the
  internal library manager) and the **OpticalSound library** (from
  github)

- **filmless-simple** Processing sketch (based on the **filmless**
  workflow by Matt McWilliams).

Card Stock & Tape

- The card stock will be the carrier sheet for your strips of film.
  Regular paper would work, but a stiffer stock keeps the film flatter
  for best results.

- You need thin double-stick tape (like Scotch #136) to adhere the film
  strips to the template. If you find it too hard to remove the film
  after printing, try Scotch Removable Double Sided Tape #667

Clear Leader

- You need 16mm single-perf clear film leader **with emulsion** so the
  ink has something absorbent to stick to. This is hard to find
  commercially. I recommend fixing and washing short ends of B&W print
  stock, but you may be able to bleach used film too. Regular clear
  leader (without emulsion) is easy to purchase (Urbanski film, etc). It
  will work for laser printers, but **inkjet inks will not dry** when
  applied to it.

**16mm Splicer**

***The Process****:***

**

Start with a video file in Premiere…

- Put your video on a timeline with a 640 x 480 resolution and make sure
  it looks OK.
- Change the frame counter to frames (instead of timecode)
- Trim your video to length: On Cooper’s Epson 3880, each US letter page
  can fit **360 frames** (12x30). If you include an audio file, the
  Processing sketch will add 25 empty frames before the picture starts
  (because 16mm optical sound is 25 frames ahead of the picture it
  matches). So a page with sound holds **335 frames**. (The Processing
  sketch will automatically generate as many pages as your video
  demands, but it’s wise to start with a single page at first.)

<!-- -->

- Export your sequence twice:  
  1) As “Waveform Audio”, with Channels set to Mono  
  Move this file to filmless / data / audio  
  2) As “JPEG” which will create an image sequence of numbered frames  
  Move these files to filmless / data / frames

**In Processing**, use the “filmless_processing_cooper.pde” sketch to
arrange the frames into a printable page (with optical sound). It
automatically grabs audio and frames from the named folders, but you
need to set some variables to make it work:

DPI = 1440;

SOUNDTRACK_TYPE = "unilateral";

PITCH = "long";

FORMAT = "16mm";

PERFS = 1;

PAGE_W = 8.5;

AGE_H = 11.0;

SAFE_W = .25;

SAFE_H = 1.0;

BACKGROUND = color(255);

GUIDELINE_PX = 0;

NEGATIVE = false;

SHOW_PERFS = true;

PERFS_COLOR = color(255);

SOUND_OFFSET = 25;

For printing a *template* rather than real frames, load 360 empty files
and update these variables:  
*(For the Cooper workshop, this has already been done)*

BACKGROUND = color(175); // This makes the non-image areas of the film
grey, which will help you position the film strips on the paper

GUIDELINE_PX = 16; // This draws vertical lines to help you position the
film strips on the paper

Click the arrow (“play button”) to run the script. A black window will
open with some stats. Wait for it to close and locate the page file in
the data folder: “**page_0.png**”

**Print your template: **In Photoshop, open the page file and print it
onto your card stock:

- Turn on the Epson 3880 printer and wait for it to prime
- Press the area with 3 dots to open the manual feed tray. (Before
  printing, it will pull the paper in, then eject it back toward you
  after printing.)
- Follow the LCD display to load paper (aligned with front edge).
- Print the page, using these specific settings:  
  Select the EPSON Stylus Pro 3880 printer and click “Print Settings…”  
  In the popup, select:  
  Paper Size: US Letter (Manual – Front)  
  Printer Settings:  
  Media Type: Enhanced Matte Paper  
  Resolution: SuperPhoto – 1440 dpi  
  Finest Detail: ON  
  Advanced Media Control:  
  All sliders in the middle  
  Paper Thickness: 5  
  Platen Gap: Auto  
  Color Handling: Photoshop Manages Colors  
  Printer Profile: Epson … 3880 Enhanced Matte Paper  
  Scale: 100%

**Assemble your page: **

- Attach 3 horizontal strips of double-stick tape to your template page:
  One above the frames, one below, and one in the middle.
- Some tape is too sticky to remove easily, so rub your fingers on the
  sticky surface to reduce adhesion.
- Identify which side of your clear leader has emulsion. There are
  several ways, but my favorite is to rub my thumb on the film and
  listen: One side will sound more “rough” than the other. That’s the
  emulsion.
- Carefully lay the film on the page, matching the printed guides. Cut
  each strip longer than the printed frames, almost to the edge of the
  paper.
- Check the page for flatness before you print. The film strips must not
  overlap!

**Print your frames: **

- In Photoshop, follow the same steps as before to print onto your page
  of film.
- Wait at least 10 minutes for the film to dry. You’ll get better
  results if you let it dry longer.
- Carefully peel the film from the card stock, splicing it together as
  you go. One page will make a nice loop if you splice it end-to-end, or
  you can make several smaller loops.

**Showtime! **

- The film should run OK in the projector, but the many splices will
  jump, and ink will eventually be deposited in the projector gate. Be
  sure to clean the projector afterward!