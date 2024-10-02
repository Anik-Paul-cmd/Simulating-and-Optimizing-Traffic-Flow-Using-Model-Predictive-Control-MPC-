%% Initialization
clc;
clear;

% Simulation parameters
num_intersections = 2; % Number of intersections in the system
simulation_time = 200; % Simulation time (number of steps)
cycle_time = 10;       % Total traffic light cycle time

% Traffic arrival and departure rates (with randomness)
arrival_rate_ns_base = 10; % Base arrival rate for North-South
arrival_rate_ew_base = 15; % Base arrival rate for East-West
departure_rate = 20;       % Departure rate when the light is green

% Initialize queue lengths for multiple intersections
queue_ns = zeros(num_intersections, 1);
queue_ew = zeros(num_intersections, 1);

% Arrays to store the queue lengths for visualization
queue_history_ns = zeros(simulation_time, num_intersections);
queue_history_ew = zeros(simulation_time, num_intersections);

% MPC parameters
prediction_horizon = 5;  % Prediction horizon (how far ahead we predict)
control_horizon = 2;     % Control horizon (how long we apply the control)
green_ns = repmat(cycle_time / 2, num_intersections, 1); % Initial green light time for NS
green_ew = repmat(cycle_time / 2, num_intersections, 1); % Initial green light time for EW

% Metrics for monitoring system performance
total_waiting_time_ns = 0;
total_waiting_time_ew = 0;

%% Simulate traffic flow with MPC control for multiple intersections
for t = 1:simulation_time
    % Introduce randomness in the arrival rate (stochastic traffic flow)
    arrival_rate_ns = arrival_rate_ns_base + randi([-2, 2], num_intersections, 1);  % Random noise
    arrival_rate_ew = arrival_rate_ew_base + randi([-2, 2], num_intersections, 1);  % Random noise
    
    % Update queue lengths based on car arrivals
    queue_ns = queue_ns + arrival_rate_ns;
    queue_ew = queue_ew + arrival_rate_ew;
    
    % Predict future queue lengths over the prediction horizon for all intersections
    future_queue_ns = queue_ns + arrival_rate_ns * prediction_horizon;
    future_queue_ew = queue_ew + arrival_rate_ew * prediction_horizon;
    
    % Dynamic traffic light control based on predicted queues
    for i = 1:num_intersections
        if future_queue_ns(i) > future_queue_ew(i)
            % Give more green light to NS direction at this intersection
            green_ns(i) = min(green_ns(i) + 1, cycle_time - green_ew(i));
            green_ew(i) = cycle_time - green_ns(i);  % Adjust EW green light accordingly
        else
            % Give more green light to EW direction at this intersection
            green_ew(i) = min(green_ew(i) + 1, cycle_time - green_ns(i));
            green_ns(i) = cycle_time - green_ew(i);  % Adjust NS green light accordingly
        end
    end
    
    % Update queue lengths based on car departures (only when green light is on)
    queue_ns = max(queue_ns - (green_ns / cycle_time) * departure_rate, 0);  % Departures in NS
    queue_ew = max(queue_ew - (green_ew / cycle_time) * departure_rate, 0);  % Departures in EW
    
    % Store queue lengths for visualization
    queue_history_ns(t, :) = queue_ns;
    queue_history_ew(t, :) = queue_ew;
    
    % Calculate total waiting times for performance evaluation
    total_waiting_time_ns = total_waiting_time_ns + sum(queue_ns);
    total_waiting_time_ew = total_waiting_time_ew + sum(queue_ew);
end

%% Visualization
% Plot the queue lengths over time for North-South and East-West directions

figure;
subplot(2,1,1);
plot(1:simulation_time, queue_history_ns(:,1), 'r', 'LineWidth', 2);
hold on;
plot(1:simulation_time, queue_history_ns(:,2), 'b', 'LineWidth', 2);
xlabel('Time step');
ylabel('Queue length');
legend('Intersection 1 (NS)', 'Intersection 2 (NS)');
title('North-South Queue Length at Intersections');
grid on;

subplot(2,1,2);
plot(1:simulation_time, queue_history_ew(:,1), 'r', 'LineWidth', 2);
hold on;
plot(1:simulation_time, queue_history_ew(:,2), 'b', 'LineWidth', 2);
xlabel('Time step');
ylabel('Queue length');
legend('Intersection 1 (EW)', 'Intersection 2 (EW)');
title('East-West Queue Length at Intersections');
grid on;

%% Performance Metrics
avg_waiting_time_ns = total_waiting_time_ns / simulation_time;
avg_waiting_time_ew = total_waiting_time_ew / simulation_time;

disp(['Average Waiting Time (NS): ', num2str(avg_waiting_time_ns)]);
disp(['Average Waiting Time (EW): ', num2str(avg_waiting_time_ew)]);
