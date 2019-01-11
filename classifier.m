%reading dataset into matlab

r = dataset('file', '\\Client\F$\MIS\datasetf.dataset','delimiter',',');
data=dataset2cell(r);
data=data(2:151,1:5);
Y=zeros(3,150);
check=zeros(132,1);
%forming yi
data = data(randperm(size(data,1)),:);
for i=1:150
    if strcmp('Iris-setosa',data(i,5))==1
        Y(1,i)=1;
        check(i,1)=1;
    end
    
    if strcmp('Iris-versicolor',data(i,5))==1
        Y(2,i)=1;
        check(i,1)=2;
    end
    
    if strcmp('Iris-virginica',data(i,5))==1    
        Y(3,i)=1;
        check(i,1)=3;
    end
end

%dividing into training and testing data
train=data(1:45,1:4);
test=data(46:150,1:4);

ytrain=Y(:,1:45);
ytest=Y(:,46:150);
ycheck=check(46:150,:);
datatrain=data(1:45,1:4);
datatrain=cell2mat(datatrain);

train1=datatrain.';
train1=[train1; ones(1,45)*1];


datatest=data(46:150,1:4);
datatest=cell2mat(datatest);

datatest=datatest.';

lambda=0.1;
ytrain=ytrain.';

%finding w
first=zeros(5);
second=zeros(5,3);

for i=1:45
    
    first=first+ (train1(:,i))*(train1(:,i).');
    second=second+ (train1(:,i))*(ytrain(i,:));
  
end
%appending ones to data and bias to w
datatest=[datatest; ones(1,105)*1];

w3=inv(first+lambda)*second;

counter=0;
winner=0;
winner1=zeros(105,1);

%for test data
for i=1:105
    maxval=0;
    for j=1:3
        test=(datatest(:,i));
        w=w3(:,j).';
        prob=w*test;
        if maxval<prob
            maxval=prob;
            winner=j;
        end
        winner1(i)=winner;
       
    end
    if ycheck(i,1)==winner1(i,1)
            counter=counter+1;
    end
end

result=counter*100/105;
C=confusionmat(ycheck,winner1);
disp(C);


    