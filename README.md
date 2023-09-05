# Leg_Movement_Detection
function("your file_name",1 or 0: 1 indicate you wanna a annotated video to manually check the correctness)

paramter can be changed between 2.5-3.5 to ensure a quality of indicating,if too much false positive try turn down the parameter, vice versa.

The function export a array with 1x time frame column, and 1 indicate there is a leg movement, and 0 indicate there is not.

#To do:
1. try to detect the gamma of original video and correlates with threshold parameter, so it can be automatically adjust to avoid detection variation because of light change