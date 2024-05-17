x=readtable("../datos_maiz.csv");
y=x.Last;
figure(1)
plot(x.Date,x.Last)
levelForReconstruction = [false,true,true,true,true,true,true,true,true,true,true,true];

bandas=12;

[mra,cfs,wfb,info] = ewt(y, ...
    MaxNumPeaks=bandas, ...
    SegmentMethod='geomean', ...
    FrequencyResolution=0.00052611, ...
    LogSpectrum=false);

figure(2);
t = (0:length(y)-1);
title('MRA of Signal')
axis tight
for k=1:bandas
    subplot(bandas+1,1,k+1)
    plot(t,mra(:,k))
    ylabel(['D ',num2str(k)])
    %axis tight

    fecha_formateada=datestr(x.Date, 'yyyy-mm-dd');
    DatosFinal=table(fecha_formateada,mra(:,k),'VariableNames',{'Fecha','Precio_Cierre'});
    nombre=sprintf("ewt_modes/modo_%d.csv",k);
    writetable(DatosFinal,nombre)

end
xlabel('Time (s)')

saveas(gcf, 'imagenes/Descompocision EWT.png');


y2 = sum(mra(:,levelForReconstruction),2);
figure(3)
plot(x.Date,y2);
title('Datos reconstruidos EWT');
saveas(gcf, 'imagenes/Reconstruccion EWT.png');

fecha_formateada=datestr(x.Date, 'yyyy-mm-dd');
DatosFinal=table(fecha_formateada,y2,'VariableNames',{'Fecha','Precio_Cierre'});
writetable(DatosFinal,"EWT_datos.csv")