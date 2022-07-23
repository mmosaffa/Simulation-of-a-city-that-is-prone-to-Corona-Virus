clc
clear
close all

%Initialization
T=input('How many days do you want to simulate? :   ');
population=input('How many people do you want to simulate? :   ');
Sportarea=input('How many Hospital beds do you want for the extra situation (Sport Area)? :   ');
Mosalla=input('How many Hospital beds do you want for emergency situation (Mosalla!)? :   ');
SportareaGen = floor(Sportarea*0.9);
MosallaGen = floor(Mosalla*0.9);
SportareaICU = Sportarea - floor(Sportarea*0.9);
MosallaICU = Mosalla - floor(Mosalla*0.9);

% SportareaGen = 4500;
% MosallaGen = 9000;
% SportareaICU = 500;
% MosallaICU = 1000;
% T = 45;
% population = 400000;

lowerbound = 1;
upperbound = population;
Sportareamatrix = zeros(T,2);
Sportareamatrix(:,1) = 1:T;
Mosallamatrix = zeros(T,2);
Mosallamatrix(:,1) = 1:T;
patientmatrix = zeros(population,7);
patientmatrix(:,1) = 1:population;
patientmatrix(1:4,2) = 1;
patientmatrix(1:4,3) = 1;
patientmatrix(1:4,5) = 1;
demandGenmatrix = zeros(T,2);
demandGenmatrix(:,1) = 1:T;
demandICUmatrix = zeros(T,2);
demandICUmatrix(:,1) = 1:T;
percworkGenmatrix = zeros(T,3);
percworkGenmatrix(:,1) = 1:T;
percworkICUmatrix = zeros(T,3);
percworkICUmatrix(:,1) = 1:T;
meanwaitGenmatrix = zeros(T,4);
meanwaitGenmatrix(:,1) = 1:T;
meanwaitICUmatrix = zeros(T,4);
meanwaitICUmatrix(:,1) = 1:T;
poscoronamatrix = zeros(T,2);
poscoronamatrix(:,1) = 1:T;
hoscoronamatrix = zeros(T,2);
hoscoronamatrix(:,1) = 1:T;
negcoronamatrix = zeros(T,2);
negcoronamatrix(:,1) = 1:T;
hospitalmatirx(:,1) = 1:T;
numcorperdaymatrix = zeros(T,2);
numcorperdaymatrix(:,1) = 1:T;
numqueueGenperdaymatrix = zeros(T,2);
numqueueGenperdaymatrix(:,1) = 1:T;
numqueueICUperdaymatrix = zeros(T,2);
numqueueICUperdaymatrix(:,1) = 1:T;
queueICUmatrix = [];
queueGenmatrix = [];
numgetwellmatrix = zeros(T,2);
numgetwellmatrix(:,1) = 1:T;
numgetwellsummatrix = zeros(T,2);
numgetwellsummatrix(:,1) = 1:T;
hospGenmatrix = zeros(450+SportareaGen+MosallaGen,3);
hospGenmatrix(:,1) = 1:(450+SportareaGen+MosallaGen);
hospICUmatrix = zeros(50+SportareaICU+MosallaICU,3);
hospICUmatrix(:,1) = 1:(50+SportareaICU+MosallaICU);
acceptGenmatrix = zeros(T,2);
acceptGenmatrix(:,1) = 1:T;
acceptICUmatrix = zeros(T,2);
acceptICUmatrix(:,1) = 1:T;
totalcorona = zeros(T,2);
totalcorona(:,1) = 1:T;
TH = 45;
Tnow = 0;
counterDay = 0;
tic
for Tnow = 0:T
    fprintf('%d th Days \n\n',Tnow);
    if counterDay ~= 0
        counter = 0;
        for i = 1:length(hospGenmatrix)
            if hospGenmatrix(i,2) == 1
                counter = counter + 1;
            end
        end
        percworkGenmatrix(counterDay,2) = counter;
        
        counter = 0;
        for i = 1:length(hospICUmatrix)
            if hospICUmatrix(i,2) == 1
                counter = counter + 1;
            end
        end
        percworkICUmatrix(counterDay,2) = counter;
    end
    %part 1 (Occurrence of recovery from the virus in the community)
    if counterDay ~= 0
        meanwaitGenmatrix(counterDay,4) = meanwaitGenmatrix(counterDay,2)/meanwaitGenmatrix(counterDay,3);
        meanwaitICUmatrix(counterDay,4) = meanwaitICUmatrix(counterDay,2)/meanwaitICUmatrix(counterDay,3);
        numqueueGenperdaymatrix(counterDay,2) = length(queueGenmatrix);
        numqueueICUperdaymatrix(counterDay,2) = length(queueICUmatrix);
    end
    if Tnow ~= T
        counterDay = counterDay + 1;
    end
    if counterDay ~= 0
        counter = 0;
        for i = lowerbound:upperbound
            if (patientmatrix(i,4) == counterDay) && (patientmatrix(i,5) == 1)
                counter = counter + 1;
                patientmatrix(i,2:3) = 1081;
            end
            numgetwellmatrix(counterDay,2) = counter;
        end
    end
    %part 1 (Occurrence of recovery from the virus in the community)
    
    %part 2 (The occurrence of the virus in the community)
    counter = 0;
    Ncorona = 0;
    Ncornew = 0;
    N_80 = 0;
    
    for i = lowerbound:upperbound
        if (patientmatrix(i,2) == 1) & (patientmatrix(i,7) <= 5)
             randd = randi(3);
             Ncornew = Ncornew + randd;
             patientmatrix(i,7) = patientmatrix(i,7) + randd;
             Ncorona = Ncorona + 1;
        end
    end
    
    for i = lowerbound:upperbound
        if (patientmatrix(i,2) == 1) & (patientmatrix(i,6) < counterDay) & (patientmatrix(i,7) <= 5) & ((patientmatrix(i,5) == 2) | (patientmatrix(i,5) == 3))
            randd = randi(3);
            Ncornew = Ncornew + randd;
            patientmatrix(i,7) = patientmatrix(i,7) + randd;
            Ncorona = Ncorona + 1;
        end
    end
    %Implement restrictive policies
    perc = 0.5;
    if counterDay>1
        if (sum(poscoronamatrix(1:counterDay,2)) > 1)
            perc = 0.4;
        end
        if (sum(poscoronamatrix(1:counterDay,2)) > 20)
            perc = 0.3;
        end
        if (sum(poscoronamatrix(1:counterDay,2)) > 50)
            perc = 0.2;
        end
        if (sum(poscoronamatrix(1:counterDay,2)) > 100)
            perc = 0.1;
        end
    end
    Ncornew = ceil(Ncornew*perc);
