function [ errorCode ] = matlabMail( targetaddress, message )
%matlabMail send an email with a message
%   Useful to let you know when matlab finishes a long computation.
%   Googled/copy paste by Ethan S.

errorCode = 0;

myaddress = 'matlab.notifications.medix@gmail.com';
mypassword = 'ethan_is_an_ai';

setpref('Internet','E_mail',myaddress);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',myaddress);
setpref('Internet','SMTP_Password',mypassword);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

sendmail(targetaddress, 'Matlab Notification', message);

end