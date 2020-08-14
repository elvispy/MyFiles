clear
close all
clc

tstart = tic;
%data in cgs
tmax = 15000;

load('runNumber.mat','runNumber')

% if runNumber == 0
    U0 = 60; save('U0.mat','U0')%impact velocity in cm/s
    Ang = 180; save('Ang.mat','Ang')
    cd ..
    load('Ro.mat','Ro')
    cd ..
    load('rhoS.mat','rhoS')
    load('Ma.mat','Ma')
    cd ..
    load('nu.mat','nu')
    load('g.mat','g')
    load('sigma.mat','sigma')
    load('rho.mat','rho')
    load('muair.mat','muair')
    cd ..
    load('nr.mat','nr')
    load('nlmax.mat','nlmax')
    load('dr.mat','dr')
    load('Delta.mat','Delta')
    load('angleDropMP.mat','angleDropMP')
    load('IntMat.mat','IntMat')
    load('quant.mat')
    load('D.mat')
    load('refp.mat')
    load(['DTNnew345nr',num2str(nr),'D',num2str(D),'refp',num2str(refp),'.mat'],'DTNnew345')
    DTN = DTNnew345;
    clear DTNnew345
    load('zs.mat','zs')
    load('xdrop.mat')
    load('xplot.mat')
    load('zdrop.mat')

    cd(['rho',num2str(1000*rho),'sigma',num2str(round(100*sigma)),'nu',num2str(round(10000*nu)),'muair',num2str(muair)])
    
    if rhoS < 1
        cd(['RhoS0',num2str(1000*rhoS)])
    else
        cd(['RhoS',num2str(1000*rhoS)])
    end
    
    if Ro <.1
        cd(['Ro0',num2str(10000*Ro),'mm'])
    else
        cd(['Ro',num2str(10000*Ro),'mm'])
    end
    
    cd(['U',num2str(U0),'Ang',num2str(Ang)])

    tiempoComp = zeros(1,10); %jjust to check how long it takes to solve the first ten periods
    
    %Unit of time
    T = Ro/U0; save('T.mat','T')%base time is seconds

    %Dimensionless numbers that depend on U0
    Re = Ro*U0/nu; save('Re.mat','Re')
    Fr = U0^2/(g*Ro); save('Fr.mat','Fr')
    We = rho*U0^2*Ro/sigma; save('We.mat','We')
    WeS = rhoS*Ro*U0^2/sigma;save('WeS.mat','WeS')
    Cang = Ang*pi/180; save('Cang.mat','Cang')
    
    %Physical parameters
    tend = ceil(.04/T); save('tend.mat','tend')%Earliest possible end of simulation in characteristic units
    
    %Numerical Simulation parameters
    nsteps1 = 200;
    nsteps2 = ceil(400/tend);
    nsteps = max(nsteps1,nsteps2); save('nsteps.mat','nsteps')%number of timesteps in one unit of time
    dtb = 1/nsteps; save('dtb.mat','dtb')%basic timestep
%     dt = dtb; %seting the current timestep to the basic value
    
    %Inintial conditions for the fluid
    t = 0;
    steps = ceil((tend-t)/dtb); %estimated total number of timesteps
    etao = zeros(nr,1); %initial surface elevation
    phio = zeros(nr,1); %initial surface potential
    pso = zeros(nlmax,1); %initial pressure distribution on surface
    
    %Zeroing result storing variables
    etaOri = zeros(1,steps+1);
    z = zeros(1,steps+1);
    vz = zeros(1,steps+1);
    numl = zeros(1,steps+1);
    tvec = t:dtb:tend+1; %giving extra time just in case the simulation needs to run longer
    
    %Initial conditions for the drop
    z(1) = 0; %in dimensionless units
