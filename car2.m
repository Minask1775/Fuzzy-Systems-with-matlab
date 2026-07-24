% Car Control
%1775 ΜΗΝΑΣ ΙΩΑΝΝΗΣ ΚΑΖΑΣ
%1805 ΣΑΒΒΑΣ ΕΛΕΥΘΕΡΙΑΔΗΣ

% Αρχικές συνθήκες
X_init = 9.1; Y_init = 4.3; V_init = 0.05; 
Heading_init = [0, 45, 90]; 

% Στόχος
xd = 15; yd = 7.2;

% Χρόνος προσομοίωσης
time = 0:0.1:100; 

% Φόρτωση ασαφούς ελεγκτή
fis = readfis('Carcontrol'); 

% Εμπόδιο
obstacle_shape = polyshape([10 12 12 10 10], [5 5 8 8 5]);

% Αποθήκευση πορειών
trajectories = zeros(length(Heading_init), length(time), 2);

for i = 1:length(Heading_init)
    
    x = X_init;  
    y = Y_init;  
    v = V_init;  
    heading_angle = Heading_init(i);  
    trajectory = zeros(length(time), 2);  

    for t = 1:length(time)
        
        d_goal = sqrt((xd - x)^2 + (yd - y)^2) / sqrt(xd^2 + yd^2);  
        heading_goal = atan2d(yd - y, xd - x);  
        heading_error = mod(heading_goal - heading_angle + 180, 360) - 180;  
        
        % Υπολογισμός απόστασης από εμπόδιο
        dV = min(pdist2([x, y], obstacle_shape.Vertices));  
        max_obs_dist = sqrt((xd - min(obstacle_shape.Vertices(:,1)))^2 + ...
                            (yd - max(obstacle_shape.Vertices(:,2)))^2);  
        dV = min(max(dV / (max_obs_dist + 1e-6), 0), 1);  

        % Υπολογισμός σχετικής απόστασης οριζόντιας προς το εμπόδιο
        obs_x_min = min(obstacle_shape.Vertices(:,1));  
        obs_x_max = max(obstacle_shape.Vertices(:,1));  
        dH = min(max((x - obs_x_min) / (obs_x_max - obs_x_min + 1e-6), 0), 1);  

        % Αν πλησιάζει το εμπόδιο, αυξάνουμε τη στροφή για αποφυγή
        if dV < 0.3
            heading_error = heading_error + 90 * (0.3 - dV);  
        end  

        % Υπολογισμός αλλαγής γωνίας
        heading_change = evalfis(fis, [dV, dH, heading_error]);  
        heading_change = max(min(heading_change, 60), -60);  % Αυξήθηκε για πιο γρήγορη αποφυγή

        % Ενημέρωση γωνίας και θέσης
        heading_angle = heading_angle + heading_change * 0.1;  
        if heading_angle > 180  
            heading_angle = heading_angle - 360;  
        elseif heading_angle < -180  
            heading_angle = heading_angle + 360;  
        end  

        x = x + cosd(heading_angle) * v;  
        y = y + sind(heading_angle) * v;  

        trajectory(t, :) = [x, y];  

        % Αν φτάσαμε κοντά στον στόχο, τερματίζουμε
        if d_goal < 0.05  
            break;  
        end  

    end  

    trajectories(i, :, :) = trajectory;  

end


% Σχεδίαση
figure; hold on;
plot(obstacle_shape, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 2);

colors = ['r', 'g', 'b'];
labels = {'Αρχική γωνία 0°', 'Αρχική γωνία 45°', 'Αρχική γωνία 90°'};

for i = 1:length(Heading_init)
    plot(squeeze(trajectories(i, :, 1)), squeeze(trajectories(i, :, 2)), colors(i), 'DisplayName', labels{i});
end

scatter(xd, yd, 60, 'b', 'filled', 'DisplayName', 'Στόχος'); 
legend('Εμπόδιο', labels{:}, 'Στόχος', 'Location', 'best');
xlabel('Θέση X'); ylabel('Θέση Y'); title('Κίνηση οχήματος σε περιβάλλον με εμπόδιο');
grid on;

