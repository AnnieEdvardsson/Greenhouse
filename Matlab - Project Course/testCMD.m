command = 'git add *';
[status,cmdout] = system(command)

command = 'git commit -m "auto com';
[status,cmdout] = system(command)

command = 'git push';
[status,cmdout] = system(command)

%[~,cmdout] = system('dir')