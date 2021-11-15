function NEW_test_normal_tangent_fields()
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILTERING and INTERPOLATION for NORMAL/TANGENT FIELDS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nmode=3;%pick method to compute normal field along the edge ring
%0: GRADIENT-FIELD through the edge (LESS PRECISE on the edge and FASTER than nmode==2)
%1: NATURAL-SPLINE FIT to the edge (NOT RECOMMENDED)
%2: PIECE-WISE SPLINE FIT to the edge (NOT RECOMMENDED)
%3: PIECE-WOSE POLYNOMIAL FIT to the edge (RECCOMMENDED, BEST WORKING)
fmode=1;%pick filtering method to compute the entire normal field
%1: filtering (RECOMMENDED - SLOWER but more PRECISE)
%   the normal field to the edge ring is computed and the normal field for EACH ONE of other rings is computed and interpolated from that relative to the edge
%0: no filtering (the normal field to each ring is computed)
emode=0; %EDGE MODE selects whether normal/tangent fields should be determined via a distance or ring criterion (see subroutine nr_tg_field_crvrmls)
% 0: rings for normal field are determined via distances from edge (RECOMMENDED);
% 1: rings for normal field are taken from ring mask

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD SAMPLE MASK TOPOLOGIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
usemode=1;%SAME as TMSK below
%0: load a sample WOUND        mask;
%1: load a sample ISLAND       mask;
%2: load a sample STRIP        mask;
%3: load a sample SCRATCH      mask (two epithelia collision);
%4: load a sample 2-WOUND      mask;
%5: load a sample 2-ISLAND     mask;
%6: load a sample WOUND-ISLAND mask (one epithelium surrounding an island);
msk=loadmask(usemode);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
edgeonly=0;%only plot normal/tangent fields to the edge ring
compare=0;%compare with previously developed methods
overlap=0;%overlap fields computed via different methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%COMPUTE RING MASK
[tmsk]=detmasktopology(msk);%determine topology of the mask (wound, island(s), strip etc..)
[pmsk,iom,jom]=padmask(msk,tmsk);
[rpmsk]=ringmask(pmsk,1,tmsk);%find ring masks of msk
% NORMAL FIELD and TANGENT FIELD
if tmsk~=4||tmsk~=5
    [pnx,pny,ptx,pty]=nr_tg_field_crvrmls(msk,rpmsk,tmsk,emode,nmode,fmode);
    %TRIM
    % back to msk original size
    rmsk=rpmsk(iom:iom+size(msk,1)-1,jom:jom+size(msk,2)-1);%ringmask
    nx1=pnx(iom:iom+size(msk,1)-1,jom:jom+size(msk,2)-1);%x-components of the normal field
    ny1=pny(iom:iom+size(msk,1)-1,jom:jom+size(msk,2)-1);%y-components of the normal field
    tx1=ptx(iom:iom+size(msk,1)-1,jom:jom+size(msk,2)-1);%x-components of the tangent field
    ty1=pty(iom:iom+size(msk,1)-1,jom:jom+size(msk,2)-1);%y-components of the tangent field
    %CROSS-CHECK with some of the previous methods
    if compare==1&&tmsk==1
        [nx2,ny2,tx2,ty2,~]=nr_tg_field_edgnrmls(~msk,2,3);
        [nx3,ny3,tx3,ty3,~]=nr_tg_field_curv(msk);
        [nx4,ny4,tx4,ty4,~]=nr_tg_field_curv_original(~msk);
    end
end

%PLOTS
if tmsk~=4||tmsk~=5%TOPOLOGIES tmsk==4 and tmsk==5 are implemented but have not been debugged
    %PLOT EDGE FIELD
    emsk=zeros(size(msk));
    emsk(rmsk==0)=1;
    emsk_forplots=ones(size(msk));
    emsk_forplots(rmsk==0)=0;
    if (edgeonly==1)
        nx1=nx1.*emsk; ny1=ny1.*emsk; tx1=tx1.*emsk; ty1=ty1.*emsk;
        if compare==1
            nx2=nx2.*emsk; ny2=ny2.*emsk; tx2=tx2.*emsk; ty2=ty2.*emsk;
            nx3=nx3.*emsk; ny3=ny3.*emsk; tx3=tx3.*emsk; ty3=ty3.*emsk;
            nx4=nx4.*emsk; ny4=ny4.*emsk; tx4=tx4.*emsk; ty4=ty4.*emsk;
        end
    end
    %NORMALS
    figure,imagesc(emsk_forplots);colormap('gray');hold on; %REMEMBER: imagesc has y axis upside down wherease quiver has it in cartesian mode, so masks need to be flipped
    quiver(nx1,ny1,'color',[1 0 0]);
    if compare==1&&tmsk==1
        if overlap==0
            hold off;
            figure,imagesc(emsk_forplots);colormap('gray');hold on; %REMEMBER: imagesc has y axis upside down wherease quiver has it in cartesian mode, so masks need to be flipped
        end
        quiver(nx2,ny2,'color',[0 1 0]);
        if overlap==0
            hold off;
            figure,imagesc(emsk_forplots);colormap('gray');hold on; %REMEMBER: imagesc has y axis upside down wherease quiver has it in cartesian mode, so masks need to be flipped
        end
        quiver(nx3,ny3,'color',[0 0 1]);
        if overlap==0
            hold off;
            figure,imagesc(emsk_forplots);colormap('gray');hold on; %REMEMBER: imagesc has y axis upside down wherease quiver has it in cartesian mode, so masks need to be flipped
        end
        quiver(nx4,ny4,'color',[1 0 1]);hold off;
    end
    %TANGENTS
    figure,imagesc(emsk_forplots);colormap('gray');hold on; %REMEMBER: imagesc has y axis upside down wherease quiver has it in cartesian mode, so masks need to be flipped
    quiver(tx1,ty1,'color',[1 0 0]);
    if compare==1&&tmsk==1
        if overlap==0
            hold off;
            figure,imagesc(emsk_forplots);colormap('gray');hold on; %REMEMBER: imagesc has y axis upside down wherease quiver has it in cartesian mode, so masks need to be flipped
        end
        quiver(tx2,ty2,'color',[0 1 0]);
        if overlap==0
            hold off;
            figure,imagesc(emsk_forplots);colormap('gray');hold on; %REMEMBER: imagesc has y axis upside down wherease quiver has it in cartesian mode, so masks need to be flipped
        end
        quiver(tx3,ty3,'color',[0 0 1]);
        if overlap==0
            hold off;
            figure,imagesc(emsk_forplots);colormap('gray');hold on; %REMEMBER: imagesc has y axis upside down wherease quiver has it in cartesian mode, so masks need to be flipped
        end
        quiver(tx4,ty4,'color',[1 0 1]);
    end
else
    error('normal and tangent fields for mask topologies of this type have not been implemented yet');
end
end
function [mad]=maxalldims(a)%#ok
%it computes the max of an array along all its dimenstions
mad=max(a(:));
end
function [tmsk]=detmasktopology(msk)
%by Vito Conte
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IT DETERMINEs MASK's TYPOLOGY (wound, island, strip or scratch etc...)
%tmsk=0: WOUND        mask;
%tmsk=1: ISLAND       mask;
%tmsk=2: STRIP        mask;
%tmsk=3: SCRATCH      mask (two epithelia collision);
%tmsk=4: 2-WOUND      mask;
%tmsk=5: 2-ISLAND     mask;
%tmsk=6: WOUND-ISLAND mask (one epithelium surrounding an island);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=size(msk,1);
n=size(msk,2);
cmsk=~msk;%mask's complement
CC=bwconncomp(msk);
ncc=CC.NumObjects;%total number of connected components in mask
CC=bwconncomp(cmsk);
cncc=CC.NumObjects;%total number of connected components in the complement of the mask
if nnz(msk)==m*n%WOUND-ISLAND
    tmsk=6;
else
    switch ncc
        case{1}%ISLAND or STRIP or WOUND or 2-WOUND
            CC=regionprops(msk,'all');
            ngp=ncc-CC.EulerNumber;%total number of gaps in the mask
            switch ngp
                case{0}%ISLAND or STRIP
                    if cncc==1%it's an ISLAND
                        tmsk=1;%mask type island
                    elseif cncc==2%STRIP
                        tmsk=2;%mask type strip
                    end
                case{1}%WOUND or SCRATCH
                    tmsk=0;%mask type wound
                case{2}%TWO WOUNDS
                    tmsk=4;%mask type 2-wound
                otherwise %nmsk>2
                    error('no more than two wounds are allowed right now, please check mask');
            end
        case{2}%SCRATCH or 2-ISLAND
            CC=regionprops(cmsk,'all');
            cngp=cncc-CC.EulerNumber;%total number of gaps in the complement of the mask
            switch cngp
                case{0}%SCRATCH
                    tmsk=3;%mask type scratch
                case{2}%2-ISLAND
                    tmsk=5;%mask type 2-island
                otherwise
                    error('no more than one scratch or two islands are permitted, please check mask');
            end
        otherwise
            error('no more than two islands are permitted, please check mask');
    end
