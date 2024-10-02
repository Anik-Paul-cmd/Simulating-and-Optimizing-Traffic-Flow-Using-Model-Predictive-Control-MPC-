# Simulating and Optimizing Traffic Flow Using Model Predictive Control (MPC)

This project simulates traffic flow at intersections using MATLAB and optimizes the traffic light timings with **Model Predictive Control (MPC)** to reduce congestion. The simulation includes random traffic arrival rates and tracks waiting times at the intersections.

In this project, we:
- Simulate traffic flow at two intersections for North-South (NS) and East-West (EW) directions.
- Use Model Predictive Control (MPC) to adjust traffic light timings in real-time based on predicted traffic.
- Include random variations in the number of cars arriving at each intersection.
- Track average waiting times and display real-time metrics.

## Features

- **Multiple Intersections**: Simulates traffic at two intersections with both NS and EW traffic.
- **Random Traffic Arrival**: Adds randomness to car arrivals to mimic real-world traffic conditions.
- **Dynamic Traffic Light Control**: Changes traffic light timings based on current traffic to reduce queues.
- **Performance Monitoring**: Tracks and displays average waiting times for both NS and EW traffic.

## Example Outputs
**North-South Queue Length at Intersections and East-West Queue Length at Intersections**
![intersection](https://github.com/user-attachments/assets/54672671-2cd6-4bda-aa8f-01fb4a17d41c)

## Example waiting time output:
Average Waiting Time (NS): 23.54
Average Waiting Time (EW): 21.78

## Future Improvements
Improve the MPC algorithm with MATLAB's optimization toolbox. Use real-time traffic data from sensors to make better predictions.