%    Implement restrictive policies
    
    %disp(Ncornew);
    
    if Ncornew>population
        Ncornew = population;
    end
    counter = 0;
    for j = 1:Ncornew
        randd = randi(population);
        if (patientmatrix(randd,2) == 0) & (patientmatrix(randd,3) == 0) & (counter ~= Ncornew)
            patientmatrix(randd,2) = 1;
            patientmatrix(randd,3) = counterDay;
            counter = counter + 1;
        end
    end
    %disp(counter);
    numcorperdaymatrix(counterDay,2) = counter;
    
    counter = 0;
    N_80 = floor(Ncornew*0.8);
    N_15 = floor((Ncornew - floor(Ncornew*0.8))*0.75);
    
    for i = lowerbound:upperbound
        if (patientmatrix(i,2) == 1) & (patientmatrix(i,3) == counterDay) & (counter ~= N_80)
            patientmatrix(i,4) = patientmatrix(i,3) + (randi(8) + 6);
            patientmatrix(i,5) = 1;
            counter = counter + 1;
        end
    end
    counter = 0;
    randd = 0;
    for i = lowerbound:upperbound
        if (patientmatrix(i,2) == 1) & (patientmatrix(i,3) == counterDay) & (patientmatrix(i,4) == 0) & (counter ~= N_15)
            randd =(randi(4) + 6);
            patientmatrix(i,4) = patientmatrix(i,3) + randd;
            patientmatrix(i,5) = 2;
            patientmatrix(i,6) = patientmatrix(i,3) + randd;
            counter = counter + 1;
        end
    end
    
    counter = 0;
    randd = 0;
    for i = lowerbound:upperbound
        if (patientmatrix(i,2) == 1) & (patientmatrix(i,3) == counterDay) & (patientmatrix(i,4) == 0)
            randd =(randi(4) + 6);
            patientmatrix(i,4) = patientmatrix(i,3) + randd;
            patientmatrix(i,5) = 3;
            patientmatrix(i,6) = patientmatrix(i,3) + randd;
            counter = counter + 1;
        end
    end
    
    counter = 0;
    for i = lowerbound:upperbound
        if (patientmatrix(i,6) == counterDay) & (patientmatrix(i,5) == 2)
            counter = counter + 1;
            queueGenmatrix = [queueGenmatrix;length(queueGenmatrix)+1,Tnow];
            patientmatrix(i,2:3) = 1082;
        end
    end
    %demandGenmatrix(counterDay,2) = counter;
    
    counter = 0;
    for i = lowerbound:upperbound
        if (patientmatrix(i,6) == counterDay) & (patientmatrix(i,5) == 3)
            counter = counter + 1;
            queueICUmatrix = [queueICUmatrix;length(queueICUmatrix)+1,Tnow];
            patientmatrix(i,2:3) = 1082;
        end
    end
    %part 2 (The occurrence of the virus in the community)
     
    %Part 3 (The occurrence of the return from hospital)
    randd = 0;
    if Tnow ~= 0
        for i = 1:length(hospGenmatrix)
            if hospGenmatrix(i,3) == counterDay
                hospGenmatrix(i,3) = 1081;
                hospGenmatrix(i,2) = 0;
                randd = randi(10);
                if randd <= 9
                    poscoronamatrix(counterDay,2) = poscoronamatrix(counterDay,2) + 1;
                    numgetwellmatrix(counterDay,2) = numgetwellmatrix(counterDay,2) + 1;
                else
                    negcoronamatrix(counterDay,2) = negcoronamatrix(counterDay,2) + 1;
                end
            end
        end
    end
    
    randd = 0;
    if Tnow ~= 0
        for i = 1:length(hospICUmatrix)
            if hospICUmatrix(i,3) == counterDay
                hospICUmatrix(i,3) = 1081;
                hospICUmatrix(i,2) = 0;
                randd = randi(10);
                if randd <= 5
                    poscoronamatrix(counterDay,2) = poscoronamatrix(counterDay,2) + 1;
                else
                    negcoronamatrix(counterDay,2) = negcoronamatrix(counterDay,2) + 1;
                end
            end
        end
    end
     %Part 3 (The occurrence of the return from hospital)
     
    %Part 4 (The occurrence of entering the hospital queue)
    %Normal Capacity of Hospital
    demandGenmatrix(counterDay,2) = length(queueGenmatrix);
    if length(queueGenmatrix) ~= 0
        randd = 0;
        for i = 1:(length(hospGenmatrix)-SportareaGen-MosallaGen)
            if length(queueGenmatrix) ~= 0
                if hospGenmatrix(i,2) == 0
                    meanwaitGenmatrix(counterDay,2) = meanwaitGenmatrix(counterDay,2) + (Tnow - queueGenmatrix(1,2));
                    meanwaitGenmatrix(counterDay,3) = meanwaitGenmatrix(counterDay,3) + 1;
                    queueGenmatrix = queueGenmatrix(2:end,:);
                    acceptGenmatrix(counterDay,2) = acceptGenmatrix(counterDay,2) + 1;
                    randd = (randi(12) + 2);
                    hospGenmatrix(i,3) =  randd + Tnow;
                    hospGenmatrix(i,2) = 1;
                end
            end
        end
    end
    %Extra Capacity of Hospital
    if length(queueGenmatrix) ~= 0
        randd = 0;
        for i = (1+450):(length(hospGenmatrix) - MosallaGen)
            if length(queueGenmatrix) ~= 0
                if hospGenmatrix(i,2) == 0
                    meanwaitGenmatrix(counterDay,2) = meanwaitGenmatrix(counterDay,2) + (Tnow - queueGenmatrix(1,2));
                    meanwaitGenmatrix(counterDay,3) = meanwaitGenmatrix(counterDay,3) + 1;
                    queueGenmatrix = queueGenmatrix(2:end,:);
                    acceptGenmatrix(counterDay,2) = acceptGenmatrix(counterDay,2) + 1;
                    randd = (randi(12) + 2);
                    hospGenmatrix(i,3) =  randd + Tnow;
                    hospGenmatrix(i,2) = 1;
                    Sportareamatrix(counterDay,2) = Sportareamatrix(counterDay,2) + 1;
                end
            end
        end
    end
    %Emergency Capacity of Hospital
    if length(queueGenmatrix) ~= 0
        randd = 0;
        for i = (1+450+SportareaGen):(length(hospGenmatrix))
            if length(queueGenmatrix) ~= 0
                if hospGenmatrix(i,2) == 0
                    meanwaitGenmatrix(counterDay,2) = meanwaitGenmatrix(counterDay,2) + (Tnow - queueGenmatrix(1,2));
                    meanwaitGenmatrix(counterDay,3) = meanwaitGenmatrix(counterDay,3) + 1;
                    queueGenmatrix = queueGenmatrix(2:end,:);
                    acceptGenmatrix(counterDay,2) = acceptGenmatrix(counterDay,2) + 1;
                    randd = (randi(12) + 2);
                    hospGenmatrix(i,3) =  randd + Tnow;
                    hospGenmatrix(i,2) = 1;
                    Mosallamatrix(counterDay,2) = Mosallamatrix(counterDay,2) + 1;
                end
            end
        end
    end
    demandICUmatrix(counterDay,2) = length(queueICUmatrix);
    if length(queueICUmatrix) ~= 0
        randd = 0;
        for i = 1:(length(hospICUmatrix) - SportareaICU - MosallaICU)
            if length(queueICUmatrix) ~= 0
                if hospICUmatrix(i,2) == 0
                    meanwaitICUmatrix(counterDay,2) = meanwaitICUmatrix(counterDay,2) + (Tnow - queueICUmatrix(1,2));
                    meanwaitICUmatrix(counterDay,3) = meanwaitICUmatrix(counterDay,3) + 1;
                    queueICUmatrix = queueICUmatrix(2:end,:);
                    acceptICUmatrix(counterDay,2) = acceptICUmatrix(counterDay,2) + 1;
                    randd = (randi(8) + 6);
                    hospICUmatrix(i,3) =  randd + Tnow;
                    hospICUmatrix(i,2) = 1;
                end
            end
        end
    end
    
    if length(queueICUmatrix) ~= 0
        randd = 0;
        for i = (1+50):(length(hospICUmatrix) - MosallaICU)
            if length(queueICUmatrix) ~= 0
                if hospICUmatrix(i,2) == 0
                    meanwaitICUmatrix(counterDay,2) = meanwaitICUmatrix(counterDay,2) + (Tnow - queueICUmatrix(1,2));
                    meanwaitICUmatrix(counterDay,3) = meanwaitICUmatrix(counterDay,3) + 1;
                    queueICUmatrix = queueICUmatrix(2:end,:);
                    acceptICUmatrix(counterDay,2) = acceptICUmatrix(counterDay,2) + 1;
                    randd = (randi(8) + 6);
                    hospICUmatrix(i,3) =  randd + Tnow;
                    hospICUmatrix(i,2) = 1;
                    Sportareamatrix(counterDay,2) = Sportareamatrix(counterDay,2) + 1;
                end
            end
        end
    end
    
    if length(queueICUmatrix) ~= 0
        randd = 0;
        for i = (1 + 50 + SportareaICU):length(hospICUmatrix)
            if length(queueICUmatrix) ~= 0
                if hospICUmatrix(i,2) == 0
                    meanwaitICUmatrix(counterDay,2) = meanwaitICUmatrix(counterDay,2) + (Tnow - queueICUmatrix(1,2));
                    meanwaitICUmatrix(counterDay,3) = meanwaitICUmatrix(counterDay,3) + 1;
                    queueICUmatrix = queueICUmatrix(2:end,:);
                    acceptICUmatrix(counterDay,2) = acceptICUmatrix(counterDay,2) + 1;
                    randd = (randi(8) + 6);
                    hospICUmatrix(i,3) =  randd + Tnow;
                    hospICUmatrix(i,2) = 1;
                    Mosallamatrix(counterDay,2) = Mosallamatrix(counterDay,2) + 1;
                end
            end
        end
    end
    %Part 4 (The occurrence of entering the hospital queue)
