

load covtype.data
Y = covtype(:,end);
covtype(:,end) = [];



tabulate(Y)




part = cvpartition(Y,'holdout',0.5);
istrain = training(part); % data for fitting
istest = test(part); % data for quality assessment
tabulate(Y(istrain))

testOne = covtype(istest,:);
testTwo = covtype(istest);
t = ClassificationTree.template('minleaf',5);
tic
rusTree = fitensemble(covtype(istrain,:),Y(istrain),'RUSBoost',1000,t,...
    'LearnRate',0.1,'nprint',100);
toc




figure;
tic
plot(loss(rusTree,covtype(istest,:),Y(istest),'mode','cumulative'));
toc
grid on;
xlabel('Number of trees');
ylabel('Test classification error');


test = covtype(istest,:);