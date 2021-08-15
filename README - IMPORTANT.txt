A proposed algorithm that recognizes and transliterates Baybayin scripts in a block text image.

NOTE: The full system files (Example images, classifier, etc.) described here can be downloaded in Release section. Its source filename is Automatic.Transliterations.of.Baybayin.Texts.using.Block-Level.OCR.zip. The following link provides the complete system file page:

https://github.com/rbp0803/Automatic-Transliterations-of-Baybayin-Texts-using-Block-Level-OCR/releases/tag/v1.0

The given codes and variables are produced entirely in MATLAB whose functions or uses are describe below:

Variables

Multi-SVM classifiers
• Baybayin_Character_Classifier_00379.mat - for classification of Baybayin Characters

Binary SVM classifiers
• LvsB_classifier_00125.mat - for discriminating the characters of Baybayin from the letters of Latin
• Subscript_Classifier_00006.mat - for discriminating Baybayin diacritics below the (consonant) character
• Superscript_Classifier_00000.mat - for discriminating Baybayin diacritics above the (consonant) character

Binary classifiers which will be used for reclassification of confusive Baybayin characters
• AVSMa_00225.mat
• KaVSEI_00100.mat
• HaVSSa_00050.mat
• LaVSTa_00100.mat
• PaVSYa_00550.mat
(Note: smile.mat does not have any function. It is just there to uphold the sequence of the confuselist.)

Function Codes/Scripts

-The Baybayin and Latin Script Recognition System-
• Baybayin_identifier.m - contains the script of the main system and has subfunctions that supports the word script recognition and Baybayin transliteration algorithm.
• c2bw.m - a subfunction from the Baybayin and Latin Script Recognition System (Baybayin_identifier.m) for converting the input rgb image into binary
           data using the modified kmeans function.
• kmeans_mod.m - a subfunction from the Baybayin and Latin Script Recognition System (Baybayin_identifier.m) for clustering a grayscaled image into 2 intensities intended for image binarization.
• part_of_the_character_finder.m - a subfunction from the Baybayin and Latin Script Recognition System (Baybayin_identifier.m) for determining the components of a Baybayin character which will further hints us the true number of Baybayin characters from the input Baybayin word.
• LVSB.m - a subfunction from the Baybayin and Latin Script Recognition System (Baybayin_identifier.m) for discriminating Baybayin from Latin at character level.                                  
• feature_vector_extractor.m - a subfunction from the Baybayin and Latin character classifier function (LVSB.m) that outputs the 1x3136 feature 
                               vector array of the of the input square matrix.
• permn.m - a combinatorial algorithm that is used to take the right combination in Baybayin transliteration's image allocation.

-The Baybayin Word Reader System-
• Baybayin_word_reader.m - contains the script of the Baybayin word transliteration system and has subfunctions that supports the recognition algorithm.
• Baybayin_only_accentor.m - subfunction from the Baybayin Word Reader System (Baybayin_word_reader.m) for extracting respective equivalent syllables
                             from the converted Baybayin word.
• change_QWE.m - a subfunction from the Baybayin Word Reader System (Baybayin_word_reader.m) for determining the number of syllables with                          
                 letter 'd' and their respective location in the word.
• change_QWE_process2_m2.m - a subfunction from the Baybayin Word Reader System (Baybayin_word_reader.m) for generating other words with syllables
                             'de', 'di', 'do', or 'du' which are combine or interchange with 're', 'ri', 'ro', or 'ru', respectively. This 
                             subfunction applies to the 2-character case of Baybayin word.
• change_QWE_process2_m3.m - a subfunction from the Baybayin Word Reader System (Baybayin_word_reader.m) that executes similar to
                             change_QWE_process2_m2.m function but this applies to the 3-character case of Baybayin word.
• change_QWE_process2_m4.m - a subfunction from the Baybayin Word Reader System (Baybayin_word_reader.m) that executes similar to
                             change_QWE_process2_m2.m and change_QWE_process2_m3.m functions but this function applies if the Baybayin word has       
                             four (4) or more characters.
• first_loop_new.m - a subfunction from the Baybayin Word Reader System (Baybayin_word_reader.m) that is responsible for generating all the
                     possible vowel combinations 'e'/'i' or 'o'/'u' for four or more Baybayin characters.
• part_of_the_character_finder.m - a subfunction from the Baybayin Word Reader System (Baybayin_word_reader.m) for determining the components of a 
                                   Baybayin character which will further hints us the true number of Baybayin characters from the input Baybayin word.
• permn.m - a combinatorial algorithm that is used to take the right combination in syllable alteration.
• word_search_sample.m - a subfunction from the Baybayin Word Reader System (Baybayin_word_reader.m) that determines the legitimacy of the generated
                         Latin word through searching its availability in the database or dictionary.

-The Baybayin SVM-OCR System-
• Baybayin_only.m - a subfunction from the Baybayin Word Reader System (Baybayin_word_reader.m) named BAYBAYIN SVM-OCR SYSTEM that outputs the                                    equivalent Latin unit of each Baybayin character. This function contains subfunctions provided below.
• feature_vector_extractor.m - a subfunction from the Baybayin SVM-OCR System (Baybayin_only.m) that outputs the 1x3136 feature vector array of the 
                               input square matrix. 
• Baybayin_letter_revised_segueway_Baybayin_only.m - a subfunction from the Baybayin SVM-OCR System (Baybayin_only.m) for classifying one component   
                                                     Baybayin characters.
• seg_Baybayin_only_vowel_distinctor.m - a subfunction from the Baybayin SVM-OCR System (Baybayin_only.m) for classifying Baybayin characters with                                                     diacritics.                   
• seg2_Baybayin_only_vowel_distinctor.m - a subfunction from the Baybayin OCR System (Baybayin_only.m) that is intentionally made to recognize the 
                                          Baybayin character 'E/I'. Otherwise, the algorithm is designed to find if the other components are part 
                                          of the main body.



A Sample Run
Example_run_Baybayin_and_Latin_Script_Recognition_System.m contains a script that executes the proposed Baybayin and Latin script recognition system. '1 Baybayin text.PNG', '2 Latin text.PNG', '3 Figure5 Sample.PNG', '4 Example1.PNG', '5 Example2.PNG', '6 Example3.PNG', and '7 Doctrina Christiana Page.PNG' are the sample images.

Tagalog Words Dictionary (Database)
'Tagalog_words_74419+.xlsx' is a spreadsheet file that contains 74000+ Tagalog words (and some default phrases) collected from publicly available Tagalog word archives in the internet.

Acknowledgement
We would like to acknowledge the implementation of an external MATLAB function ( permn ):

Jos (10584) (2019, January 19). permn, MATLAB Central File Exchange. Retrieved from: https://www.mathworks.com/matlabcentral/fileexchange/7147-permn