clc; clear; close all;
%1775 ΜΗΝΑΣ ΙΩΑΝΝΗΣ ΚΑΖΑΣ
%1805 ΣΑΒΒΑΣ ΕΛΕΥΘΕΡΙΑΔΗΣ


%% Ορισμός παραμέτρων συστήματος
Ts = 0.01;  % Βήμα χρόνου 
Tsim = 5;   % Χρόνος προσομοίωσης
time = 0:Ts:Tsim;  % Διάνυσμα χρόνου
r = 50 * ones(size(time)); % βηματική διέγερση

% Ορισμός των κερδών κλιμακοποίησης
Ke = 1/50;  
Kde = 1/50; 
Ku = 50; 

% Αρχικοποίηση μεταβλητών
y = zeros(size(time)); % Έξοδος συστήματος
u = zeros(size(time)); % Σήμα ελέγχου
e = zeros(size(time)); % Σφάλμα
de = zeros(size(time)); % Μεταβολή του σφάλματος

%% Φόρτωση του ασαφούς ελεγκτή (FIS)
fis = readfis('trapfiz.fis'); % Φόρτωση αρχείου FIS

%% Προσομοίωση κλειστού βρόχου
for k = 2:length(time)
    e(k) = r(k) - y(k-1); % Υπολογισμός σφάλματος
    de(k) = e(k) - e(k-1); % Υπολογισμός μεταβολής σφάλματος
    
    % Κανονικοποίηση των εισόδων
    e_norm = Ke * e(k);
    de_norm = Kde * de(k);
    
    % Υπολογισμός ελέγχου μέσω του ασαφούς ελεγκτή
    du_norm = evalfis([e_norm de_norm], fis);
    
    % Αποκανονικοποίηση του σήματος ελέγχου
    du = Ku * du_norm;
    u(k) = u(k-1) + du; % Εφαρμογή του νόμου ελέγχου
    
    % Προσομοίωση κινητήρα (απλό μοντέλο πρώτης τάξης)
    tau = 0.1; % Σταθερά χρόνου κινητήρα
    y(k) = (1 - Ts/tau) * y(k-1) + (Ts/tau) * u(k-1);
end

%% Σχεδίαση αποτελεσμάτων
figure;
subplot(3,1,1);
plot(time, r, 'r--', time, y, 'b', 'LineWidth', 1.5);
xlabel('Χρόνος (sec)'); ylabel('Ταχύτητα (rad/sec)');
title('Απόκριση συστήματος');
legend('Αναφορά', 'Έξοδος');

subplot(3,1,2);
plot(time, e, 'k', 'LineWidth', 1.5);
xlabel('Χρόνος (sec)'); ylabel('Σφάλμα');
title('Σφάλμα συστήματος');

subplot(3,1,3);
plot(time, u, 'g', 'LineWidth', 1.5);
xlabel('Χρόνος (sec)'); ylabel('Σήμα Ελέγχου');
title('Έξοδος του ελεγκτή');

%% Δημιουργία 3D επιφάνειας του ασαφούς ελεγκτή
[x, y] = meshgrid(-1:0.1:1, -1:0.1:1);
z = zeros(size(x));
for i = 1:size(x,1)
    for j = 1:size(x,2)
        z(i,j) = evalfis([x(i,j) y(i,j)], fis);
    end
end

figure;
surf(x, y, z);
xlabel('Σφάλμα e(k)');
ylabel('Μεταβολή Σφάλματος Δe(k)');
zlabel('Έξοδος του ελεγκτή Δu(k)');
title('Επιφάνεια ελέγχου του ασαφούς ελεγκτή');
