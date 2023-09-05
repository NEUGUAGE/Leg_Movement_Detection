# Leg_Movement_Detection
function("your file_name",1 or 0: 1 indicate you wanna a annotated video to manually check the correctness)

paramter can be changed between 3.5-4 to ensure a quality of indicating,if too much false positive try turn up the parameter, vice versa.

The function export an array with 1x time frame column, and 1 indicates there is a leg movement, and 0 indicates there is not.

#To do:
1. try to detect the gamma of original video and correlates with threshold parameter, so it can be automatically adjust to avoid detection variation because of light change
