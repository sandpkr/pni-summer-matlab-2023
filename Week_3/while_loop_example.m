%%%% while loop examples
clear
clc

%% while loop increasing increment

itr=1;
while itr<5
    disp(['current iteration is: ' num2str(itr)])
    itr=itr+1;
end

%% while loop decreasing increment
clc

itr=10;
while itr>1
    disp(['current iteration is: ' num2str(itr)])
    itr=itr-1;
end

%% while loop in different incremental steps
clc

itr=1;
while itr<10
    disp(['current iteration is: ' num2str(itr)])
    itr=itr+2;
end

%% while loop example factorial
n = 5;
factorial = 1;
i = 1;
while i <= n
    factorial = factorial * i;
    i = i + 1;
end
disp(factorial);