end
end
function [opmsk,iom,jom]=padmask(omsk,tmsk)
% by Vito Conte
pdsz=1;%set the size of the padding on each side of the mask
ndp=2*pdsz+1;%and ndp an odd number
cntr=floor(ndp/2)+1;
msk=logical(omsk);%make sure original mask omsk is made of all ones and zeros
m=size(msk,1);n=size(msk,2);
clr=0; %set to 1 to display in different colours the expansion domains that are added

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PAD the MASK depending on its topology
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch tmsk
    case{2,3} %SHIFT EDGE EFFECTS depending on topology
        % STEP 1: push top and bottom edge effects far away by repeating top and bottom edges
        tb_msk=NaN(ndp*m,n);%repeat top and bottom edges to account for the strip case (strip is assumed to always run from top to bottom)
        tb_msk(1:m*pdsz,:)=repmat(msk(1,:),[numel(1:m*pdsz),1])+2*clr*ones(size(repmat(msk(1,:),[numel(1:m*pdsz),1])));%top
        tb_msk(m*pdsz+1:m*cntr,:)=msk;%centre
        tb_msk(m*cntr+1:m*ndp,:)=repmat(msk(m,:),[numel(m*cntr+1:m*ndp),1])+3*clr*ones(size(repmat(msk(m,:),[numel(m*cntr+1:m*ndp),1])));%bottom
        tb_m=size(tb_msk,1);tb_n=size(tb_msk,2);
        if any(isnan(tb_msk)), error('something fishy here, please check mask'); end
        % STEP 2: push left and right edge effects far away by repeating left and right edges
        lrtb_msk=NaN(tb_m,ndp*tb_n);
        lrtb_msk(:,1:n*pdsz,:)=repmat(tb_msk(:,1),[1,numel(1:n*pdsz)])+4*clr*ones(size(repmat(tb_msk(:,1),[1,numel(1:n*pdsz)])));%left
        lrtb_msk(:,n*pdsz+1:n*cntr)=tb_msk;%centre
        lrtb_msk(:,n*cntr+1:n*ndp)=repmat(tb_msk(:,n),[1,numel(n*cntr+1:n*ndp)])+5*clr*ones(size(repmat(tb_msk(:,n),[1,numel(n*cntr+1:n*ndp)])));%right
        lrtb_m=size(lrtb_msk,1);lrtb_n=size(lrtb_msk,2);
        if clr~=0
            fimg(lrtb_msk);
            stop;
        end
        % STEP3: transform mask in wounds/islands by adding (a further) padding of ones or zeros depending on mask topology
        switch tmsk
            case{0,3}%WOUND or SCRATCH, ADD a PADDING of 1s
                pmsk=ones(ndp*lrtb_m,ndp*lrtb_n);
            otherwise %ADD PADDING of 0s
                pmsk=zeros(ndp*lrtb_m,ndp*lrtb_n);
        end
        pmsk(lrtb_m*pdsz+1:end-lrtb_m*pdsz,lrtb_n*pdsz+1:end-lrtb_n*pdsz)=lrtb_msk;%CENTRE
        iom=lrtb_m*pdsz+m*pdsz+1;%vertical component of grid location at which msk is inserted in pmsk (this will be needed to trim back to msk from pmsk)
        jom=lrtb_n*pdsz+n*pdsz+1;%horizontal component of grid location at which msk is inserted in pmsk (this will be needed to trim back to msk from pmsk)
    otherwise %i.e. tmsk=0,1,4,5
        if tmsk==1||tmsk==5%EDGE EFFECTS can BE SHIFTED by DIRECTLY ADDING a PADDING of ZEROS in the case ISLAND or 2-ISLAND
            lrtb_msk=zeros(ndp*m,ndp*n);
        elseif tmsk==0||tmsk==4||tmsk==6%EDGE EFFECTS can BE SHIFTED by DIRECTLY ADDING a PADDING of ONES in the case WOUND or 2-WOUND
            lrtb_msk=ones(ndp*m,ndp*n);
        end
        lrtb_msk(m*pdsz+1:end-m*pdsz,n*pdsz+1:end-n*pdsz)=msk;%CENTRE
        pmsk=lrtb_msk;%no need to add further padding and lengthen computation
        iom=m*pdsz+1;%vertical component of grid location at which msk is inserted in pmsk (this will be needed to trim back to msk from pmsk)
        jom=n*pdsz+1;%horizontal component of grid location at which msk is inserted in pmsk (this will be needed to trim back to msk from pmsk)
end
tmpmsk=pmsk(iom:iom+m-1,jom:jom+n-1);%trim pmsk back to msk to cross-check the whole padding procedure has been done correctly
if ~isequal(tmpmsk,msk), error('this is not possible, please check mask');end
opmsk=pmsk;
opmsk(iom:iom+m-1,jom:jom+n-1)=omsk;%restore original values in pmsk (in case multiple connected regions are present like in the cases 2-ISLAND and wOUND-ISLAND)
end
function [emsk]=findedge(omsk,thck,usemode)
%it determines the edge of the mask that is thck-pixels thick via the erosion method (the most precise)
if usemode ==6 %WOUND-ISLAND case
    msk=omsk;
    msk(msk==1)=0;%annihilate surrounding population and treat msk as an ISLAND mask
    msk=logical(msk); %make sure mask elements are only 0s and/or 1s
else%in all other cases
    msk=logical(omsk); %make sure mask elements are only 0s and/or 1s
end
se=strel('square',2*thck+1);%structural dilation object to dilate drftdlt nubmer of pixels
rmsk=imerode(msk,se);
emsk=msk-rmsk;
emsk=emsk.*omsk;%make sure edges get same original values as msk to preserve possible multiple components like in the cases 2-ISLANDS or WOUND-ISLAND
end
function [rmsk]=ringmask(omsk,r,tmsk)
%by Vito Conte
%it creates r-thick rings of a mask depending on its topology
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('computing ring mask');
[e_omsk]=findedge(omsk,1,tmsk);%find edges
fmsk=imfill(e_omsk,'holes');%and fill them so to assume it's always one or more islands
rmsk=NaN(size(omsk));%rings mask
irmsk=NaN(size(omsk));%mask of internal rings
switch tmsk
    case{0,1,2,3,6}%individual connected-region msk
        [irmsk]=innrings(fmsk,r);%generate rings internal to edge
    case{4,5}%multiple connected-region msk
        vals=unique(omsk(omsk~=0));
        cmpmsk=zeros([size(omsk),numel(vals)]);
        for i=vals'
            auxmsk=zeros(size(omsk));
            auxmsk(omsk==vals(i))=1;
            [cmpmsk(:,:,i)]=innrings(auxmsk,r);%generate rings internal to edge
        end
        %compute interior rings
        auxcmpmsk_1=squeeze(cmpmsk(:,:,1));
        irmsk(auxcmpmsk_1<=0,1)=cmpmsk(auxcmpmsk_1<=0,1);
        for ic=2:nmbr%interior rings of each component are inherited from interior rings of each subcomponent
            auxcmpmsk_ic=squeeze(cmpmsk(:,:,ic));
            auxcmpmsk_icm1=squeeze(cmpmsk(:,:,ic-1));
            irmsk(auxcmpmsk_ic<=0)=auxcmpmsk_ic(auxcmpmsk_ic<=0)+(ic-1)*min(auxcmpmsk_icm1(:));
        end
        %               irmsk(~isnan(auxcmpmsk))=auxcmpmsk(~isnan(auxcmpmsk));
end
switch tmsk
    case{0,1,2,3,6}%individual connected-region msk
        [ormsk]=outrings(fmsk,r,1);%generate rings external to edge
    case{4,5}%multiple connected-region msk
        [ormsk]=outrings(fmsk,r,2);%generate rings external to edge
end

%algorithm has labelled rings extaran to the edge as positive and those internal to the edge negative
%we now wish that rings corresponding to the epithelium of interest are positive and this depends on mask topology (i.e. tmsk)
switch tmsk
    case{1,2,5,6}%epithelium of interest is internal to edge
        rmsk(~isnan(ormsk))=-ormsk(~isnan(ormsk));
        rmsk(~isnan(irmsk))=irmsk(~isnan(irmsk));
    otherwise%epithelium of interest is external to edge
        rmsk(~isnan(ormsk))=ormsk(~isnan(ormsk));
        rmsk(~isnan(irmsk))=-irmsk(~isnan(irmsk));
end
disp('ring mask computed');
end
function [irmsk]=innrings(omsk,r)
%by Vito Conte
% it computes inner rings of a single connected region from its edge
msk=logical(omsk);
m=size(msk,1);
n=size(msk,2);
se=strel('square',2*r+1);%structural erosion object made of dilatetype nubmer of pixels
irmsk=NaN([m,n]);
irmsk(msk~=0)=0;
kr=0;% internal rings  will start from 0 (the border/edge)
crnterdmsk=msk;%current eroded mask
keepringing=1;%flag checking the inner most ring is made of one piece/lable only
while keepringing%there still are ring positions to be filled (inner most core is still made of one connected region)
    erdmsk=imerode(crnterdmsk,se);
    %[erdmsk]=weaken_loose_connections(erdmsk);
    CC=bwconncomp(erdmsk,4);
    if CC.NumObjects==1
        intring=kr.*(crnterdmsk-erdmsk);
    else%avoid spliting of central region
        intring=kr.*crnterdmsk;%set last internal ring to previous intr value
        keepringing=0;%stop ringing
    end
    %update cmprings, crntdltmsk and crnterdmsk to current variables
    irmsk=irmsk+intring;
    crnterdmsk=erdmsk;
    kr=kr+1;