%     DelV = (1-sqrt(1-6*z(1)/Fr))/3;
    vz(1) = -1; %in dimesionless units
    
    jj = 0;%iteration counter

    errortan = zeros(5,steps+1);

    eta = etao;
    phi = phio;
    ps = pso;
    
    eta1 = eta;
    phi1 = phi;
    ps1 = ps;
    
    etaMatPer = zeros(length(eta),nsteps);
    phiMatPer = zeros(length(phi),nsteps);
    psMatPer = zeros(nlmax,nsteps);
    
    etaMatPer(:,1) = eta;
    phiMatPer(:,1) = phi;
    psMatPer(:,1) = ps;
    
    jj1 = 1; %partial results savings  counter

% elseif runNumber>0
%     load('U0.mat','U0')%impact velocity in cm/s
%     cd ..
%     load('rhoS.mat','rhoS')
%     load('Ma.mat','Ma')
%     cd ..
%     load('Ro.mat','Ro')
%     load('alpha.mat','alpha')
%     load('nr.mat','nr')
%     load('nlmax.mat','nlmax')
%     load('dr.mat','dr')
%     load('Delta.mat','Delta')
%     load('angleDropMP.mat','angleDropMP')
%     load('IntMat.mat','IntMat')
%     load('DTNnew345nr2500D100refp10.mat','DTNnew345')
%     DTN = DTNnew345;
%     clear DTNnew345
%     load('zs.mat','zs')
%     cd ..
%     load('nu.mat','nu')
%     load('g.mat','g')
%     load('sigma.mat','sigma')
%     load('rho.mat','rho')
%     cd(['NewR0',num2str(Ro*10000),'mm'])
%     cd(['Rho',num2str(rhoS*1000)])
%     cd(['U',num2str(U0)])
%     
%     tiempoComp = zeros(1,10); %just to check how long it takes to solve the first ten periods
%     
%     %Unit of time
%     load('T.mat','T')%base time is seconds
%     %Dimensionless numbers that depend on U0
%     load('Re.mat','Re')
%     load('Fr.mat','Fr')
%     load('We.mat','We')
%     load('WeS.mat','WeS')
%     load('Cang.mat','Cang')
%     
%     %Physical parameters
%     load('tend.mat','tend')%Earliest possible end of simulation in characteristic units
%     
%     %Numerical Simulation parameters
%     load('nsteps.mat','nsteps')%number of timesteps in one unit of time
%     load('dtb.mat','dtb')%basic timestep
%     
%     %Zeroing result storing variables
%     load(['etao',num2str(runNumber),'.mat'],'etao')
%     load(['phio',num2str(runNumber),'.mat'],'phio')
%     load(['pso',num2str(runNumber),'.mat'],'pso')
%     load('etaOri.mat','etaOri')
%     load('z.mat','z')
%     load('vz.mat')
%     load('numl.mat')
%     load('tvec.mat')
% 
%     %Inintial conditions
%     load(['tstop',num2str(runNumber),'.mat'],'tstop') 
%     t = tstop;
%     load(['jjstop',num2str(runNumber),'.mat'],'jjstop')
%     jj = jjstop;
%     
%     eta = etao;
%     phi = phio;
%     ps = pso;
%     
%     etaMatPer = zeros(length(eta),nsteps);
%     phiMatPer = zeros(length(phi),nsteps);
%     psMatPer = zeros(nlmax,nsteps);
%     
%     etaMatPer(:,1) = eta;
%     phiMatPer(:,1) = phi;
%     psMatPer(:,1) = ps;
% 
%     %Drop geometry
%     load('xdrop.mat','xdrop')
%     load('zdrop.mat','zdrop')
%     load('angleDropMP.mat','angleDropMP')
%     load('errortan.mat','errortan')
%     load('IntMat.mat','IntMat')
%     
%     jj1 = 1;
% 
% elseif runNumber < 0
%     exit
% end

