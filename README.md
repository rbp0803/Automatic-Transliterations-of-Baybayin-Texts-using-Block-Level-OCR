# Extracting-Baybayin-and-Latin-Words-on-Images-using-Support-Vector-Machine

A proposed algorithm to recognize Baybayin script from Latin at a block level in a text image.

<b> NOTE: The system files (Example images, classifier, etc.) described here can also be downloaded in Release section. Its source filename is `Extracting.Baybayin.and.Latin.Words.on.Images.using.Support.Vector.Machine.zip
`. The following link provides the complete system file page:
  
https://github.com/rbp0803/Baybayin-and-Latin-Script-Recognition-System/releases/tag/v1.0
</b>

The given codes and variables are produced entirely in MATLAB whose functions or uses are describe below:

## Variables

```
Binary SVM Classifier
• LvsB_classifier_00125.mat - for discriminating the characters of Baybayin from the letters of Latin
```

## Function Codes/Scripts
### The Baybayin and Latin Script Recognition System
```
• Baybayin_identifier.m - contains the script of the main system and has subfunction that supports the word recognition algorithm.
• c2bw.m - a subfunction from the Baybayin and Latin Script Recognition System (Baybayin_identifier.m) for converting the input rgb image into binary
           data using the modified kmeans function.
• kmeans_mod.m - a subfunction from the Baybayin and Latin Script Recognition System (Baybayin_identifier.m) for clustering a grayscaled image into 2 intensities 
                 intended for image binarization.
• part_of_the_character_finder.m - a subfunction from the Baybayin and Latin Script Recognition System (Baybayin_identifier.m) for determining the components of a 
                                   Baybayin character which will further hints us the true number of Baybayin characters from the input Baybayin word.
• LVSB.m - a subfunction from the Baybayin and Latin Script Recognition System (Baybayin_identifier.m) for discriminating Baybayin from Latin at character level.                                  
• feature_vector_extractor.m - a subfunction from the Baybayin and Latin character classifier function (LVSB.m) that outputs the 1x3136 feature 
                               vector array of the of the input square matrix.
```

## A Sample Run

`Example_run_Baybayin_and_Latin_Script_Recognition_System.m` contains a script that executes the proposed Baybayin and Latin script recognition system. `Example1.PNG`, `Example2.PNG`, `Example3.PNG`, and `Doctrina Christiana Page.PNG` are the sample images.

## Acknowledgement

We would like to acknowledge the following sources for the acquisition of the sample images:

1. Babao R. M. (2020, December 24). What You Though About Baybayin May be Wrong [Blog]. Retrieve from: https://www.modernfilipina.ph/lifestyle/culture/baybayin
