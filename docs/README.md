# How to Print 16mm Film on a Desktop Inkjet Printer #

_Zach Poff - [Cooper Union Handmade Cinema Group](https://handmadecinema.cooper.edu/) – March 2025_

**This is a complete guide to digitally printing 16mm films using a common inkjet printer, using the [filmless-simple](https://github.com/z-l-p/filmless-simple) workflow. It was written to support a workshop at Cooper Union for the Advancement of Science and Art, but the basic workflow would be the same anywhere**

Before you start, be aware of what this medium does (and doesn't do) compared to other moving-image techniques:

**Pros:**

- Unique look (very noisy, pixelated, yet organic too)
- Achievable with “home office” tools that most people have access to
- You can even print the soundtrack onto the edge of the film!
- An inexpensive way to make a “camera-less” film (with caveats below)

**Cons:**

- It's not really a technique to make "desktop" films using tools you already have. It requires certain film-specific materials (special 16mm leader, splicer, projector) in addition to a computer & printer.
- It's time-consuming and laborious (which is part of the charm)
- Not very durable (ink will scrape off the film and end up on the side
  rails of the projector). For long-term use, you’ll want to optically
  print this onto “real” film (negating any cost savings)
- Inkjet ink won’t stick to common clear leader. You need leader with
  **emulsion.**  
  (A *laser* printer can print onto any clear film, but color lasers are
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

- You need 16mm single-perf clear film leader **with emulsion** so the
  ink has something absorbent to stick to. This is hard to find
  commercially. I recommend fixing and washing short ends of B&W print
  stock, but you may be able to bleach used film too. Regular clear
  leader (without emulsion) is easy to purchase (Urbanski film, etc). It
  will work for laser printers, but **inkjet inks will not dry** when
  applied to it.

### 16mm Splicer ### 

- Don't bother trying to use scissors and tape. You need a legit splicer.

# The Process #

**Start with a video file in Premiere…**

- Put your video on a timeline with a 640 x 480 resolution and make sure
  it looks OK.
- Change the frame counter to frames (instead of timecode)
- Trim your video to length: On an Epson 3880, each US letter page
  can fit **360 frames** (12x30). If you include an audio file, the
  Processing sketch will add 25 empty frames before the picture starts
  (because 16mm optical sound is 25 frames ahead of the picture it
  matches). So a page with sound holds **335 frames**. (The Processing
  sketch will automatically generate as many pages as your video
  demands, but it’s wise to start with a single page at first.)
- Export your sequence twice:  
  - As “Waveform Audio”, with Channels set to Mono  
  Move this file to filmless_simple / data / audio  
  - As “JPEG” which will create an image sequence of numbered frames. _(Don't export as .TIFF files because Processing won't be able to open them in the next step.)_
  Move these files to filmless_simple / data / frames

**In Processing**, use the “filmless_simnple.pde” sketch to
arrange the frames into a printable page (with optical sound). It
automatically grabs files from the **audio** and **frames** folders that you prepared in the previous step. 

You don't need to mess with any of the variables in the script. Just click the arrow (“play button”) to run the script. A black window will open with some stats. Wait for it to close and locate the page file in
the filmless_simple/data/ folder: “**page_0.png**”

**Print your template:** In Photoshop, open the page file and print it
onto your card stock:

- Turn on the Epson 3880 printer and wait for it to prime
- Press the area with 3 dots to open the manual feed tray. (Before
  printing, it will pull the paper in, then eject it back toward you
  after printing.)
- IMPORTANT: Draw an arrow on the front edge of the paper before you insert it. (You'll use this mark later to make sure the paper is inserted the right way for the second printing pass. 
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

**Assemble Your Page:**

- Attach 3 horizontal strips of double-stick tape to your printed template page:
  One above the frames, one below, and one in the middle. (Some tape is too sticky to remove easily, so rub your fingers on the sticky surface to reduce adhesion.)
- Identify which side of your clear leader has emulsion. There are several ways, but my favorite is to rub my thumb on the film and listen: One side will sound more “rough” than the other. That’s the emulsion.
- Carefully lay the film on the page, matching the printed guides. Cut each strip longer than the printed frames, almost to the edge of the paper. (You'll need a few un-printed frames during splicing.)
- Check the page for flatness before you print. The film strips must not overlap!

**Print Your Frames:**

- In Photoshop, follow the same steps as before to print onto your page
  of film.
- Wait at least 10 minutes for the film to dry. You’ll get better results if you let it dry longer.
- Carefully peel the film from the card stock, splicing it together as you go. One page will make a nice loop if you splice it end-to-end, or you can make several smaller loops.

**Showtime!**

- The film should run OK in the projector, but the many splices will
  jump, and ink will eventually be deposited in the projector gate. Be
  sure to clean the projector afterward!

### Troubleshooting ###

- **Processing Error: "ArrayIndexOutOfBoundsException .... "** means that your sound file is stereo. Try again with a mono file.
- **The ink won't dry!** If the ink is pooling on the film surface, you're printing on the base side of the film. Turn it over to print on the emulsion side.
- **Empty frames at the start:** This is caused by the standard 25 frame sound offset of 16mm film. Since sound precedes picture, the code adds blank frames before the picture starts. If you don't mind a silent first second of picture, you can cut it off. If you're making a loop then you can get tricky: In Premiere, unlock your picture and sound. Shift the sound 25 frames earlier than picture. Cut the sound to separate the first 25 frames and move them to the end, filling the gap left over from the shift. Then set the SOUND_OFFSET variable in Processing to 0. The resulting film can be spliced into a loop with continuous sound and picture. 