%Main Loop
while t<tend || jj1>.5
    jj = jj+1;
    t = tvec(jj+1);
    dt = t - tvec(jj);

    etaprob = zeros(nr,5);
    phiprob = zeros(nr,5);
    psprob = zeros(nlmax,5);
    vzprob = zeros(1,5);
    zprob = zeros(1,5);
    errortan(:,jj+1) = 4*ones(5,1);

    if numl(jj) < .5 %i.e. if previously in flight
        [etaprob(:,3),phiprob(:,3),zprob(3),vzprob(3),errortan(3,jj+1)] = ...
            solve0(dt,z(jj),vz(jj),etao,phio,nr,Re,Delta,DTN,Fr,We,zs);
        if abs(errortan(3,jj+1))<.5
            numl(jj+1) = 0;
            eta1 = etaprob(:,3);
            phi1 = phiprob(:,3);
            ps1 = zeros(nlmax,1);
            z(jj+1) = zprob(3);
            vz(jj+1) = vzprob(3);
        else
            co = find(numl(jj:-1:1)~=1,1);
            [etaprob(:,4),phiprob(:,4),zprob(4),vzprob(4),psprob(1,4),errortan(4,jj+1)] = ...
                solvenCorner(numl(jj-co+1),1,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                We,Ma,zs,IntMat(1,:),angleDropMP,Cang,WeS);
            co = find(numl(jj:-1:1)~=2,1);
            [~,~,~,~,~,errortan(5,jj+1)] = ...    
                solvenCorner(numl(jj-co+1),2,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                We,Ma,zs,IntMat(2,:),angleDropMP,Cang,WeS);
            if abs(errortan(4,jj+1)) < abs(errortan(5,jj+1))
                numl(jj+1) = 1;
                eta1 = etaprob(:,4);
                phi1 = phiprob(:,4);
                ps1 = psprob(:,4);
                z(jj+1) = zprob(4);
                vz(jj+1) = vzprob(4);
            else
                tvec = [tvec(1:jj),tvec(jj)/2+tvec(jj+1)/2,tvec(jj+1:end)];
                jj = jj-1;
            end
        end
    elseif numl(jj)>.5 && numl(jj)<1.5 % i.e. the last number of contact points was 1
        [etaprob(:,2),phiprob(:,2),zprob(2),vzprob(2),errortan(2,jj+1)] = ...
            solve0(dt,z(jj),vz(jj),etao,phio,nr,Re,Delta,DTN,Fr,We,zs);
        if abs(errortan(2,jj+1))<.5
            numl(jj+1) = 0;
            eta1 = etaprob(:,2);
            phi1 = phiprob(:,2);
            ps1 = zeros(nlmax,1);
            z(jj+1) = zprob(2);
            vz(jj+1) = vzprob(2);
        else
            co = find(numl(jj:-1:1)~=1,1);
            [etaprob(:,3),phiprob(:,3),zprob(3),vzprob(3),psprob(1,3),errortan(3,jj+1)] = ...                     
                solvenCorner(numl(jj-co+1),1,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                We,Ma,zs,IntMat(1,:),angleDropMP,Cang,WeS);
            co = find(numl(jj:-1:1)~=2,1);
            [etaprob(:,4),phiprob(:,4),zprob(4),vzprob(4),psprob(1:2,4),errortan(4,jj+1)] = ...    
                solvenCorner(numl(jj-co+1),2,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                We,Ma,zs,IntMat(2,:),angleDropMP,Cang,WeS);
            if abs(errortan(3,jj+1)) < abs(errortan(4,jj+1))
                numl(jj+1) = 1;
                eta1 = etaprob(:,3);
                phi1 = phiprob(:,3);
                ps1 = psprob(:,3);
                z(jj+1) = zprob(3);
                vz(jj+1) = vzprob(3);
            else
                co = find(numl(jj:-1:1)~=3,1);
                [~,~,~,~,~,errortan(5,jj+1)] = ...
                    solvenCorner(numl(jj-co+1),3,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                    We,Ma,zs,IntMat(3,:),angleDropMP,Cang,WeS);
                if abs(errortan(4,jj+1)) < abs(errortan(5,jj+1))
                    numl(jj+1) = 2;
                    eta1 = etaprob(:,4);
                    phi1 = phiprob(:,4);
                    ps1 = psprob(:,4);
                    z(jj+1) = zprob(4);
                    vz(jj+1) = vzprob(4);
                else
                    tvec = [tvec(1:jj),tvec(jj)/2+tvec(jj+1)/2,tvec(jj+1:end)];
                    jj = jj-1;
                end
            end
        end
    elseif numl(jj) > 1.5 && numl(jj) < 2.5 %i.e. the last contact had two points
        [~,~,~,~,errortan(1,jj+1)] = ...
            solve0(dt,z(jj),vz(jj),etao,phio,nr,Re,Delta,DTN,Fr,We,zs);
        if abs(errortan(1,jj+1))<.5
            tvec = [tvec(1:jj),tvec(jj)/2+tvec(jj+1)/2,tvec(jj+1:end)];
            jj = jj-1;
        else
            co = find(numl(jj:-1:1)~=2,1);
            [etaprob(:,3),phiprob(:,3),zprob(3),vzprob(3),psprob(1:2,3),errortan(3,jj+1)] = ...    
                solvenCorner(numl(jj-co+1),2,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                We,Ma,zs,IntMat(2,:),angleDropMP,Cang,WeS);
            co = find(numl(jj:-1:1)~=1,1);
            [etaprob(:,2),phiprob(:,2),zprob(2),vzprob(2),psprob(1,2),errortan(2,jj+1)] = ...    
                solvenCorner(numl(jj-co+1),1,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                We,Ma,zs,IntMat(1,:),angleDropMP,Cang,WeS);
            if abs(errortan(2,jj+1)) < abs(errortan(3,jj+1))
                numl(jj+1) = 1;
                eta1 = etaprob(:,2);
                phi1 = phiprob(:,2);
                ps1 = psprob(:,2);
                z(jj+1) = zprob(2);
                vz(jj+1) = vzprob(2);
            else
                co = find(numl(jj:-1:1)~=3,1);
                [etaprob(:,4),phiprob(:,4),zprob(4),vzprob(4),psprob(1:3,4),errortan(4,jj+1)] = ...    
                    solvenCorner(numl(jj-co+1),3,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                    We,Ma,zs,IntMat(3,:),angleDropMP,Cang,WeS);
                if abs(errortan(3,jj+1)) < abs(errortan(4,jj+1))
                    numl(jj+1) = 2;
                    eta1 = etaprob(:,3);
                    phi1 = phiprob(:,3);
                    ps1 = psprob(:,3);
                    z(jj+1) = zprob(3);
                    vz(jj+1) = vzprob(3);
                else
                    co = find(numl(jj:-1:1)~=4,1);
                    [~,~,~,~,~,errortan(5,jj+1)] = ...    
                        solvenCorner(numl(jj-co+1),4,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                        We,Ma,zs,IntMat(4,:),angleDropMP,Cang,WeS);
                    if abs(errortan(4,jj+1)) < abs(errortan(5,jj+1))
                        numl(jj+1) = 3;
                        eta1 = etaprob(:,4);
                        phi1 = phiprob(:,4);
                        ps1 = psprob(:,4);
                        z(jj+1) = zprob(4);
                        vz(jj+1) = vzprob(4);
                    else
                        tvec = [tvec(1:jj),tvec(jj)/2+tvec(jj+1)/2,tvec(jj+1:end)];
                        jj = jj-1;
                    end
                end
            end
        end
    elseif numl(jj)>2.5 && numl(jj)<nlmax-1.5 %if the last number of contact points was far from the boundaries
        co = find(numl(jj:-1:1)~=numl(jj),1);
        [etaprob(:,3),phiprob(:,3),zprob(3),vzprob(3),psprob(1:numl(jj),3),errortan(3,jj+1)] = ...    
            solvenCorner(numl(jj-co+1),numl(jj),dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
            We,Ma,zs,IntMat(numl(jj),:),angleDropMP,Cang,WeS);
        co = find(numl(jj:-1:1)~=numl(jj)-1,1);
        [etaprob(:,2),phiprob(:,2),zprob(2),vzprob(2),psprob(1:numl(jj)-1,2),errortan(2,jj+1)] = ...    
            solvenCorner(numl(jj-co+1),numl(jj)-1,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
            We,Ma,zs,IntMat(numl(jj)-1,:),angleDropMP,Cang,WeS);
        if abs(errortan(2,jj+1)) < abs(errortan(3,jj+1))
            co = find(numl(jj:-1:1)~=numl(jj)-2,1);
            [~,~,~,~,~,errortan(1,jj+1)] = ...
                solvenCorner(numl(jj-co+1),numl(jj)-2,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                We,Ma,zs,IntMat(numl(jj)-2,:),angleDropMP,Cang,WeS);
            if abs(errortan(2,jj+1)) < abs(errortan(1,jj+1))
                numl(jj+1) = numl(jj)-1;
                eta1 = etaprob(:,2);
                phi1 = phiprob(:,2);
                ps1 = psprob(:,2);
                z(jj+1) = zprob(2);
                vz(jj+1) = vzprob(2);
            else
                tvec = [tvec(1:jj),tvec(jj)/2+tvec(jj+1)/2,tvec(jj+1:end)];
                jj = jj-1;
            end
        else
            co = find(numl(jj:-1:1)~=numl(jj)+1,1);
            [etaprob(:,4),phiprob(:,4),zprob(4),vzprob(4),psprob(1:numl(jj)+1,4),errortan(4,jj+1)] = ...    
                solvenCorner(numl(jj-co+1),numl(jj)+1,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                We,Ma,zs,IntMat(numl(jj)+1,:),angleDropMP,Cang,WeS);
            if abs(errortan(3,jj+1))<abs(errortan(4,jj+1))
                numl(jj+1) = numl(jj);
                eta1 = etaprob(:,3);
                phi1 = phiprob(:,3);
                ps1 = psprob(:,3);
                z(jj+1) = zprob(3);
                vz(jj+1) = vzprob(3);
            else
                co = find(numl(jj:-1:1)~=numl(jj)+2,1);
                [~,~,~,~,~,errortan(5,jj+1)] = ...
                    solvenCorner(numl(jj-co+1),numl(jj)+2,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                    We,Ma,zs,IntMat(numl(jj)+2,:),angleDropMP,Cang,WeS);
                if abs(errortan(4,jj+1)) < abs(errortan(5,jj+1))
                    numl(jj+1) = numl(jj)+1;
                    eta1 = etaprob(:,4);
                    phi1 = phiprob(:,4);
                    ps1 = psprob(:,4);
                    z(jj+1) = zprob(4);
                    vz(jj+1) = vzprob(4);
                else
                    tvec = [tvec(1:jj),tvec(jj)/2+tvec(jj+1)/2,tvec(jj+1:end)];
                    jj = jj-1;
                end
            end
        end
    elseif numl(jj) > nlmax-1.5 && numl(jj) < nlmax-.5 %i.e. if last number of contacted points is nlmax-1
        co = find(numl(jj:-1:1)~=numl(jj),1);
        [etaprob(:,3),phiprob(:,3),zprob(3),vzprob(3),psprob(1:numl(jj),3),errortan(3,jj+1)] = ...    
            solvenCorner(numl(jj-co+1),numl(jj),dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
            We,Ma,zs,IntMat(numl(jj),:),angleDropMP,Cang,WeS);
        co = find(numl(jj:-1:1)~=numl(jj)-1,1);
        [etaprob(:,2),phiprob(:,2),zprob(2),vzprob(2),psprob(1:numl(jj)-1,2),errortan(2,jj+1)] = ...    
            solvenCorner(numl(jj-co+1),numl(jj)-1,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
            We,Ma,zs,IntMat(numl(jj)-1,:),angleDropMP,Cang,WeS);
        if abs(errortan(2,jj+1))<abs(errortan(3,jj+1))
            co = find(numl(jj:-1:1)~=numl(jj)-2,1);
            [~,~,~,~,~,errortan(1,jj+1)] = ...    
                solvenCorner(numl(jj-co+1),numl(jj)-2,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                We,Ma,zs,IntMat(numl(jj)-2,:),angleDropMP,Cang,WeS);
            if abs(errortan(2,jj+1)) < abs(errortan(1,jj+1))
                numl(jj+1) = numl(jj)-1;
                eta1 = etaprob(:,2);
                phi1 = phiprob(:,2);
                ps1 = psprob(:,2);
                z(jj+1) = zprob(2);
                vz(jj+1) = vzprob(2);
            else
                tvec = [tvec(1:jj),tvec(jj)/2+tvec(jj+1)/2,tvec(jj+1:end)];
                jj = jj-1;
            end
        else
            co = find(numl(jj:-1:1)~=numl(jj)+1,1);
            [etaprob(:,4),phiprob(:,4),zprob(4),vzprob(4),psprob(1:numl(jj)+1,4),errortan(4,jj+1)] = ...    
                solvenCorner(numl(jj-co+1),numl(jj)+1,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                We,Ma,zs,IntMat(numl(jj)+1,:),angleDropMP,Cang,WeS);
            if abs(errortan(3,jj+1)) < abs(errortan(4,jj+1))
                numl(jj+1) = numl(jj);
                eta1 = etaprob(:,3);
                phi1 = phiprob(:,3);
                ps1 = psprob(:,3);
                z(jj+1) = zprob(3);
                vz(jj+1) = vzprob(3);
            else
                numl(jj+1) = numl(jj)+1;
                eta1 = etaprob(:,4);
                phi1 = phiprob(:,4);
                ps(:,jj+1) = psprob(:,4);
                z(jj+1) = zprob(4);
                vz(jj+1) = vzprob(4);
            end
        end
    else %i.e. if last number of contact points was nlmax
        co = find(numl(jj:-1:1)~=numl(jj),1);
        [etaprob(:,3),phiprob(:,3),zprob(3),vzprob(3),psprob(1:numl(jj),3),errortan(3,jj+1)] = ...    
            solvenCorner(numl(jj-co+1),numl(jj),dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
            We,Ma,zs,IntMat(numl(jj),:),angleDropMP,Cang,WeS);
        co = find(numl(jj:-1:1)~=numl(jj)-1,1);
        [etaprob(:,2),phiprob(:,2),zprob(2),vzprob(2),psprob(1:numl(jj)-1,2),errortan(2,jj+1)] = ...    
            solvenCorner(numl(jj-co+1),numl(jj)-1,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
            We,Ma,zs,IntMat(numl(jj)-1,:),angleDropMP,Cang,WeS);
        if abs(errortan(2,jj+1)) < abs(errortan(3,jj+1))
            co = find(numl(jj:-1:1)~=numl(jj)-2,1);
            [~,~,~,~,~,errortan(1,jj+1)] = ...
                solvenCorner(numl(jj-co+1),numl(jj)-2,dt,z(jj),vz(jj),etao,phio,nr,dr,Re,Delta,DTN,Fr,...
                We,Ma,zs,IntMat(numl(jj)-2,:),angleDropMP,Cang,WeS);
            if abs(errortan(2,jj+1)) < abs(errortan(1,jj+1))
                numl(jj+1) = numl(jj)-1;
                eta1 = etaprob(:,2);
                phi1 = phiprob(:,2);
                ps1 = psprob(:,2);
                z(jj+1) = zprob(2);
                vz(jj+1) = vzprob(2);
            else
                tvec = [tvec(1:jj),tvec(jj)/2+tvec(jj+1)/2,tvec(jj+1:end)];
                jj = jj-1;
            end
        else
            numl(jj+1) = numl(jj);
            eta1 = etaprob(:,3);
            phi1 = phiprob(:,3);
            ps(:,jj+1) = psprob(:,3);
            z(jj+1) = zprob(3);
            vz(jj+1) = vzprob(3);
        end
    end
    etaOri(jj+1) = eta1(1);


    eta = eta1;
    phi = phi1;

    jj0 = floor(jj/nsteps);
    jj1 = round(jj-jj0*nsteps);