end

for i = 1 : length(numcorperdaymatrix)
    totalcorona(i,2) = sum(numcorperdaymatrix(1:i,2))+4;
end

figure
hold on
bar(numcorperdaymatrix(:,1),numcorperdaymatrix(:,2));
plot(totalcorona(:,1),totalcorona(:,2),'r-','LineWidth',1.3);
title('number of corona cases (without getting well persons)');
xlabel('Day')
ylabel('Numbers')
grid on
hold off

for i = 1 : length(numcorperdaymatrix)
    numgetwellsummatrix(i,2) = sum(numgetwellmatrix(1:i,2));
end
toc
figure
hold on
bar(numcorperdaymatrix(:,1),numcorperdaymatrix(:,2));
plot(totalcorona(:,1),totalcorona(:,2)-numgetwellsummatrix(:,2),'r-','LineWidth',1.3);
title('number of corona cases (Total)');
xlabel('Day')
ylabel('Numbers')
grid on
hold off

figure
hold on
bar(percworkICUmatrix(:,1),percworkICUmatrix(:,2));
plot(demandICUmatrix(:,1),demandICUmatrix(:,2),'b-','LineWidth',1.3);
legend('Occupied beds','ICU Patient');
title('Demanding for ICU');
xlabel('Day')
ylabel('Numbers')
grid on
hold off

