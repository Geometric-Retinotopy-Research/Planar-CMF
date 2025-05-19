function nmse = calcNRMSE(y,x)

nmse=mse(x,y)/mean(abs(x));

end