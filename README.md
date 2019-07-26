# VideoAudio_Test

### Introduction
This paper tries to solve the mismatch (as in Fig.1) between training objective function and evaluation metrics which are usually highly correlated to human perception. Due to the inconsistency, there is no guarantee that the trained model can provide optimal performance in applications. In this study, we propose an end-to-end utterance-based speech enhancement framework using fully convolutional neural networks (FCN) to reduce the gap between the model optimization and the evaluation criterion. Because of the utterance-based optimization, temporal correlation information of long speech segments, or even at the entire utterance level, can be considered to directly optimize perception-based objective functions.

To download full audio-video data, please click here [data](https://drive.google.com/drive/folders/1iycJkD47wdJO9xw48ChR4g4cCmDnH4Iu?usp=sharing).

### Major Contribution
1) Utterance-based waveform enhancement
2) Direct short-time objective intelligibility (STOI) score optimization (without any approximation)


For more details and evaluation results, please check out our  [paper](https://ieeexplore.ieee.org/document/8331910).

![teaser](https://github.com/JasonSWFu/End-to-end-waveform-utterance-enhancement/blob/master/images/Fig1_3.png)




### Citation
If you find the code useful in your research, please cite:
      
    
### Contact

e-mail: uglyfish38@gmail.com or d04922007@ntu.edu.tw