figure
hold on
bar(percworkGenmatrix(:,1),percworkGenmatrix(:,2));
plot(demandGenmatrix(:,1),demandGenmatrix(:,2),'r-','LineWidth',1.3);
%plot(demandICUmatrix(:,1),demandICUmatrix(:,2),'b-','LineWidth',1.3);
legend('Occupied beds','Normal Patient');
title('Demanding for Normal cure');
xlabel('Day')
ylabel('Numbers')
grid on
hold off

figure
hold on
%bar(percworkGenmatrix(:,1),percworkGenmatrix(:,2));
plot(demandGenmatrix(:,1),demandGenmatrix(:,2),'r-','LineWidth',1.3);
plot(demandICUmatrix(:,1),demandICUmatrix(:,2),'b-','LineWidth',1.3);
legend('Normal Patient','ICU Patient');
title('Demanding for cure');
xlabel('Day')
ylabel('Numbers')
grid on
hold off

figure
hold on
subplot(2,1,1);plot(Sportareamatrix(:,1),Sportareamatrix(:,2),'r-','LineWidth',1.3);
title('Sport Area Demanding');
xlabel('Day')
ylabel('Numbers')
grid on
subplot(2,1,2);plot(Mosallamatrix(:,1),Mosallamatrix(:,2),'b-','LineWidth',1.3);
title('Mosalla Demanding');
xlabel('Day')
ylabel('Numbers')
grid on
hold off

figure
hold on
plot(poscoronamatrix(:,1),poscoronamatrix(:,2),'b-','LineWidth',1.3);
plot(negcoronamatrix(:,1),negcoronamatrix(:,2),'r-','LineWidth',1.3);
legend('Alive','Died');
title('Alive and Died persons after curing');
xlabel('Day')
ylabel('Numbers')
grid on

figure
subplot(1,2,1);
hold on
bar(meanwaitGenmatrix(:,1),meanwaitGenmatrix(:,4));
plot(meanwaitGenmatrix(:,1),meanwaitGenmatrix(:,4),'r-','LineWidth',1.5);
title('Meantime Normal queue per day');
xlabel('Day')
ylabel('Mean time')
grid on
hold off

subplot(1,2,2);
hold on
bar(meanwaitICUmatrix(:,1),meanwaitICUmatrix(:,4));
plot(meanwaitICUmatrix(:,1),meanwaitICUmatrix(:,4),'r-','LineWidth',1.5);
title('Meantime ICU queue per day');
xlabel('Day')
ylabel('Mean time')
grid on
hold off























