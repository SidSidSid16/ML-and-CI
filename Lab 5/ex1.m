clear; clc; close all;

t = tiledlayout(2,2,"Padding","tight");
ttl = title(t, "Response of LIF neuron model");
ttl.FontSize = 24;
ttl.FontWeight = "bold";


tc = 25;        % Time constant (25ms)
El = 0;         % Resting potential (0)
Vth = 1;        % Firing threshold (0)
R = 1;          % Input resistance (1 Ohm)

tl = 250;       % Time limit
dt = 1;         % Time step
RmI = 0.8;      % Input condition
V = 0;          % Output voltage

% Forward Euler

V = forwardEulerLIF(dt, tc, tl, El, RmI, Vth);

nexttile;
plot(V, 'LineWidth', 1)
xlim([0 tl])
ylim([0 1])
title('Forward Euler, RmI = 0.8');
ylabel("Amplitude / (V)");
xlabel("Time / (ms)");

% Changing RmI to 1.2

RmI = 1.2;
V = forwardEulerLIF(dt, tc, tl, El, RmI, Vth);

nexttile;
plot(V, 'LineWidth', 1)
xlim([0 tl])
ylim([0 1])
title('Forward Euler, RmI = 1.2');
ylabel("Amplitude / (V)");
xlabel("Time / (ms)");



% Backwards Euler

% Reset RmI to 0.8
RmI = 0.8;
backwardEulerLIF(dt, tc, tl, El, RmI, Vth);

nexttile;
plot(V, 'LineWidth', 1)
xlim([0 tl])
ylim([0 1])
title('Backwards Euler, RmI = 0.8');
ylabel("Amplitude / (V)");
xlabel("Time / (ms)");


% Change RmI to 1.2
RmI = 1.2;
backwardEulerLIF(dt, tc, tl, El, RmI, Vth);

nexttile;
plot(V, 'LineWidth', 1)
xlim([0 tl])
ylim([0 1])
title('Backwards Euler, RmI = 0.8');
ylabel("Amplitude / (V)");
xlabel("Time / (ms)");

function V = forwardEulerLIF(dt, tc, tl, El, RmI, Vth)
    V = zeros(1, tl);
    for t = 2:tl
        V(t) = V(t-1) * (1 - (dt/tc)) + (dt * ((El + RmI)/ tc));
        if (V(t) >= Vth)
            V(t) = El;
        end
    end
end

function V = backwardEulerLIF(dt, tc, tl, El, RmI, Vth)
    V = zeros(1, tl);
    for t = 2:tl
        V(t) = (V(t-1) + (dt * ( (El + RmI)/ tc))) / (1 + (dt * (1/tc)));
        if (V(t) >= Vth)
            V(t) = El;
        end
    end
end
