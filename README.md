# Y86 Program Optimization

## Goal
The goal was to optimize instructions such that the cost of CPU cycles would be reduced by:
- at least 50% on average for PIPE With Stalling
- at least 45% on average for PIPE With Forwarding and Branch Prediction
.

## Demo video
A short video (1m 45s) showing the effect of the optimization in action:

https://github.com/user-attachments/assets/9d014763-34e8-4734-a5e7-d1db23193795

.

Summary of the video: For a general case instance to sort an array with 13 elements, CPU cycles reduction is about 50% for PIPE With Stalling, 50% for PIPE With Forwarding and Branch Prediction. Generally reduction percentage for PIPE With Forwarding and Branch Prediction was expected to be lower than 50%. There are other tests not shown in this video (some are also not in this repo). 
