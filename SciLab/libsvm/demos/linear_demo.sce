// SVM with libsvm
// Xu Cui, 2009/10/07

//// two classes, linear

// data setup: our data contains two classes, each N samples. The data is 2D
N = 500;
l = [ones(N,1); -ones(N,1)]; // label
d = [l/2 + rand(2*N,1,'norm')/2  l-rand(2*N,1,'norm')/2]; // data


// plot original data for visual inspection

scf();clf();
pos = find(l==1);
plot(d(pos,1),d(pos,2),'r.');
pos = find(l==-1);
plot(d(pos, 1),d(pos, 2),'b.');
//axis equal

// SVM with linear kernel (-t 0). We want to find the best parameter value C
// using 2-fold cross validation (meaning use 1/2 data to train, the other
// 1/2 to test). Please note the parameter -g (gamma) is useless for linear
// kernel
bestcv = 0;
for log2c = -1.1:3.1,
  for log2g = -4.1:1.1,
    cmd = ['-t 0 -v 2 -c '+ string(2^log2c)+ ' -g '+ string(2^log2g)+' -q'];
    cv = libsvm_svmtrain(l, d, cmd);
    if (cv >= bestcv),
      bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
      printf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
    end
  end
end

// After finding the best parameter value for C, we train the entire data
// again using this parameter value
cmd = ['-t 0 -c '+ string(bestc)+ ' -g '+ string(bestg)+' -q'];
tic();model = libsvm_svmtrain(l, d, cmd);toc()

// now plot support vectors

sv = full(model.SVs);
plot(sv(:,1),sv(:,2),'ko');

// now plot decision area
[xi,yi] = meshgrid([min(d(:,1)):0.1:max(d(:,1))],[min(d(:,2)):0.1:max(d(:,2))]);
dd = [xi(:),yi(:)];
tic();[predicted_label, accuracy, decision_values] = libsvm_svmpredict(zeros(size(dd,1),1), dd, model);toc()
pos = find(predicted_label==1);

redcolor = [1 0.8 0.8];
bluecolor = [0.8 0.8 1];
plot(dd(pos,1),dd(pos,2),'s','color',redcolor,'MarkerSize',5,'MarkerEdgeColor',redcolor,'MarkerFaceColor',redcolor);
h1 = gce();
h1.children(1).thickness=0;


pos = find(predicted_label==-1);
plot(dd(pos,1),dd(pos,2),'s','color',bluecolor,'MarkerSize',5,'MarkerEdgeColor',bluecolor,'MarkerFaceColor',bluecolor);
h2 = gce();
h2.children(1).thickness=0;

//Replot data and support vectors
pos = find(l==1);
plot(d(pos,1),d(pos,2),'r.');
pos = find(l==-1);
plot(d(pos, 1),d(pos, 2),'b.');
plot(sv(:,1),sv(:,2),'ko');
//uistack(h1, 'bottom');
//uistack(h2, 'bottom');