%     if jj<10*nsteps || jj>=222*nsteps
    etaMatPer(:,jj1+1) = eta;
    phiMatPer(:,jj1+1) = phi;
    psMatPer(:,jj1+1) = ps1;
    if jj1 == nsteps-1
        if runNumber == 0
            tiempoComp(jj0+1)=toc(tstart);
        end
        save(['etaMatPer',num2str(jj0+1),'.mat'],'etaMatPer')
        save(['phiMatPer',num2str(jj0+1),'.mat'],'phiMatPer')
        save(['psMatPer',num2str(jj0+1),'.mat'],'psMatPer')
%         save('qq.mat','qq')
        save('etaOri.mat','etaOri')
        save('z.mat','z')
        save('vz.mat','vz')
        save('tvec.mat','tvec')
        save('numl.mat','numl')
        save('errortan.mat','errortan')
    end
%     end
    etao = eta1;
    phio = phi1;
    pso = ps1;

    etaplot=[flipud(eta(2:nr));eta];
    plot(xdrop,(z(jj+1))+zdrop,'k','Linewidth',4);
    hold on
    width = 200;
    plot([-fliplr(xplot(2:width)),xplot(1:width)],[flipud(eta1(2:width));eta1(1:width)],'LineWidth',4);
    hold off
    axis equal
    title(['   t = ',num2str(t),'   ','nl = ',num2str(numl(jj+1))],'FontSize',16);
    drawnow;

    tComp = toc(tstart);
    if jj1==0 && tComp > tmax
        runNumber = runNumber+1;
        save('runNumber.mat','runNumber')
        tstop = t;
        save(['tstop',num2str(runNumber),'.mat'],'tstop')
        jjstop = jj;
        save(['jjstop',num2str(runNumber),'.mat'],'jjstop')
        save(['etao',num2str(runNumber),'.mat'],'etao')
        save(['phio',num2str(runNumber),'.mat'],'phio')
        save(['pso',num2str(runNumber),'.mat'],'pso')

        zrestart = z(jj+1);
        vzrestart = vz(jj+1);
        trestart = tvec(jj+1);
        numlrestart = numl(jj+1);
        save(['zrestart',num2str(runNumber),'.mat'],'zrestart')
        save(['vzrestart',num2str(runNumber),'.mat'],'vzrestart')
        save(['trestart',num2str(runNumber),'.mat'],'trestart')
        save(['numlrestart',num2str(runNumber),'.mat'],'numlrestart')

        save('etaOri.mat','etaOri')
        save('z.mat','z')
        save('vz.mat','vz')
        save('tvec.mat','tvec')
        save('numl.mat','numl')
        save('errortan.mat','errortan')
        if runNumber == 1
            save('tiempoComp.mat','tiempoComp')
        end
        exit
    end
end

runNumber = runNumber+1;
tstop = t;
save(['tstop',num2str(runNumber),'.mat'],'tstop')
jjstop = jj;
save(['jjstop',num2str(runNumber),'.mat'],'jjstop')
save(['etao',num2str(runNumber),'.mat'],'etao')
save(['phio',num2str(runNumber),'.mat'],'phio')
save(['pso',num2str(runNumber),'.mat'],'pso')

zrestart = z(jj+1);
vzrestart = vz(jj+1);
trestart = tvec(jj+1);
numlrestart = numl(jj+1);
save(['zrestart',num2str(runNumber),'.mat'],'zrestart')
save(['vzrestart',num2str(runNumber),'.mat'],'vzrestart')
save(['trestart',num2str(runNumber),'.mat'],'trestart')
save(['numlrestart',num2str(runNumber),'.mat'],'numlrestart')

save('etaOri.mat','etaOri')
save('z.mat','z')
save('vz.mat','vz')
save('tvec.mat','tvec')
save('numl.mat','numl')
save('errortan.mat','errortan')

% runNumber = -10;
% save('runNumber.mat','runNumber')
% exit