end
end
function [ormsk]=outrings(omsk,r,usemode)
%by Vito Conte
% it computes outer rings of a single (usemode==1) or double (usemode=2) connected region from its edge
msk=logical(omsk);
m=size(msk,1);
n=size(msk,2);
se=strel('square',2*r+1);%structural dilation object made of dilatetype nubmer of pixels
ormsk=NaN([m,n]);
ormsk(msk==0)=0;
kr=1;% external rings  will start from 1 (the border/edge is labelled 0 and it's already included in the inner rings)
crntdltmsk=msk;%current eroded mask
keepringing=1;%flag checking the inner most ring is made of one piece/lable only
if usemode==1
    while keepringing%there still are ring positions to be filled (inner most core is still made of one connected region)
        dltmsk=imdilate(crntdltmsk,se);
        %[erdmsk]=weaken_loose_connections(erdmsk);
        outring=kr.*(dltmsk-crntdltmsk);
        
        CC=bwconncomp(outring,4);
        if CC.NumObjects>1,keepringing=0;end%current external ring has crossed the fieald of view and we can stop
        
        ormsk=ormsk+outring;%update
        crntdltmsk=dltmsk;%update
        kr=kr+1;%update
    end
else
    while keepringing%there still are ring positions to be filled (inner most core is still made of one connected region)
        dltmsk=imdilate(crntdltmsk,se);
        %[erdmsk]=weaken_loose_connections(erdmsk);
        outring=kr.*(dltmsk-crntdltmsk);
        CC=bwconncomp(outring,4);
        if CC.NumObjects==1%the two rings have started touching each other
            %since there are two connected regions there will always be two rings
            %except when the fing of each individual connected component are touching each other there will be one ring only
            xoutring=zeros(size(msk)+2);%define a matrix two units bigger than msk all the way round
            xoutring(2:end-1,2:end-1)=outring;
            %check if external rings are in tangent contact (one or two inner connected regions) or secant contact (more than two inner connected regions)
            fxoutring=imfill(xoutring,'holes');%fill holes in fextring to make it an individual connected region
            DD=bwconncomp(fxoutring-xoutring,4);
            if DD.NumObjects>2,xoutring=fxoutring-imerode(fxoutring,se);end%only consider secant contact when more than two inner connected regions have more than one pixel each
            outring=xoutring(2:end-1,2:end-1);%downsize two units and get back to mask size
        elseif CC.NumObjects>2
            keepringing=0;%current external ring has crossed the fieald of view and we can stop
        end
        ormsk=ormsk+outring;%update
        crntdltmsk=dltmsk;%update
        kr=kr+1;%update
    end
end
%there might be empty spaces left around so we need to check if any zero area has been left behind
fkr=kr-1;%give last ring's value to avoid creating a new fragmented ring
xoutring=fkr*ones(size(msk)+2);%define a matrix two units bigger than msk all the way round having values as the most external available ring
xoutring(2:end-1,2:end-1)=ormsk;
xoutring(xoutring==0)=fkr;
edgepocket=zeros(size(msk)+2);
edgepocket(xoutring==fkr)=1;%the only zero pockets should be around the edge end now form a single connected region
CC=bwconncomp(edgepocket,4);
if CC.NumObjects>2
    error('some other empty spaces might have been filled in the ring mask with most external value');%this should not be allowed
elseif CC.NumObjects==1
    ormsk=xoutring(2:end-1,2:end-1);%downsize two units and get back to mask size
end
end
function [nx,ny,tx,ty]=nr_tg_field_crvrmls(omsk,rmsk,tmsk,emode,nmode,fmode)
disp('computing normal/tangent fields');
%by Vito Conte
%msk: original mask
%rmsk: padded ring mask
%emode: edge mode; 0: rings for normal field are determined via distances from edge; 1: rings for normal field are taken from ring mask
%nmode: selects algorithm for computation of normals to the ring cuves
%fmode: 1, it filter based on distance from ring edge; 0, it doesn't filter
om=size(omsk,1);on=size(omsk,2);
m=size(rmsk,1);n=size(rmsk,2);
emsk=zeros(size(rmsk));%edge mask
emsk(rmsk==0)=1;
switch emode
    case{0}%rings for normal field are determined via distances from edge
        [dstmsk,bwlocs]=bwdist(emsk);
        dstmsk=round(dstmsk);
    case{1}%rings for normal field are taken from ring mask
      [~,bwlocs]=bwdist(emsk);
      dstmsk=rmsk;
    otherwise
        error('no other emode implemented for the moment');
end
rvals=unique(dstmsk(:));%ring lables
nrx=zeros(m,n);%x-component of normals to rings
nry=zeros(m,n);%y-component of normals to rings
if fmode==1%compute normals only for edge ring and then interpolate the field for EACH of the remaining rings
    [enx,eny,elocs]=crvnrmls(emsk,nmode);
    nrx(elocs)=enx;
    nry(elocs)=eny;
    %STEP1: ROUGHLY INFER THE ENTIRE NORMAL FIELD FROM THE FIELD NORMAL TO THE EDGE RING
    for r=min(rvals):max(rvals)
        nrx(dstmsk==r)=nrx(bwlocs(dstmsk==r));%each other grid location in the normal field gets the normal vector value of the closest location on the edge
        nry(dstmsk==r)=nry(bwlocs(dstmsk==r));%each other grid location in the normal field gets the normal vector value of the closest location on the edge
    end
    fnrx=zeros(m,n);
    fnry=zeros(m,n);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %STEP 2: FILTER AND SMOOTHEN THE FIELD BASED ON DISTANCE FROM EDGE RING
    %n.B. THIS IS THE MOST COMPUTATIONALLY-EXPENSIVE LOOP and IMPROVEMENTS ARE STILL REQUIRED HERE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    switch tmsk%SET max number of external rings to filter (the higher the more computationally expensive)
        %N.B. it's not necessary to set extrings_filt=max(rvals) because the original mask omsk is at the centre of the current rmsk
        %thus, the filtering of a central region covering the surface of the omsk will be enough
        case{0,1,4,5,6}%wounds and islands cases
            extrings_filt=max([om,on]);%max number of external rings to filter (the higher the more computationally expensive)
        case{2,3}%strip/scratch cases
            %masks here always touch the top and bottom border of the field of view of the omsk and a smaller value of extrings_filt can
            %be utilised whilst still pushing edge effect out of the field of view
            extrings_filt=max([om,on]/2);
    end
    max_neighb_size=max([round(om/8),round(on/8)]);%max neighbour size over which filtering is performed (the bigger the slower)
    for r=min(rvals):extrings_filt%FILTER FIELD w.r.t. to DISTANCE from EDGE: THE FARTHER AWAY THE BIGGER THE AVERAGING NEIGHBOUROOD
        smthn=min([abs(r),max_neighb_size]);%number of neighbours over which to filter image (maxium one fourth of the size of the original max)
        knghb=ones(2*smthn+1,2*smthn+1);%neighbourhood of central element in position (smthn+1,smthn+1)
        avknghb=knghb/nnz(knghb);%average of first neighbours around central element of knghb in position (2,2)
        % vector orientation in each location (i,j) is replaced by average of its neighbours over a distance-dependent neighbour size
        chnx=conv2(nrx,avknghb,'same');
        chny=conv2(nry,avknghb,'same');
        fnrx(dstmsk==r)=chnx(dstmsk==r);
        fnry(dstmsk==r)=chny(dstmsk==r);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %normalise
    nx=fnrx./sqrt(fnrx.^2+fnry.^2);
    ny=fnry./sqrt(fnrx.^2+fnry.^2);
else%compute normals ring by ring
    rvals=unique(rmsk(:));%ring lables
    for r=2:numel(rvals)%the most external ring (r==1) is problematic because it'fragmented
        cringmsk=zeros(size(rmsk));%current ring mask
        cringmsk(rmsk==rvals(r))=1;
        [rnx,rny,rlocs]=crvnrmls(cringmsk,nmode);
        nrx(rlocs)=rnx;
        nry(rlocs)=rny;
    end
    nx=nrx./sqrt(nrx.^2+nry.^2);
    ny=nry./sqrt(nrx.^2+nry.^2);
end
ndir3D=zeros(m,n,3);
ndir3D(:,:,1)=nx;
ndir3D(:,:,2)=ny;
ndir3D(:,:,3)=zeros(m,n);
zdir3D=zeros(m,n,3);
zdir3D(:,:,1)=zeros(m,n);
zdir3D(:,:,2)=zeros(m,n);
zdir3D(:,:,3)=ones(m,n);
tdir3D=cross(ndir3D,zdir3D);
tx=squeeze(tdir3D(:,:,1));
ty=squeeze(tdir3D(:,:,2));
disp('normal/tangent fields computed');
end
function [nx,ny,tgx,tgy,edst]=nr_tg_field_edgnrmls(msk,emode,nmode)
%by Vito Conte - adapted from a previous verison by Agust� Brugues and Xavier Trepat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IMPORTANT: mask msk is assumed to be in the WOUND topology (a hole of zeros in the middle of a grid of ones
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%WARNING:algorithm works best if wound/island is in the middle of the mask - add a frame of pixels all around msk, pn_fldx,pn_fldy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ndp=2;
ndp=2*ndp+1;%make sure ndp is odd
hndp=floor(ndp/2);
msk=logical(msk);%make sure mask as all ones and zeros
m=size(msk,1);n=size(msk,2);
hmsk=ones(ndp*size(msk,1),ndp*size(msk,2));
hmsk(m*hndp+1:end-m*hndp,n*hndp+1:end-n*hndp)=msk;
hm=size(hmsk,1);hn=size(hmsk,2);
[enx,eny,elocs,ehdst,bwlocs]=edgnrmls(hmsk,emode,nmode);
edgnx=zeros(hm,hn);
edgny=zeros(hm,hn);
edgnx(elocs)=enx;
edgny(elocs)=eny;
ehdst=round(ehdst);
rhvals=unique(ehdst(:))';
edst=ehdst(m*hndp+1:end-m*hndp,n*hndp+1:end-n*hndp);
rvals=unique(edst(:))';
for r=min(rhvals):max(rhvals)
    edgnx(ehdst==r)=edgnx(bwlocs(ehdst==r));
    edgny(ehdst==r)=edgny(bwlocs(ehdst==r));
end
hnx=zeros(hm,hn);
hny=zeros(hm,hn);
for r=min(rvals):max(rvals)%FILTER FIELD w.r.t. to DISTANCE from EDGE
    smthn=abs(r);%number of neighbours over which to filter image
    knghb=ones(2*smthn+1,2*smthn+1);%neighbourhood of central element in position (smthn+1,smthn+1)
    avknghb=knghb/nnz(knghb);%average of first neighbours around central element of knghb in position (2,2)
    % vector orientation in each location (i,j) is replaced by average of its neighbours over a distance-dependent neighbour size
    chnx=conv2(edgnx,avknghb,'same');
    chny=conv2(edgny,avknghb,'same');
    hnx(ehdst==r)=chnx(ehdst==r);
    hny(ehdst==r)=chny(ehdst==r);
end
hnx=hnx./sqrt(hnx.^2+hny.^2);
hny=hny./sqrt(hnx.^2+hny.^2);
nx=hnx(m*hndp+1:end-m*hndp,n*hndp+1:end-n*hndp);
ny=hny(m*hndp+1:end-m*hndp,n*hndp+1:end-n*hndp);
nx=nx./sqrt(nx.^2+ny.^2);
ny=ny./sqrt(nx.^2+ny.^2);
nf=zeros(m,n,3);
nf(:,:,1)=nx;
nf(:,:,2)=ny;
nf(:,:,3)=zeros(m,n);
zf=zeros(m,n,3);
zf(:,:,1)=zeros(m,n);
zf(:,:,2)=zeros(m,n);
zf(:,:,3)=ones(m,n);
tf=cross(nf,zf);
tgx=squeeze(tf(:,:,1));
tgy=squeeze(tf(:,:,2));
end
function [nrx,nry,tgx,tgy,edst]=nr_tg_field_curv(msk)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% by Vito Conte 07/09/2018  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IMPORTANT: mask msk is assumed to be in the ISLAND topology (an island of ones in the middle of a grid of zeros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%WARNING:algorithm works best if wound/island is in the middle of the mask - add a frame of pixels all around msk, pn_fldx,pn_fldy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ndp=2;
ndp=2*ndp+1;%make sure ndp is odd
hndp=floor(ndp/2);
msk=logical(msk);%make sure mask as all ones and zeros
m=size(msk,1);n=size(msk,2);
hmsk=zeros(ndp*size(msk,1),ndp*size(msk,2));
hmsk(m*hndp+1:end-m*hndp,n*hndp+1:end-n*hndp)=msk;
hm=size(hmsk,1);hn=size(hmsk,2);
%determine centre of mass of the epithelium
emsk=edge(msk);
edst=bwdist(emsk);
edst(msk==1)=-edst(msk==1);
edst=round(edst);
ehmsk=edge(hmsk);
ehdst=bwdist(ehmsk);
ehdst(hmsk==1)=-ehdst(hmsk==1);
ehdst=round(ehdst);
rvals=unique(edst(:))';
nrx=NaN(hm,hn);
nry=NaN(hm,hn);
skipring=1;
for r=min(rvals):skipring:max(rvals)
    hrmsk=0*hmsk;
    hrmsk(ehdst==r)=1;
    hrmsk=imfill(hrmsk);
    [~,~,~,coord,normal,nocurv]=curv(-hrmsk);
    if nocurv==0
        nry(sub2ind([hm,hn],coord(2,:),coord(1,:)))=normal(:,2);
        nrx(sub2ind([hm,hn],coord(2,:),coord(1,:)))=normal(:,1);
    end
end
nrx=inpaint_nans(nrx,1);
nry=inpaint_nans(nry,1);
nrx=nrx(m*hndp+1:end-m*hndp,n*hndp+1:end-n*hndp);
nry=nry(m*hndp+1:end-m*hndp,n*hndp+1:end-n*hndp);
nrx=nrx./sqrt(nrx.^2+nry.^2);
nry=nry./sqrt(nrx.^2+nry.^2);
nf=zeros(m,n,3);
nf(:,:,1)=nrx;
nf(:,:,2)=nry;
nf(:,:,3)=zeros(m,n);
zf=zeros(m,n,3);
zf(:,:,1)=zeros(m,n);
zf(:,:,2)=zeros(m,n);
zf(:,:,3)=ones(m,n);
tf=cross(nf,zf);
tgx=squeeze(tf(:,:,1));
tgy=squeeze(tf(:,:,2));
end
function [n_fldx,n_fldy,t_fldx,t_fldy,dst]=nr_tg_field_curv_original(msk)
%%%%%%%%%%%%%%%%%%%%%%% by Agusti Brugues - IBEC  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IMPORTANT: mask msk is assumed to be in the WOUND topology (a hole of zeros in the middle of a grid of ones
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%WARNING:algorithm works best if wound/island is in the middle of the mask - add a frame of pixels all around msk, pn_fldx,pn_fldy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
msz=min(size(msk,1),size(msk,2));
hmsk=ones(size(msk)+2*msz);
hmsk(msz+1:end-msz,msz+1:end-msz)=msk;
hmsk(hmsk~=0)=1; %make sure mask as all ones and zeros
%Open Mask. If there is no mask (wound closed) the mask is done from the last wound center
hmsk=logical(hmsk);
%determine centre of mass of the epithelium
% [indx1,indx2]=find(~hmsk);
% yc=mean(indx1);
% xc=mean(indx2);
[dst,~]=bwdist(msk);
dst=round(dst);
[hdst,~]=bwdist(hmsk);
hdst=round(hdst);
%here i prepare the variables to make the field of normals
%direction vectors
n_fldx=zeros(size(hmsk));
n_fldy=n_fldx;
[~,~,~,Coord,Normal] = curv(hmsk);%compute normal direction
Front=n_fldx;
nrmx=n_fldx;n_fldx(:)=NaN;
nrmy=n_fldy;n_fldy(:)=NaN;
%Determine mask of woundedge
Front(sub2ind(size(hmsk),Coord(2,:),Coord(1,:)))=1;
[DF,LF]=bwdist(Front);
DF=round(DF);
%we introduce the values calculated 4 lines above in the matrices
nrmy(sub2ind(size(n_fldx),Coord(2,:),Coord(1,:)))=Normal(:,2);
nrmx(sub2ind(size(n_fldx),Coord(2,:),Coord(1,:)))=Normal(:,1);
%first we assign to each point the closest vector
%of the leading edge
for ni=1:max(DF(:))
    nrmx(DF==ni)=nrmx(LF(DF==ni)); %assign to each pixel in nrmx(DF==ni) the value nrmx(LF(DF==ni)) of of the closest pixel in variable Front
    nrmy(DF==ni)=nrmy(LF(DF==ni)); %assign to each pixel in nrmy(DF==ni) the value nrmx(LF(DF==ni)) of of the closest pixel in variable Front
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% then we filter them as a function of the distance
for n=1:round(max(DF(:))*.05)
    [im,jm]=ind2sub(size(DF),find(DF==n)); %determine coordinates of pixels on the curve DF==n
    for m=1:size(im,1) %loop on all pixels on the curve
        in=im(m);%y-coordinate of pixel m
        jn=jm(m);%x-coordinate of pixel m
        avnrmx=nrmx(max(in-DF(in,jn),1):min(in+DF(in,jn),size(DF,1)),max(jn-DF(in,jn),1):min(jn+DF(in,jn),size(DF,1)));
        n_fldx(in,jn)=nanmean((avnrmx(:)));
        avnrmy=nrmy(max(in-DF(in,jn),1):min(in+DF(in,jn),size(DF,1)),max(jn-DF(in,jn),1):min(jn+DF(in,jn),size(DF,1)));
        n_fldy(in,jn)=nanmean((avnrmy(:)));
    end
end
%the filtering is time consuming so I do it only for a few points and then I interpolate
%OUTSIDE WOUNDEDGE
nfinal=0;
for n=round(max(DF(:))*.05)+1:10:max(DF(:))
    nfinal=nfinal+n;
    [im,jm]=ind2sub(size(DF),find(DF==n));
    for m=1:size(im,1)
        in=im(m);
        jn=jm(m);
        avnrmx=nrmx(max(in-DF(in,jn),1):min(in+DF(in,jn),size(DF,1)),max(jn-DF(in,jn),1):min(jn+DF(in,jn),size(DF,1)));
        n_fldx(in,jn)=nanmean((avnrmx(:)));
        avnrmy=nrmy(max(in-DF(in,jn),1):min(in+DF(in,jn),size(DF,1)),max(jn-DF(in,jn),1):min(jn+DF(in,jn),size(DF,1)));
        n_fldy(in,jn)=nanmean((avnrmy(:)));
    end
end
%the filtering is time consuming so I do it only for a few points and then I interpolate
%INSIDE WOUNDEDGE
for n=1:5:max(hdst(:))
    [im,jm]=ind2sub(size(hdst),find(hdst==n));
    for m=1:size(im,1)
        in=im(m);
        jn=jm(m);
        avnrmx=nrmx(max(in-hdst(in,jn),1):min(in+hdst(in,jn),size(hdst,1)),max(jn-hdst(in,jn),1):min(jn+hdst(in,jn),size(hdst,1)));
        n_fldx(in,jn)=nanmean((avnrmx(:)));
        avnrmy=nrmy(max(in-hdst(in,jn),1):min(in+hdst(in,jn),size(hdst,1)),max(jn-hdst(in,jn),1):min(jn+hdst(in,jn),size(hdst,1)));
        n_fldy(in,jn)=nanmean((avnrmy(:)));
    end
end
%this is the interpolation
[XIn,YIn]=meshgrid(1:size(n_fldx,2),1:size(n_fldx,1));
[Iy,Ix]=find(~isnan(n_fldx));%&Mask);
n_fldx=griddata(Ix,Iy,n_fldx(sub2ind(size(n_fldy),Iy,Ix)),XIn,YIn,'cubic');
n_fldy=griddata(Ix,Iy,n_fldy(sub2ind(size(n_fldy),Iy,Ix)),XIn,YIn,'cubic');
%fill in corners of the fields
[im,jm]=ind2sub(size(DF),find(isnan(n_fldx)));
for m=1:size(im,1)
    in=im(m);
    jn=jm(m);
    avnrmx=nrmx(max(in-DF(in,jn),1):min(in+DF(in,jn),size(DF,1)),max(jn-DF(in,jn),1):min(jn+DF(in,jn),size(DF,1)));
    n_fldx(in,jn)=nanmean((avnrmx(:)));
    avnrmy=nrmy(max(in-DF(in,jn),1):min(in+DF(in,jn),size(DF,1)),max(jn-DF(in,jn),1):min(jn+DF(in,jn),size(DF,1)));
    n_fldy(in,jn)=nanmean((avnrmy(:)));
end

%decrease one pixel all around n_fldx,n_fldy and go back to msk, n_fldx,n_fldy
n_fldx=n_fldx(msz+1:end-msz,msz+1:end-msz);
n_fldy=n_fldy(msz+1:end-msz,msz+1:end-msz);
%noramlization and cleaning of the vectors
VecMod=sqrt( n_fldx.^2+ n_fldy.^2);
n_fldy= n_fldy./VecMod;
n_fldx= n_fldx./VecMod;
n_fldx(isnan(n_fldx))=0;
n_fldy(isnan(n_fldy))=0;
%compute tangent field (cross product of normal field and the unit vector normal to x-y plane)
n_fldx=(n_fldx(:)); %reshape in column
n_fldy=(n_fldy(:)); %reshape in column
t_fldx=0.*n_fldx;
t_fldy=0.*n_fldx;
for i=1:size(n_fldx,1)
    %the standard basis vectors i, j, and k (i.e. x-, y- and z- axis respectively) satisfy the following equalities:
    % i = j x k
    % j = k x i
    % k = i x j
    %where i=[1,0,0],j=[0,1,0],k=[0,0,1];
    %Here we assume that radial axis plays the vertical y-axis role in the new tern...
    cv=cross([n_fldx(i,1),n_fldy(i,1),0],[0,0,1]);
    t_fldx(i,1)=cv(1);
    t_fldy(i,1)=cv(2);
end
n_fldx=reshape(n_fldx,size(msk,1),size(msk,2)); %nfield points outside wound/island
n_fldy=reshape(n_fldy,size(msk,1),size(msk,2));
t_fldx=reshape(t_fldx,size(msk,1),size(msk,2)); %tfield goes clockwise around wound/island
t_fldy=reshape(t_fldy,size(msk,1),size(msk,2));
end
function [s,S2,CRV,COORD,NORMAL,nocurv]=curv(Mask)
%%%% by Agusti Brugues & Xavier Trepat - IBEC  %%%%

s=0;S2=[];CRV=[];COORD=[];NORMAL=[];nocurv=0;
ContN=contour(Mask,1);
close;
InGap=find(ContN(1,:)<1);
NGap=size(InGap,2);
InGap(NGap+1)=size(ContN,2)+1;
for g=1:NGap
    Cont=ContN(:,InGap(g)+1:InGap(g+1)-2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %     Cont=(Cont(:,2:end-1));
    [Ds,~]=bwdist(~Mask);
    [Ro,Co]=ind2sub(size(Mask),find(Ds==1));
    for n=1:size(Cont,2)
        [~,I]=min((Cont(1,n)-Co).^2+(Cont(2,n)-Ro).^2);
        Cont(:,n)=[Co(I(1));Ro(I(1))];
    end
    % Front=bwperim(Mask);
    % Front([1 end],:)=0;Front(:,[1 end])=0;
    % [R,C]=find(Front);
    % Cont=[C';R'];
    [~,M,~]=unique(Cont','rows');
    Coord=Cont(:,sort(M));
    
    if size(Coord,2)>=9
        Aux=[size(Coord,2)-3:size(Coord,2),1:size(Coord,2),1:4];
        for Cn=1:size(Coord,2)
            D=abs(diff(Coord(1,Aux(Cn:Cn+8)))+1i*diff(Coord(2,Aux(Cn:Cn+8))));%generates the length path
            s=[1,cumsum(D)+1];
            s2(Cn)=sum(D(2:3))/2;   %#ok distance corresponding to the current point
            
            [Px,~]=polyfit(s,Coord(1,Aux(Cn:Cn+8)),2);
            [Py,~]=polyfit(s,Coord(2,Aux(Cn:Cn+8)),2);
            % construct the polynomial
            %                             x=Px(1)*s(3)^2 + Px(2)*s(3) + Px(3);
            %                             y=Py(1)*s(3)^2 + Py(2)*s(3) + Py(3);
            % Compute the derivative
            xder1 =2*Px(1)*s(5) + Px(2);
            yder1 =2*Py(1)*s(5) + Py(2);
            
            Crv(Cn)=(2*Py(1)*xder1-2*Px(1)*yder1)./(xder1^2+yder1^2).^1.5; %#ok compute the radius of curvature
            Normal(Cn,:)=-[-yder1, xder1]/abs(-yder1+1i*xder1); %#ok Normalize the normal
            
        end
        S2=cat(2,S2,s2);
        CRV=cat(2,CRV,Crv);
        COORD=cat(2,COORD,Coord);
        NORMAL=cat(1,NORMAL,Normal);
    else
        disp('not enough points to compute the curvature');
        fprintf('\n');
        nocurv=1;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear Normal Crv s2
end
end
function [bnx,bny,blocs,edst,bwlocs]=edgnrmls(msk,emode,nmode,varargin)
% by Vito Conte on the 9 September 2018

% it computes the normals to the edge of a mask
% msk: mask
% nmode: selects algorithm for computation of normals to the mask edge
% emode: selects what mask edge is adopted
% varargin{1}: interpolation order for gmode=3; (DEFAULT is 2)
% varargin{2}: piece-length (in pixels) in gmode=2,3; (DEFAULT is 9)

if numel(varargin)>0
    n=varargin{1};
    pcwl=varargin{2};
else
    pcwl=9;%number of pixels in curve' piece length (sampling size)
    n=2;%interpolation order
end
if mod(pcwl,2)==0,pcwl=pcwl+1;end%make sure pcwl is odd

switch emode%select edge for mask
    case{1}%user ring 1 as mask edge
        emsk=zeros(size(msk));
        ndst=bwdist(~msk);
        emsk(ndst==1)=1;%ring 1 locations
    case{2}%use mask edge itself
        emsk=edge(msk);%edge mask
end
elocs=find(emsk==1);%edge locations
[edst,bwlocs]=bwdist(emsk);%rings mask
switch nmode
    case{0}%gradient method
        edst(msk==1)=-edst(msk==1);%monotonic rings
        [nx,ny]=gradient(edst);
        bnx=nx(elocs);
        bny=ny(elocs);
        blocs=elocs;
    case{1}%spline method
        [cpts]=contourc(msk,1);
        xlocs=find(cpts(1,:)<1);
        ylocs=find(cpts(2,:)<1);
        cpts(:,[xlocs,ylocs])=[];%oriented contour of mask
        if isequal(cpts(:,1),cpts(:,end)),cpts(:,end)=[];end
        npts=size(cpts,2);
        [ies,jes]=ind2sub(size(msk),elocs);
        %ORIENT MASK EDGE THROUGH ORIENTED CONTOUR
        ecpts=NaN(2,npts);
        for ip=1:npts%project oriented contour on mask edge ==> oriented mask edge
            [~,im]=min((cpts(1,ip)-jes).^2+(cpts(2,ip)-ies).^2);%search for point on edge closest to contour point p
            ecpts(:,ip)=[jes(im(1));ies(im(1))];%closest point on edge
        end
        [~,ulocs,~]=unique(ecpts','rows');%eliminate duplicate points and keep unique locations ulocs
        oepts=ecpts(:,sort(ulocs));%oriented
        olocs=sub2ind(size(msk),oepts(2,:),oepts(1,:));%index locations of oepts
        parcurve=cscvn(oepts);%parametric curve representing mask edge (natural spline fit)
        s=parcurve.breaks;%curve parameter values
        %         cvs=fnval(parcurve,s);%curve values (these should be the same as epts and they are)
        ctvs=fnval(fnder(parcurve),s);%curve tangent values
        ctvs(1,:)=ctvs(1,:)./sqrt(ctvs(1,:).^2+ctvs(2,:).^2);%x-component of unit tangent vectors to the curve
        ctvs(2,:)=ctvs(2,:)./sqrt(ctvs(1,:).^2+ctvs(2,:).^2);%y-component of unit tangent vectors to the curve
        %         figure,quiver(cvs(1,:),cvs(2,:),ctvs(1,:),ctvs(2,:));
        %         figure,quiver(cvs(1,:),cvs(2,:),-ctvs(2,:),ctvs(1,:));
        bnx=-ctvs(2,:);%normal vector's x-component is the opposite of tangen vector's y-component
        bny=ctvs(1,:);%normal vector's y-component is the opposite of tangen vector's x-component
        blocs=olocs;
    case{2}%piece-wise spline (only for closed curves)
        [cpts]=contourc(msk,1);
        xlocs=find(cpts(1,:)<1);
        ylocs=find(cpts(2,:)<1);
        cpts(:,[xlocs,ylocs])=[];%oriented contour of mask
        if isequal(cpts(:,1),cpts(:,end)),cpts(:,end)=[];end
        npts=size(cpts,2);
        [ies,jes]=ind2sub(size(msk),elocs);
        %ORIENT MASK EDGE THROUGH ORIENTED CONTOUR
        ecpts=NaN(2,npts);
        for ip=1:npts%project oriented contour on mask edge ==> oriented mask edge
            [~,im]=min((cpts(1,ip)-jes).^2+(cpts(2,ip)-ies).^2);%search for point on edge closest to contour point p
            ecpts(:,ip)=[jes(im(1));ies(im(1))];%closest point on edge
        end
        [~,ulocs,~]=unique(ecpts','rows');%eliminate duplicate points and keep unique locations ulocs
        oepts=ecpts(:,sort(ulocs));%oriented
        olocs=sub2ind(size(msk),oepts(2,:),oepts(1,:));%index locations of oepts
        nepts=size(oepts,2);
        pcwl=9;%number of pixels in curve' piece length (sampling size)
        if mod(pcwl,2)==0,pcwl=pcwl+1;end%make sure pcwl is odd
        hpcwl=floor(pcwl/2);
        cntrp=hpcwl+1;%central location of the curve's piece
        cv=NaN(2,nepts);
        ctv=NaN(2,nepts);
        for pt=1:nepts
            [osec]=circwrap(1:nepts,pt,hpcwl);
            eptssec=oepts(:,osec);
            parcurvesec=cscvn(eptssec);%parametric curve representing mask edge (natural spline fit)
            s=parcurvesec.breaks;%curve parameter values
            cvs=fnval(parcurvesec,s);
            cv(1,pt)=cvs(1,cntrp);
            cv(2,pt)=cvs(2,cntrp);
            ctvs=fnval(fnder(parcurvesec),s);%curve tangent values
            ctv(1,pt)=ctvs(1,cntrp)./sqrt(ctvs(1,cntrp).^2+ctvs(2,cntrp).^2);%x-component of unit tangent vectors to the curve
            ctv(2,pt)=ctvs(2,cntrp)./sqrt(ctvs(1,cntrp).^2+ctvs(2,cntrp).^2);%y-component of unit tangent vectors to the curve
        end
        %         figure,quiver(cv(1,:),cv(2,:),ctv(1,:),ctv(2,:));
        %         figure,quiver(cv(1,:),cv(2,:),-ctv(2,:),ctv(1,:));
        bnx=-ctv(2,:);%normal vector's x-component is the opposite of tangen vector's y-component
        bny=ctv(1,:);%normal vector's y-component is the opposite of tangen vector's x-component
        blocs=olocs;
    case{3}%piece-wise polynomial
        [cpts]=contourc(msk,1);
        xlocs=find(cpts(1,:)<1);
        ylocs=find(cpts(2,:)<1);
        cpts(:,[xlocs,ylocs])=[];%oriented contour of mask
        if isequal(cpts(:,1),cpts(:,end)),cpts(:,end)=[];end
        npts=size(cpts,2);
        [ies,jes]=ind2sub(size(msk),elocs);
        %ORIENT MASK EDGE THROUGH ORIENTED CONTOUR
        ecpts=NaN(2,npts);
        for ip=1:npts%project oriented contour on mask edge ==> oriented mask edge
            [~,im]=min((cpts(1,ip)-jes).^2+(cpts(2,ip)-ies).^2);%search for point on edge closest to contour point p
            ecpts(:,ip)=[jes(im(1));ies(im(1))];%closest point on edge
        end
        [~,ulocs,~]=unique(ecpts','rows');%eliminate duplicate points and keep unique locations ulocs
        oepts=ecpts(:,sort(ulocs));%oriented
        olocs=sub2ind(size(msk),oepts(2,:),oepts(1,:));%index locations of oepts
        nepts=size(oepts,2);
        hpcwl=floor(pcwl/2);
        cntrp=hpcwl+1;%central location of the curve's piece
        cv=NaN(2,nepts);
        ctv=NaN(2,nepts);
        for pt=1:nepts
            [osec]=circwrap(1:nepts,pt,hpcwl);
            eptssec=oepts(:,osec);
            ex=eptssec(1,:);
            ey=eptssec(2,:);
            s0=0;%initial value of the parameter's interval (curves, normal and tangent vectors do not depend on this choice)
            s=cumsum([s0 sqrt(sum(diff(eptssec,1,2).^2,1))]);%parametric description of the  curve
            e_xt=polyfit(s,ex,n);
            e_yt=polyfit(s,ey,n);
            de_xt=polyder(e_xt);
            de_yt=polyder(e_yt);
            xsv=polyval(e_xt,s);
            ysv=polyval(e_yt,s);
            xder=0;
            yder=0;
            for dg=1:n%compute derivative of polynomial a_n*s^n+a_n-1*s^n-1+...+a_1*s+a_0
                xder=xder+de_xt(dg)*s(cntrp)^(n-dg);
                yder=yder+de_yt(dg)*s(cntrp)^(n-dg);
            end
            cv(1,pt)=xsv(cntrp);
            cv(2,pt)=ysv(cntrp);
            ctv(1,pt)=xder./sqrt(xder.^2+yder.^2);%x-component of unit tangent vectors to the curve
            ctv(2,pt)=yder./sqrt(xder.^2+yder.^2);%y-component of unit tangent vectors to the curve
        end
        %         figure,quiver(cv(1,:),cv(2,:),ctv(1,:),ctv(2,:),0.2);
        %         figure,quiver(cv(1,:),cv(2,:),-ctv(2,:),ctv(1,:),0.2);
        bnx=-ctv(2,:);%normal vector's x-component is the opposite of tangen vector's y-component
        bny=ctv(1,:);%normal vector's y-component is the opposite of tangen vector's x-component
        blocs=olocs;
end
end
function [bnx,bny,blocs]=crvnrmls(cmsk,nmode,varargin)
% by Vito Conte on the 11 October 2019

% it computes the normals to a curve on a grid, given by its mask emsk
% cmsk: mask of the curve (grid locations through which the curve passes)
% nmode: selects algorithm for computation of normals to the ring cuves
% cmode: selects how to interpret the curve
% varargin{1}: interpolation order for nmode=3; (DEFAULT is 2)
% varargin{2}: piece-length (in pixels) in nmode=2,3; (DEFAULT is 9)

if numel(varargin)>0
    n=varargin{1};
    pcwl=varargin{2};
else
    pcwl=9;%number of pixels in curve' piece length (sampling size)
    n=2;%interpolation order
end
if mod(pcwl,2)==0,pcwl=pcwl+1;end%make sure pcwl is odd
msk=imfill(cmsk,'holes');
clocs=find(cmsk==1);%curve locations on the grid
switch nmode %COMPUTE NORMALS TO EDGE depending on SELECTED METHOD nmode
    case{0}%GRADIENT-METHOD
        se=strel('square',3);%structural erosion object made of dilatetype nubmer of pixels
        erd_cmsk=imerode(msk,se)-imerode(imerode(msk,se),se);%first erotion gives the edge ring and second erotion gives the ring below the edge
        dlt_cmsk=imdilate(msk,se)-msk;
        deltarng=-0.1;%value increment from one ring to the other around the edge ring
        gmsk=deltarng*(erd_cmsk+2*cmsk+3*dlt_cmsk);%gmsk is a monotonical ring mask jsut around the curve
        [nx,ny]=gradient(gmsk);%it assumes ring masks vary monotonically
        bnx=nx(clocs);
        bny=ny(clocs);
        blocs=clocs;
    case{1}%NATURAL-SPLINE-FIT METHOD
        [~,ois,ojs,olocs]=orient_curve_on_lattice(cmsk);
        oepts=[ojs';ois'];%points along the oriented curve (x-coordinates on top line and y-coordinates on boottom line)
        parcurve=cscvn(oepts);%parametric curve representing mask edge (natural spline fit for entire curve)
        s=parcurve.breaks;%curve parameter values
        %         cvs=fnval(parcurve,s);%curve values (these should be the same as epts and they are)
        ctvs=fnval(fnder(parcurve),s);%curve tangent values
        ctvs(1,:)=ctvs(1,:)./sqrt(ctvs(1,:).^2+ctvs(2,:).^2);%x-component of unit tangent vectors to the curve
        ctvs(2,:)=ctvs(2,:)./sqrt(ctvs(1,:).^2+ctvs(2,:).^2);%y-component of unit tangent vectors to the curve
        %         figure,quiver(cvs(1,:),cvs(2,:),ctvs(1,:),ctvs(2,:));
        %         figure,quiver(cvs(1,:),cvs(2,:),-ctvs(2,:),ctvs(1,:));
        bnx=-ctvs(2,:);%normal vector's x-component is the opposite of tangen vector's y-component
        bny=ctvs(1,:);%normal vector's y-component is the opposite of tangen vector's x-component
        blocs=olocs;
    case{2}%PIECE-WISE SPLINE FIT METHOD (only for closed curves)
        [~,ois,ojs,olocs]=orient_curve_on_lattice(cmsk);
        oepts=[ojs';ois'];%points along the oriented curve (x-coordinates on top line and y-coordinates on boottom line)
        nepts=size(oepts,2);
        hpcwl=floor(pcwl/2);
        cntrp=hpcwl+1;%central location of the curve's piece
        cv=NaN(2,nepts);
        ctv=NaN(2,nepts);
        for pt=1:nepts
            [osec]=circwrap(1:nepts,pt,hpcwl);
            eptssec=oepts(:,osec);
            parcurvesec=cscvn(eptssec);%parametric curve representing mask edge (natural spline fit)
            s=parcurvesec.breaks;%curve parameter values
            cvs=fnval(parcurvesec,s);
            cv(1,pt)=cvs(1,cntrp);
            cv(2,pt)=cvs(2,cntrp);
            ctvs=fnval(fnder(parcurvesec),s);%curve tangent values
            ctv(1,pt)=ctvs(1,cntrp)./sqrt(ctvs(1,cntrp).^2+ctvs(2,cntrp).^2);%x-component of unit tangent vectors to the curve
            ctv(2,pt)=ctvs(2,cntrp)./sqrt(ctvs(1,cntrp).^2+ctvs(2,cntrp).^2);%y-component of unit tangent vectors to the curve
        end
        bnx=-ctv(2,:);%normal vector's x-component is the opposite of tangen vector's y-component
        bny=ctv(1,:);%normal vector's y-component is the opposite of tangen vector's x-component
        blocs=olocs;
    case{3}%PIECE-WISE POLYNOMIAL
        [~,ois,ojs,olocs]=orient_curve_on_lattice(cmsk);
        oepts=[ojs';ois'];%points along the oriented curve (x-coordinates on top line and y-coordinates on boottom line)
        nepts=size(oepts,2);
        hpcwl=floor(pcwl/2);
        cntrp=hpcwl+1;%central location of the curve's piece
        cv=NaN(2,nepts);
        ctv=NaN(2,nepts);
        for pt=1:nepts
            [osec]=circwrap(1:nepts,pt,hpcwl);
            eptssec=oepts(:,osec);
            ex=eptssec(1,:);
            ey=eptssec(2,:);
            s0=0;%initial value of the parameter's interval (curves, normal and tangent vectors do not depend on this choice)
            s=cumsum([s0 sqrt(sum(diff(eptssec,1,2).^2,1))]);%parametric description of the  curve
            e_xt=polyfit(s,ex,n);
            e_yt=polyfit(s,ey,n);
            de_xt=polyder(e_xt);
            de_yt=polyder(e_yt);
            xsv=polyval(e_xt,s);
            ysv=polyval(e_yt,s);
            xder=0;
            yder=0;
            for dg=1:n%compute derivative of polynomial a_n*s^n+a_n-1*s^n-1+...+a_1*s+a_0
                xder=xder+de_xt(dg)*s(cntrp)^(n-dg);
                yder=yder+de_yt(dg)*s(cntrp)^(n-dg);
            end
            cv(1,pt)=xsv(cntrp);
            cv(2,pt)=ysv(cntrp);
            ctv(1,pt)=xder./sqrt(xder.^2+yder.^2);%x-component of unit tangent vectors to the curve
            ctv(2,pt)=yder./sqrt(xder.^2+yder.^2);%y-component of unit tangent vectors to the curve
        end
        %         figure,quiver(cv(1,:),cv(2,:),ctv(1,:),ctv(2,:),0.2);
        %         figure,quiver(cv(1,:),cv(2,:),-ctv(2,:),ctv(1,:),0.2);
        bnx=-ctv(2,:);%normal vector's x-component is the opposite of tangen vector's y-component
        bny=ctv(1,:);%normal vector's y-component is the opposite of tangen vector's x-component
        blocs=olocs;        
end
end
function [ocmsk,ois,ojs,oclocs]=orient_curve_on_lattice(cmsk)
%it orients the points of a curve on a lattice by projecting the curve on a circle with centre on curve's centroid, which can be oriented via a crescent phase in polar coordinates
%cmsk:  mask of the curve on the lattice (1s indicate the grid locations where the curve passes by)
%ocmsk: mask of the oriented curve on the lattice (integers indicated the sequential order of the grid locations where the curve passes by)
%
%
% m=size(cmsk,1);
% n=size(cmsk,2);
% mid_m=floor(m/2);
% mid_n=floor(n/2);
% CC=regionprops(cmsk,'all');
% rdius=round(CC.Perimeter/pi);%radius of a disk having same perimeter as the curve
% SE=strel('disk',rdius,0);
% cntrmsk=zeros(size(cmsk));
% cntrmsk(mid_m,mid_n)=1;%mask of the centroid of the field of view
% diskmsk=imdilate(cntrmsk,SE);%it creats the mask of a disk centred around the centroid of the field of view
% SE=strel('square',3);
% circmsk=imdilate(diskmsk,SE)-diskmsk;

CC=regionprops(cmsk,'basic');
c=CC.Centroid;%coordinates of the centroid/baricentre
clocs=find(cmsk==1);
[is,js]=ind2sub(size(cmsk),clocs);%lattice coordinates of points of the curve
tis=is-round(c(2));%vertical coordinates of the curve w.r.t centroid
tjs=js-round(c(1));%horizontal coordinates of the curve w.r.t centroid

[theta,~]=cart2pol(tjs,tis);%js are the xs (horizontal coordinates) and is are the upside-down ys (vertical coordinates)
[otheta,indx]=sort(theta);%%sorted thetas in interval [-pi,pi]
% orho=rho(indx);% reordered rhos in function of ordered thetas
% [otjs,otis]=pol2cart(otheta_0_2pi,orho);%cartesian coordinates of the points oriented in angular fasion along the curve
% ocmsk=NaN(size(cmsk));
% ois=otis+c(2);%translate back to cartesian origin
% ojs=otjs+c(1);%translate back to cartesian origin
% oindx=sub2ind(size(cmsk),round(ois),round(ojs));
% ocmsk(oindx)=1:numel(oindx);%lable points of the curve in an ordered way along orientation
ocmsk=NaN(size(cmsk));
oclocs=clocs(indx);
ocmsk(oclocs)=otheta;
[ois,ojs]=ind2sub(size(cmsk),oclocs);%ordered is and js
% imagesc(ocmsk);colorbar
end
function [acircsec]=circwrap(a,p,w)
%a: input array to be treated as circular (before first element there is  last elment and after last element there is first element)
%p: location of a where a symmetric section is wanted
%w: width of the symmetric section of a with circular wrapping
a=a(:);%make sure a is in vertical format
if w<0,error('width of circular section of input array cannot be negative');end
if p<=0,error('at least one location of input array must be chosen');end
if w>=length(a),error('wrapping cannot be longer then array length');end
if p>length(a),error('location cannot be beyond input array');end
wa=[a(end-w+1:end);a;a(1:w)];%expand a by w elements on both sides
acircsec=wa(p:p+2*w);
end
function B=inpaint_nans(A,method)
% INPAINT_NANS: in-paints over nans in an array
% usage: B=INPAINT_NANS(A)          % default method
% usage: B=INPAINT_NANS(A,method)   % specify method used
%
% Solves approximation to one of several pdes to
% interpolate and extrapolate holes in an array
%
% arguments (input):
%   A - nxm array with some NaNs to be filled in
%
%   method - (OPTIONAL) scalar numeric flag - specifies
%       which approach (or physical metaphor to use
%       for the interpolation.) All methods are capable
%       of extrapolation, some are better than others.
%       There are also speed differences, as well as
%       accuracy differences for smooth surfaces.
%
%       methods {0,1,2} use a simple plate metaphor.
%       method  3 uses a better plate equation,
%                 but may be much slower and uses
%                 more memory.
%       method  4 uses a spring metaphor.
%       method  5 is an 8 neighbor average, with no
%                 rationale behind it compared to the
%                 other methods. I do not recommend
%                 its use.
%
%       method == 0 --> (DEFAULT) see method 1, but
%         this method does not build as large of a
%         linear system in the case of only a few
%         NaNs in a large array.
%         Extrapolation behavior is linear.
%
%       method == 1 --> simple approach, applies del^2
%         over the entire array, then drops those parts
%         of the array which do not have any contact with
%         NaNs. Uses a least squares approach, but it
%         does not modify known values.
%         In the case of small arrays, this method is
%         quite fast as it does very little extra work.
%         Extrapolation behavior is linear.
%
%       method == 2 --> uses del^2, but solving a direct
%         linear system of equations for nan elements.
%         This method will be the fastest possible for
%         large systems since it uses the sparsest
%         possible system of equations. Not a least
%         squares approach, so it may be least robust
%         to noise on the boundaries of any holes.
%         This method will also be least able to
%         interpolate accurately for smooth surfaces.
%         Extrapolation behavior is linear.
%
%         Note: method 2 has problems in 1-d, so this
%         method is disabled for vector inputs.
%
%       method == 3 --+ See method 0, but uses del^4 for
%         the interpolating operator. This may result
%         in more accurate interpolations, at some cost
%         in speed.
%
%       method == 4 --+ Uses a spring metaphor. Assumes
%         springs (with a nominal length of zero)
%         connect each node with every neighbor
%         (horizontally, vertically and diagonally)
%         Since each node tries to be like its neighbors,
%         extrapolation is as a constant function where
%         this is consistent with the neighboring nodes.
%
%       method == 5 --+ See method 2, but use an average
%         of the 8 nearest neighbors to any element.
%         This method is NOT recommended for use.
%
%
% arguments (output):
%   B - nxm array with NaNs replaced
%
%
% Example:
%  [x,y] = meshgrid(0:.01:1);
%  z0 = exp(x+y);
%  znan = z0;
%  znan(20:50,40:70) = NaN;
%  znan(30:90,5:10) = NaN;
%  znan(70:75,40:90) = NaN;
%
%  z = inpaint_nans(znan);
%
%
% See also: griddata, interp1
%
% Author: John D'Errico
% e-mail address: woodchips@rochester.rr.com
% Release: 2
% Release date: 4/15/06


% I always need to know which elements are NaN,
% and what size the array is for any method
[n,m]=size(A);
A=A(:);
nm=n*m;
k=isnan(A(:));

% list the nodes which are known, and which will
% be interpolated
nan_list=find(k);
known_list=find(~k);

% how many nans overall
nan_count=length(nan_list);

% convert NaN indices to (r,c) form
% nan_list==find(k) are the unrolled (linear) indices
% (row,column) form
[nr,nc]=ind2sub([n,m],nan_list);

% both forms of index in one array:
% column 1 == unrolled index
% column 2 == row index
% column 3 == column index
nan_list=[nan_list,nr,nc];

% supply default method
if (nargin<2) || isempty(method)
    method = 0;
elseif ~ismember(method,0:5)
    error 'If supplied, method must be one of: {0,1,2,3,4,5}.'
end

% for different methods
switch method
    case 0
        % The same as method == 1, except only work on those
        % elements which are NaN, or at least touch a NaN.
        
        % is it 1-d or 2-d?
        if (m == 1) || (n == 1)
            % really a 1-d case
            work_list = nan_list(:,1);
            work_list = unique([work_list;work_list - 1;work_list + 1]);
            work_list(work_list <= 1) = [];
            work_list(work_list >= nm) = [];
            nw = numel(work_list);
            
            u = (1:nw)';
            fda = sparse(repmat(u,1,3),bsxfun(@plus,work_list,-1:1), ...
                repmat([1 -2 1],nw,1),nw,nm);
        else
            % a 2-d case
            
            % horizontal and vertical neighbors only
            talks_to = [-1 0;0 -1;1 0;0 1];
            neighbors_list=identify_neighbors(n,m,nan_list,talks_to);
            
            % list of all nodes we have identified
            all_list=[nan_list;neighbors_list];
            
            % generate sparse array with second partials on row
            % variable for each element in either list, but only
            % for those nodes which have a row index > 1 or < n
            L = find((all_list(:,2) > 1) & (all_list(:,2) < n));
            nl=length(L);
            if nl>0
                fda=sparse(repmat(all_list(L,1),1,3), ...
                    repmat(all_list(L,1),1,3)+repmat([-1 0 1],nl,1), ...
                    repmat([1 -2 1],nl,1),nm,nm);
            else
                fda=spalloc(n*m,n*m,size(all_list,1)*5);
            end
            
            % 2nd partials on column index
            L = find((all_list(:,3) > 1) & (all_list(:,3) < m));
            nl=length(L);
            if nl>0
                fda=fda+sparse(repmat(all_list(L,1),1,3), ...
                    repmat(all_list(L,1),1,3)+repmat([-n 0 n],nl,1), ...
                    repmat([1 -2 1],nl,1),nm,nm);
            end
        end
        
        % eliminate knowns
        rhs=-fda(:,known_list)*A(known_list);
        k=find(any(fda(:,nan_list(:,1)),2));
        
        % and solve...
        B=A;
        B(nan_list(:,1))=fda(k,nan_list(:,1))\rhs(k);
        
    case 1
        % least squares approach with del^2. Build system
        % for every array element as an unknown, and then
        % eliminate those which are knowns.
        
        % Build sparse matrix approximating del^2 for
        % every element in A.
        
        % is it 1-d or 2-d?
        if (m == 1) || (n == 1)
            % a 1-d case
            u = (1:(nm-2))';
            fda = sparse(repmat(u,1,3),bsxfun(@plus,u,0:2), ...
                repmat([1 -2 1],nm-2,1),nm-2,nm);
        else
            % a 2-d case
            
            % Compute finite difference for second partials
            % on row variable first
            [i,j]=ndgrid(2:(n-1),1:m);
            ind=i(:)+(j(:)-1)*n;
            np=(n-2)*m;
            fda=sparse(repmat(ind,1,3),[ind-1,ind,ind+1], ...
                repmat([1 -2 1],np,1),n*m,n*m);
            
            % now second partials on column variable
            [i,j]=ndgrid(1:n,2:(m-1));
            ind=i(:)+(j(:)-1)*n;
            np=n*(m-2);
            fda=fda+sparse(repmat(ind,1,3),[ind-n,ind,ind+n], ...
                repmat([1 -2 1],np,1),nm,nm);
        end
        
        % eliminate knowns
        rhs=-fda(:,known_list)*A(known_list);
        k=find(any(fda(:,nan_list),2));
        
        % and solve...
        B=A;
        B(nan_list(:,1))=fda(k,nan_list(:,1))\rhs(k);
        
    case 2
        % Direct solve for del^2 BVP across holes
        
        % generate sparse array with second partials on row
        % variable for each nan element, only for those nodes
        % which have a row index > 1 or < n
        
        % is it 1-d or 2-d?
        if (m == 1) || (n == 1)
            % really just a 1-d case
            error('Method 2 has problems for vector input. Please use another method.')
            
        else
            % a 2-d case
            L = find((nan_list(:,2) > 1) & (nan_list(:,2) < n));
            nl=length(L);
            if nl>0
                fda=sparse(repmat(nan_list(L,1),1,3), ...
                    repmat(nan_list(L,1),1,3)+repmat([-1 0 1],nl,1), ...
                    repmat([1 -2 1],nl,1),n*m,n*m);
            else
                fda=spalloc(n*m,n*m,size(nan_list,1)*5);
            end
            
            % 2nd partials on column index
            L = find((nan_list(:,3) > 1) & (nan_list(:,3) < m));
            nl=length(L);
            if nl>0
                fda=fda+sparse(repmat(nan_list(L,1),1,3), ...
                    repmat(nan_list(L,1),1,3)+repmat([-n 0 n],nl,1), ...
                    repmat([1 -2 1],nl,1),n*m,n*m);
            end
            
            % fix boundary conditions at extreme corners
            % of the array in case there were nans there
            if ismember(1,nan_list(:,1))
                fda(1,[1 2 n+1])=[-2 1 1];
            end
            if ismember(n,nan_list(:,1))
                fda(n,[n, n-1,n+n])=[-2 1 1];
            end
            if ismember(nm-n+1,nan_list(:,1))
                fda(nm-n+1,[nm-n+1,nm-n+2,nm-n])=[-2 1 1];
            end
            if ismember(nm,nan_list(:,1))
                fda(nm,[nm,nm-1,nm-n])=[-2 1 1];
            end
            
            % eliminate knowns
            rhs=-fda(:,known_list)*A(known_list);
            
            % and solve...
            B=A;
            k=nan_list(:,1);
            B(k)=fda(k,k)\rhs(k);
            
        end
        
    case 3
        % The same as method == 0, except uses del^4 as the
        % interpolating operator.
        
        % del^4 template of neighbors
        talks_to = [-2 0;-1 -1;-1 0;-1 1;0 -2;0 -1; ...
            0 1;0 2;1 -1;1 0;1 1;2 0];
        neighbors_list=identify_neighbors(n,m,nan_list,talks_to);
        
        % list of all nodes we have identified
        all_list=[nan_list;neighbors_list];
        
        % generate sparse array with del^4, but only
        % for those nodes which have a row & column index
        % >= 3 or <= n-2
        L = find( (all_list(:,2) >= 3) & ...
            (all_list(:,2) <= (n-2)) & ...
            (all_list(:,3) >= 3) & ...
            (all_list(:,3) <= (m-2)));
        nl=length(L);
        if nl>0
            % do the entire template at once
            fda=sparse(repmat(all_list(L,1),1,13), ...
                repmat(all_list(L,1),1,13) + ...
                repmat([-2*n,-n-1,-n,-n+1,-2,-1,0,1,2,n-1,n,n+1,2*n],nl,1), ...
                repmat([1 2 -8 2 1 -8 20 -8 1 2 -8 2 1],nl,1),nm,nm);
        else
            fda=spalloc(n*m,n*m,size(all_list,1)*5);
        end
        
        % on the boundaries, reduce the order around the edges
        L = find((((all_list(:,2) == 2) | ...
            (all_list(:,2) == (n-1))) & ...
            (all_list(:,3) >= 2) & ...
            (all_list(:,3) <= (m-1))) | ...
            (((all_list(:,3) == 2) | ...
            (all_list(:,3) == (m-1))) & ...
            (all_list(:,2) >= 2) & ...
            (all_list(:,2) <= (n-1))));
        nl=length(L);
        if nl>0
            fda=fda+sparse(repmat(all_list(L,1),1,5), ...
                repmat(all_list(L,1),1,5) + ...
                repmat([-n,-1,0,+1,n],nl,1), ...
                repmat([1 1 -4 1 1],nl,1),nm,nm);
        end
        
        L = find( ((all_list(:,2) == 1) | ...
            (all_list(:,2) == n)) & ...
            (all_list(:,3) >= 2) & ...
            (all_list(:,3) <= (m-1)));
        nl=length(L);
        if nl>0
            fda=fda+sparse(repmat(all_list(L,1),1,3), ...
                repmat(all_list(L,1),1,3) + ...
                repmat([-n,0,n],nl,1), ...
                repmat([1 -2 1],nl,1),nm,nm);
        end
        
        L = find( ((all_list(:,3) == 1) | ...
            (all_list(:,3) == m)) & ...
            (all_list(:,2) >= 2) & ...
            (all_list(:,2) <= (n-1)));
        nl=length(L);
        if nl>0
            fda=fda+sparse(repmat(all_list(L,1),1,3), ...
                repmat(all_list(L,1),1,3) + ...
                repmat([-1,0,1],nl,1), ...
                repmat([1 -2 1],nl,1),nm,nm);
        end
        
        % eliminate knowns
        rhs=-fda(:,known_list)*A(known_list);
        k=find(any(fda(:,nan_list(:,1)),2));
        
        % and solve...
        B=A;
        B(nan_list(:,1))=fda(k,nan_list(:,1))\rhs(k);
        
    case 4
        % Spring analogy
        % interpolating operator.
        
        % list of all springs between a node and a horizontal
        % or vertical neighbor
        hv_list=[-1 -1 0;1 1 0;-n 0 -1;n 0 1];
        hv_springs=[];
        for i=1:4
            hvs=nan_list+repmat(hv_list(i,:),nan_count,1);
            k=(hvs(:,2)>=1) & (hvs(:,2)<=n) & (hvs(:,3)>=1) & (hvs(:,3)<=m);
            hv_springs=[hv_springs;[nan_list(k,1),hvs(k,1)]];
        end
        
        % delete replicate springs
        hv_springs=unique(sort(hv_springs,2),'rows');
        
        % build sparse matrix of connections, springs
        % connecting diagonal neighbors are weaker than
        % the horizontal and vertical springs
        nhv=size(hv_springs,1);
        springs=sparse(repmat((1:nhv)',1,2),hv_springs, ...
            repmat([1 -1],nhv,1),nhv,nm);
        
        % eliminate knowns
        rhs=-springs(:,known_list)*A(known_list);
        
        % and solve...
        B=A;
        B(nan_list(:,1))=springs(:,nan_list(:,1))\rhs;
        
    case 5
        % Average of 8 nearest neighbors
        
        % generate sparse array to average 8 nearest neighbors
        % for each nan element, be careful around edges
        fda=spalloc(n*m,n*m,size(nan_list,1)*9);
        
        % -1,-1
        L = find((nan_list(:,2) > 1) & (nan_list(:,3) > 1));
        nl=length(L);
        if nl>0
            fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
                repmat(nan_list(L,1),1,2)+repmat([-n-1, 0],nl,1), ...
                repmat([1 -1],nl,1),n*m,n*m);
        end
        
        % 0,-1
        L = find(nan_list(:,3) > 1);
        nl=length(L);
        if nl>0
            fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
                repmat(nan_list(L,1),1,2)+repmat([-n, 0],nl,1), ...
                repmat([1 -1],nl,1),n*m,n*m);
        end
        
        % +1,-1
        L = find((nan_list(:,2) < n) & (nan_list(:,3) > 1));
        nl=length(L);
        if nl>0
            fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
                repmat(nan_list(L,1),1,2)+repmat([-n+1, 0],nl,1), ...
                repmat([1 -1],nl,1),n*m,n*m);
        end
        
        % -1,0
        L = find(nan_list(:,2) > 1);
        nl=length(L);
        if nl>0
            fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
                repmat(nan_list(L,1),1,2)+repmat([-1, 0],nl,1), ...
                repmat([1 -1],nl,1),n*m,n*m);
        end
        
        % +1,0
        L = find(nan_list(:,2) < n);
        nl=length(L);
        if nl>0
            fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
                repmat(nan_list(L,1),1,2)+repmat([1, 0],nl,1), ...
                repmat([1 -1],nl,1),n*m,n*m);
        end
        
        % -1,+1
        L = find((nan_list(:,2) > 1) & (nan_list(:,3) < m));
        nl=length(L);
        if nl>0
            fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
                repmat(nan_list(L,1),1,2)+repmat([n-1, 0],nl,1), ...
                repmat([1 -1],nl,1),n*m,n*m);
        end
        
        % 0,+1
        L = find(nan_list(:,3) < m);
        nl=length(L);
        if nl>0
            fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
                repmat(nan_list(L,1),1,2)+repmat([n, 0],nl,1), ...
                repmat([1 -1],nl,1),n*m,n*m);
        end
        
        % +1,+1
        L = find((nan_list(:,2) < n) & (nan_list(:,3) < m));
        nl=length(L);
        if nl>0
            fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
                repmat(nan_list(L,1),1,2)+repmat([n+1, 0],nl,1), ...
                repmat([1 -1],nl,1),n*m,n*m);
        end
        
        % eliminate knowns
        rhs=-fda(:,known_list)*A(known_list);
        
        % and solve...
        B=A;
        k=nan_list(:,1);
        B(k)=fda(k,k)\rhs(k);
        
end

% all done, make sure that B is the same shape as
% A was when we came in.
B=reshape(B,n,m);
end
function neighbors_list=identify_neighbors(n,m,nan_list,talks_to)
% identify_neighbors: identifies all the neighbors of
%   those nodes in nan_list, not including the nans
%   themselves
%
% arguments (input):
%  n,m - scalar - [n,m]=size(A), where A is the
%      array to be interpolated
%  nan_list - array - list of every nan element in A
%      nan_list(i,1) == linear index of i'th nan element
%      nan_list(i,2) == row index of i'th nan element
%      nan_list(i,3) == column index of i'th nan element
%  talks_to - px2 array - defines which nodes communicate
%      with each other, i.e., which nodes are neighbors.
%
%      talks_to(i,1) - defines the offset in the row
%                      dimension of a neighbor
%      talks_to(i,2) - defines the offset in the column
%                      dimension of a neighbor
%
%      For example, talks_to = [-1 0;0 -1;1 0;0 1]
%      means that each node talks only to its immediate
%      neighbors horizontally and vertically.
%
% arguments(output):
%  neighbors_list - array - list of all neighbors of
%      all the nodes in nan_list

if ~isempty(nan_list)
    % use the definition of a neighbor in talks_to
    nan_count=size(nan_list,1);
    talk_count=size(talks_to,1);
    
    nn=zeros(nan_count*talk_count,2);
    j=[1,nan_count];
    for i=1:talk_count
        nn(j(1):j(2),:)=nan_list(:,2:3) + ...
            repmat(talks_to(i,:),nan_count,1);
        j=j+nan_count;
    end
    
    % drop those nodes which fall outside the bounds of the
    % original array
    L = (nn(:,1)<1)|(nn(:,1)>n)|(nn(:,2)<1)|(nn(:,2)>m);
    nn(L,:)=[];
    
    % form the same format 3 column array as nan_list
    neighbors_list=[sub2ind([n,m],nn(:,1),nn(:,2)),nn];
    
    % delete replicates in the neighbors list
    neighbors_list=unique(neighbors_list,'rows');
    
    % and delete those which are also in the list of NaNs.
    neighbors_list=setdiff(neighbors_list,nan_list,'rows');
    
else
    neighbors_list=[];
end
end
function [msk]=loadmask(usemode)
switch usemode
    case{0,1}% wound or island mask
        msk=[...
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
        if usemode==1%transform wound into island
            msk=logical(msk); %make sure only zeros and ones are there in the mask
            msk=~msk;
        end%transform wound into island
    case{2,3}%strip or scratch mask
        msk=...
            [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
        if usemode==3%transform strip into stracth
            msk=logical(msk); %make sure only zeros and ones are there in the mask
            msk=~msk;
        end
    case{4}%TWO WOUNDS
        msk=...
            [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
    case{5}%TWO ISLANDS
        msk=[...
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    case{6}%WOUND-ISLAND
        msk=[...
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
end
end
